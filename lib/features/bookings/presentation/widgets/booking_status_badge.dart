import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'awaiting_advance':
      case 'pending':
      case 'pending_advance':
        bg = AppColors.surfaceMintPill;
        fg = AppColors.brandDeep;
        label = 'Awaiting advance';
        break;
      case 'in_progress':
      case 'inprogress':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        label = 'In progress';
        break;
      case 'confirmed':
        bg = AppColors.surfaceMintSubtle;
        fg = AppColors.primary;
        label = 'Confirmed';
        break;
      case 'completed':
        bg = AppColors.surfaceMuted;
        fg = AppColors.textSecondary;
        label = 'Completed';
        break;
      case 'cancelled':
        bg = AppColors.errorContainer;
        fg = AppColors.onErrorContainer;
        label = 'Cancelled';
        break;
      case 'disputed':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFF991B1B);
        label = 'Disputed';
        break;
      default:
        bg = AppColors.surfaceMuted;
        fg = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          color: fg,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
