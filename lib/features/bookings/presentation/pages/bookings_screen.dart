import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../widgets/booking_card.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_providers.dart';

enum _BookingFilter {
  all('All'),
  upcoming('Upcoming'),
  past('Past'),
  cancelled('Cancelled');

  const _BookingFilter(this.label);
  final String label;

  bool matches(BookingModel b) {
    switch (this) {
      case _BookingFilter.all:
        return true;
      case _BookingFilter.upcoming:
        return b.isUpcoming;
      case _BookingFilter.past:
        return !b.isCancelled && b.isPast;
      case _BookingFilter.cancelled:
        return b.isCancelled;
    }
  }
}

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  _BookingFilter _filter = _BookingFilter.all;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load bookings', style: AppTextStyles.headlineSm),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(bookingsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (allBookings) {
          final bookings = allBookings.where(_filter.matches).toList();
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(bookingsProvider.notifier).refresh();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                Text('My bookings', style: AppTextStyles.headlineMd),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in _BookingFilter.values) ...[
                        AppFilterChip(
                          label: f.label,
                          isSelected: f == _filter,
                          variant: FilterChipVariant.mint,
                          onTap: () => setState(() => _filter = f),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (bookings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'No ${_filter == _BookingFilter.all ? '' : '${_filter.label.toLowerCase()} '}bookings',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  )
                else
                  for (final b in bookings) ...[
                    BookingCard(
                      booking: b,
                      onTap: () async {
                        await context.push('/bookings/${b.id}');
                        if (mounted) {
                          ref.read(bookingsProvider.notifier).refresh();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}
