import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeTrustBadges extends StatelessWidget {
  const HomeTrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.trustBadgeBg,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.trustBadgeIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Verified businesses',
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Every business checked',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.trustBadgeIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Help next door',
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'A local partner near you',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
