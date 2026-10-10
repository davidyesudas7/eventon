import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/vendor_review.dart';

class VendorReviewItem extends StatelessWidget {
  const VendorReviewItem({
    super.key,
    required this.review,
  });

  final VendorReview review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                size: 14,
                color: Color(0xFF0F766E),
              ),
              const SizedBox(width: 4),
              Text(
                review.rating % 1 == 0
                    ? review.rating.toInt().toString()
                    : review.rating.toString(),
                style: const TextStyle(
                  color: Color(0xFF0F766E),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (review.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              review.comment,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
