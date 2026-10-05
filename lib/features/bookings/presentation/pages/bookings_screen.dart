import 'package:eventon/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
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
                  _FilterPill(
                    label: f.label,
                    selected: f == _filter,
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
              _BookingCard(
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

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surfaceMintPill : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.borderSubtle,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BookingStatusBadge(status: booking.status),
                  Text(
                    formatBookingDate(booking.date),
                    style: AppTextStyles.bodyMd,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(booking.serviceName, style: AppTextStyles.bodyMd),
              const SizedBox(height: 4),
              Text(
                formatRupees(booking.amount),
                style: AppTextStyles.headlineSm.copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BookingStatus.awaitingAdvance => (
        AppColors.surfaceMintPill,
        const Color(0xFF115E59),
      ),
      BookingStatus.confirmed => (
        AppColors.surfaceMintSubtle,
        AppColors.primary,
      ),
      BookingStatus.completed => (
        AppColors.surfaceMuted,
        AppColors.textSecondary,
      ),
      BookingStatus.cancelled => (
        AppColors.errorContainer,
        AppColors.onErrorContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelMd.copyWith(
          color: fg,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
