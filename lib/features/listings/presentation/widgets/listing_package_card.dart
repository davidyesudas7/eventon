import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/package_model.dart';

class ListingPackageCard extends StatelessWidget {
  const ListingPackageCard({
    super.key,
    required this.package,
    required this.onBook,
  });

  final PackageModel package;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: AppTextStyles.headlineSm.copyWith(fontSize: 17),
                    ),
                    if (package.durationLabel != null) ...[
                      const SizedBox(height: 2),
                      Text(package.durationLabel!, style: AppTextStyles.bodyMd),
                    ],
                  ],
                ),
              ),
              Text(
                formatRupees(package.price.toInt()),
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          for (final f in package.inclusions)
            _FeatureRow(text: f, isIncluded: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onBook,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderStrong),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Book now',
                style: AppTextStyles.labelLg.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text, required this.isIncluded});

  final String text;
  final bool isIncluded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isIncluded ? Icons.check : Icons.close,
            size: 16,
            color: isIncluded ? AppColors.primary : AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodyMd.copyWith(
              color: isIncluded ? AppColors.textSecondary : AppColors.textMuted,
              decoration: isIncluded ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
