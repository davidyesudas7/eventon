import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/outlined_card.dart';
import '../../domain/entities/booking.dart';
import 'booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedCard(
      padding: const EdgeInsets.all(16),
      radius: 14,
      onTap: onTap,
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
    );
  }
}
