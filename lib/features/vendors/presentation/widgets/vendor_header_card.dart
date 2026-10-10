import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/vendor_profile.dart';

class VendorHeaderCard extends StatelessWidget {
  const VendorHeaderCard({
    super.key,
    required this.profile,
    this.ratingAvg,
    this.totalReviews,
  });

  final VendorProfile profile;
  final double? ratingAvg;
  final int? totalReviews;

  @override
  Widget build(BuildContext context) {
    final effectiveRatingAvg = ratingAvg ?? profile.ratingAvg;
    final effectiveReviewCount = totalReviews ?? profile.ratingCount ?? 0;
    final hasReviews = effectiveReviewCount > 0 && effectiveRatingAvg != null && effectiveRatingAvg > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar
          ClipOval(
            child: Container(
              width: 72,
              height: 72,
              color: const Color(0xFFE2EDEA),
              child: profile.profilePhotoUrl != null &&
                      profile.profilePhotoUrl!.trim().isNotEmpty
                  ? Image.network(
                      profile.profilePhotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: const Color(0xFFE2EDEA)),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.displayName,
                  style: AppTextStyles.headlineMd.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                if (profile.subtitle != null) ...[
                  Text(
                    profile.subtitle!,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                ] else if (!hasReviews) ...[
                  Text(
                    'New on EventOn',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
                if (hasReviews) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFF0F766E),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        effectiveRatingAvg.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Color(0xFF0F766E),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ' · $effectiveReviewCount ${effectiveReviewCount == 1 ? 'review' : 'reviews'}',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
