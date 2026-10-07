import 'package:eventon/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_status_badge.dart';
import '../../domain/entities/booking.dart';

enum _BookingFilter {
  all('All'),
  upcoming('Upcoming'),
  past('Past'),
  cancelled('Cancelled');

  const _BookingFilter(this.label);
  final String label;

  bool matches(Booking b) {
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

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  _BookingFilter _filter = _BookingFilter.all;

  @override
  Widget build(BuildContext context) {
    final bookings = mockBookings.where(_filter.matches).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(),
      body: ListView(
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
                onTap: () => context.push('/bookings/${b.id}', extra: b),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}
