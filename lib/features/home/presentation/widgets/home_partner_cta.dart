import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomePartnerCTA extends StatelessWidget {
  const HomePartnerCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.partnerCtaBg,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Run an event business?',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.surfaceWhite,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'List it on EventOn — it\'s free to join',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.surfaceWhite,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Material(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                child: Text(
                  'Join now',
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.partnerCtaBg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
