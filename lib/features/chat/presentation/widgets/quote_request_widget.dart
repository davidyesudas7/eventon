import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuoteRequestWidget extends StatelessWidget {
  final String quoteRequestId;

  const QuoteRequestWidget({
    super.key,
    this.quoteRequestId = '1', // default fallback for hardcoded demo
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUOTE REQUEST · 2 BUSINESSES ASKED',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Event date',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fri, 9 October 2026',
            style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Guests',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '200',
            style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'engagement is about for 200 guest',
            style: AppTextStyles.bodyMd,
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  AppRoutes.quoteRequestDetails,
                  pathParameters: {'id': quoteRequestId},
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Compare every business's quote",
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
