import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/domain/entities/occasion.dart';
import '../../../categories/presentation/providers/categories_providers.dart';

class HomeOccasionsSection extends ConsumerWidget {
  const HomeOccasionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occasionsAsync = ref.watch(occasionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan by occasion',
          style: AppTextStyles.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: occasionsAsync.when(
            data: (occasions) => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: occasions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final occasion = occasions[index];
                return _OccasionCard(occasion: occasion);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text(
                'Failed to load occasions',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OccasionCard extends StatelessWidget {
  const _OccasionCard({required this.occasion});

  final Occasion occasion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.occasion,
          pathParameters: {'slug': occasion.slug},
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cardPlaceholder,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: occasion.coverUrl != null
                  ? Image.network(occasion.coverUrl!, fit: BoxFit.cover)
                  : Container(color: AppColors.cardPlaceholder),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.overlayMedium,
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    occasion.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${occasion.categoryCount} services',
                    style: AppTextStyles.labelSm.copyWith(
                      color: const Color(0xFFC5C9D3),
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
