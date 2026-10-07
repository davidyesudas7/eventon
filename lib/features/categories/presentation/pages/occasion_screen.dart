import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/categories_providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/occasion_detail.dart';
import '../widgets/category_icon.dart';

class OccasionScreen extends ConsumerWidget {
  final String slug;

  const OccasionScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occasionAsync = ref.watch(occasionDetailProvider(slug));

    return Scaffold(
      backgroundColor: Colors.white,
      body: occasionAsync.when(
        data: (occasion) => CustomScrollView(
          slivers: [
            _buildHero(context, occasion),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What you'll need",
                      style: AppTextStyles.headlineMd.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${occasion.categories.length} services — tap one to see businesses near you.',
                      style: AppTextStyles.bodyMd,
                    ),
                    const SizedBox(height: 20),
                    for (final category in occasion.categories) ...[
                      _ServiceCard(
                        category: category,
                        onTap: () {
                          // pop to home, then switch tab and select category
                          context.pop();
                          context.go('/explore', extra: category.id);
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Couldn\'t load occasion', style: AppTextStyles.labelLg),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(occasionDetailProvider(slug)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, OccasionDetail occasion) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: const Color(0xFF131718),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: InkWell(
            onTap: () => context.pop(),
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (occasion.coverUrl != null && occasion.coverUrl!.isNotEmpty)
              Image.network(occasion.coverUrl!, fit: BoxFit.cover)
            else
              Container(color: const Color(0xFF23292B)),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.transparent, Colors.black87],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    occasion.name,
                    style: AppTextStyles.headlineXl.copyWith(
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  if (occasion.tagline != null &&
                      occasion.tagline!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      occasion.tagline!,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMintPill,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: CategoryIcon(
                    iconName: category.icon,
                    iconUrl: category.iconUrl,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: AppTextStyles.headlineSm.copyWith(
                        color: const Color(0xFF1F2428),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.description,
                      style: AppTextStyles.bodySm.copyWith(
                        color: const Color(0xFF6A737D),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFADB5BD),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
