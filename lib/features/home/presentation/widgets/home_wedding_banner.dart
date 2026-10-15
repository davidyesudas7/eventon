import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/domain/entities/occasion.dart';
import '../../../categories/presentation/providers/categories_providers.dart';

class HomeWeddingBanner extends ConsumerWidget {
  const HomeWeddingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occasionsAsync = ref.watch(occasionsProvider);
    final occasions = occasionsAsync.asData?.value;
    final Occasion? occasion =
        (occasions != null && occasions.isNotEmpty) ? occasions.first : null;

    final String slug = occasion?.slug ?? 'wedding';
    final String occasionName = (occasion?.name ?? 'Wedding').toUpperCase();
    final String tagText = occasionName.contains('PLANNING')
        ? occasionName
        : 'PLANNING A $occasionName?';
    final String? tagline = occasion?.tagline?.trim();
    final String headlineText = (tagline != null && tagline.isNotEmpty)
        ? tagline
        : 'Everything a Kerala wedding needs, in one list';
    final int categoryCount =
        (occasion?.categoryCount ?? 0) > 0 ? occasion!.categoryCount : 16;
    final String buttonText =
        'See all $categoryCount ${categoryCount == 1 ? 'service' : 'services'} \u2192';
    final String? coverUrl = occasion?.coverUrl?.trim();

    return GestureDetector(
      onTap: () => context.push('/home/occasion/$slug'),
      child: Container(
        width: double.infinity,
        height: 290,
        color: AppColors.occasionCard,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (coverUrl != null && coverUrl.isNotEmpty)
              Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.occasionCard),
              )
            else
              Container(color: AppColors.occasionCard),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.transparent,
                    AppColors.transparent,
                    AppColors.overlayMedium,
                    AppColors.overlayStrong,
                  ],
                  stops: [0.0, 0.25, 0.60, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tagText,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.promoBannerTag,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    headlineText,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.surfaceWhite,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: () => context.push('/home/occasion/$slug'),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          buttonText,
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
