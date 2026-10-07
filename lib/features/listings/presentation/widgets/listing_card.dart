import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pill_badge.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.price,
    this.distance,
    this.imageUrl,
    this.width,
    this.isVerified = false,
    this.hasAddedBadge = false,
    this.hasQuoteButton = false,
    required this.onTap,
    this.onQuoteTap,
  });

  final String id;
  final String title;
  final String category;
  final String? description;
  final String? price;
  final String? distance;
  final String? imageUrl;
  final double? width;
  final bool isVerified;
  final bool hasAddedBadge;
  final bool hasQuoteButton;
  final VoidCallback onTap;
  final VoidCallback? onQuoteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width == null ? 16 : 24),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: width != null
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: width != null ? 176 : 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: imageUrl != null 
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!), 
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(width == null ? 16 : 24),
                ),
              ),
              child: Stack(
                children: [
                  if (isVerified)
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: PillBadge(
                        label: 'Verified',
                        icon: Icons.verified,
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary, // Icon uses AppColors.success directly in original, let's just approximate, or pass custom widget
                      ),
                    ),
                  if (hasAddedBadge)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: onQuoteTap,
                        child: PillBadge(
                          label: 'Added',
                          icon: Icons.check,
                          backgroundColor: AppColors.price.withValues(alpha: 0.9),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (hasQuoteButton)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: onQuoteTap,
                        child: PillBadge(
                          label: '+ Quote',
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                          foregroundColor: AppColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headlineSm.copyWith(
                        fontSize: width == null ? 18 : null),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (price != null || distance != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (price != null)
                          Text(
                            price!,
                            style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.price,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        if (distance != null)
                          Text(
                            distance!,
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
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
      ),
    );
  }
}
