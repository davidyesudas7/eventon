import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/booking.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BookingStatus.awaitingAdvance => (
        AppColors.surfaceMintPill,
        AppColors.brandDeep,
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
