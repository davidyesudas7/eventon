import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../categories/presentation/widgets/category_grid.dart';
import '../widgets/home_hero_gradient.dart';
import '../widgets/home_occasions_section.dart';
import '../widgets/home_partner_cta.dart';
import '../widgets/home_popular_near_you_section.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_top_hero.dart';
import '../widgets/home_trust_badges.dart';
import '../widgets/home_wedding_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: AppColors.heroGradientBase,
            pinned: true,
            toolbarHeight: 0.0,
            automaticallyImplyLeading: false,
            expandedHeight: 210,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: CustomPaint(
                painter: const HomeHeroGradientPainter(
                  topOffset: 0.0,
                  totalHeight: 350.0,
                ),
                child: const HomeTopHero(),
              ),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(72),
              child: HomeSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: CustomPaint(
              painter: const HomeHeroGradientPainter(
                isBottom: true,
                topOffset: 250.0,
                totalHeight: 520.0,
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: HomeOccasionsSection(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildMainContent(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      color: AppColors.heroBanner, // Extends the dark hero background behind the radius
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Browse by service',
                        style: AppTextStyles.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/home/all-services'),
                        child: Text(
                          'See all',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  categoriesAsync.when(
                    data: (categories) =>
                        CategoryGrid(categories: categories, limit: 8),
                    loading: () => const CategoryGridSkeleton(count: 8),
                    error: (err, stack) => Center(
                      child: Text(
                        'Couldn\'t load services',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const HomeWeddingBanner(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: HomePopularNearYouSection(),
            ),
            const HomeTrustBadges(),
            const HomePartnerCTA(),
          ],
        ),
      ),
    );
  }
}
