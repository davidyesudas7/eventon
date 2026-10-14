import 'dart:convert';
import 'package:eventon/features/auth/presentation/providers/auth_providers.dart';
import 'package:eventon/features/explore/presentation/providers/explore_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../categories/domain/entities/occasion.dart';
import '../../../categories/presentation/widgets/category_grid.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../listings/presentation/widgets/listing_card.dart';
import '../../../profile/presentation/providers/home_location_provider.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_hero_gradient.dart';
import '../../../chat/presentation/providers/chat_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure socket and conversation API are active when entering home screen (for logged-in users only)
    final authState = ref.watch(authControllerProvider);
    if (authState is AuthStateAuthenticated) {
      ref.watch(chatSyncProvider);
    }

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
                child: _buildTopHeroContent(context, ref),
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
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: _buildOccasionSection(ref),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildMainContent(context, ref)),
        ],
      ),
    );
  }

  Widget _buildTopHeroContent(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final locationState = ref.watch(homeLocationStateProvider);

    String greeting = 'Hi there,';
    String? initial;
    if (authState is AuthStateAuthenticated) {
      greeting = 'Hi ${authState.user.fullName},';
      if (authState.user.fullName.isNotEmpty) {
        initial = authState.user.fullName[0].toUpperCase();
      }
    }

    String locationTitle = 'Set your location';
    String locationSubtitle = 'See businesses near you';

    if (locationState.value != null) {
      final loc = locationState.value!;
      if (loc.lsgDetails != null && loc.lsgDetails!.name.isNotEmpty) {
        locationTitle = loc.lsgDetails!.name;
        locationSubtitle = loc.lsgDetails!.district;
      } else {
        locationTitle = loc.pincodeDetails.officeName;
        locationSubtitle = loc.pincodeDetails.district;
      }
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Picker and Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              locationTitle,
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textPrimary,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          locationSubtitle,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (initial != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      initial,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Greeting
            Text(
              greeting,
              style: AppTextStyles.headlineLg.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                'what are we celebrating?',
                style: AppTextStyles.headlineLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccasionSection(WidgetRef ref) {
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
                return _buildOccasionCard(context, occasion);
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

  Widget _buildOccasionCard(BuildContext context, Occasion occasion) {
    return GestureDetector(
      onTap: () {
        context.push('/home/occasion/${occasion.slug}');
      },
      child: Container(
        width: 145,
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
                    AppColors.overlayDark,
                    AppColors.overlayMedium,
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    occasion.name,
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${occasion.categoryCount} services',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.surfaceMintSubtle,
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

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      color: AppColors
          .heroBanner, // Extends the dark hero background behind the radius
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceBase,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
            _buildPlanningWeddingBanner(context, ref),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: _PopularNearYouSection(),
            ),
            _buildTrustBadges(),
            _buildPartnerCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanningWeddingBanner(BuildContext context, WidgetRef ref) {
    final occasionsAsync = ref.watch(occasionsProvider);
    final occasions = occasionsAsync.asData?.value;
    final Occasion? occasion = (occasions != null && occasions.isNotEmpty)
        ? occasions.first
        : null;

    final String slug = occasion?.slug ?? 'wedding';
    final String occasionName = (occasion?.name ?? 'Wedding').toUpperCase();
    final String tagText = occasionName.contains('PLANNING')
        ? occasionName
        : 'PLANNING A $occasionName?';
    final String? tagline = occasion?.tagline?.trim();
    final String headlineText = (tagline != null && tagline.isNotEmpty)
        ? tagline
        : 'Everything a Kerala wedding needs, in one list';
    final int categoryCount = (occasion?.categoryCount ?? 0) > 0
        ? occasion!.categoryCount
        : 16;
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
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.occasionCard,
                ),
              )
            else
              Container(
                color: AppColors.occasionCard,
              ),
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

  Widget _buildTrustBadges() {
    return Container(
      width: double.infinity,
      color: AppColors.trustBadgeBg,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.trustBadgeIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Verified businesses',
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Every business checked',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.trustBadgeIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Help next door',
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'A local partner near you',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCTA() {
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

class _PopularNearYouSection extends ConsumerStatefulWidget {
  const _PopularNearYouSection();

  @override
  ConsumerState<_PopularNearYouSection> createState() =>
      _PopularNearYouSectionState();
}

class _PopularNearYouSectionState
    extends ConsumerState<_PopularNearYouSection> {
  String _selectedFilter = 'All';

  Map<String, dynamic> _getQueryParams() {
    switch (_selectedFilter) {
      case 'Top rated':
        return {'limit': 8, 'sortBy': 'rating'};
      case 'Under ₹25k':
        return {'limit': 8, 'maxPrice': 25000};
      case 'New':
        return {'limit': 8, 'sortBy': 'newest'};
      case 'All':
      default:
        return {'limit': 8};
    }
  }

  @override
  Widget build(BuildContext context) {
    final queryParams = _getQueryParams();
    final searchAsync = ref.watch(searchProvider(jsonEncode(queryParams)));
    final categories = ref.watch(categoriesProvider).asData?.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular near you',
              style: AppTextStyles.headlineSm.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/explore'),
              child: Text(
                'See all',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppFilterChip(
                label: 'All',
                isSelected: _selectedFilter == 'All',
                onTap: () {
                  if (_selectedFilter != 'All') {
                    setState(() => _selectedFilter = 'All');
                  }
                },
              ),
              const SizedBox(width: 8),
              AppFilterChip(
                label: 'Top rated',
                isSelected: _selectedFilter == 'Top rated',
                onTap: () {
                  if (_selectedFilter != 'Top rated') {
                    setState(() => _selectedFilter = 'Top rated');
                  }
                },
              ),
              const SizedBox(width: 8),
              AppFilterChip(
                label: 'Under ₹25k',
                isSelected: _selectedFilter == 'Under ₹25k',
                onTap: () {
                  if (_selectedFilter != 'Under ₹25k') {
                    setState(() => _selectedFilter = 'Under ₹25k');
                  }
                },
              ),
              const SizedBox(width: 8),
              AppFilterChip(
                label: 'New',
                isSelected: _selectedFilter == 'New',
                onTap: () {
                  if (_selectedFilter != 'New') {
                    setState(() => _selectedFilter = 'New');
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        searchAsync.when(
          data: (result) {
            if (result.items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No listings found for this filter',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: result.items.take(8).map((listing) {
                  final category = categories
                      .where((c) => c.id == listing.categoryId)
                      .firstOrNull;
                  final categoryName = category?.name ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ListingCard(
                      id: listing.id,
                      title: listing.title,
                      category: categoryName,
                      description: null,
                      imageUrl: listing.coverUrl,
                      price: listing.priceFrom != null
                          ? 'From ₹${listing.priceFrom}'
                          : null,
                      width: 275,
                      isVerified: true,
                      hasQuoteButton: false,
                      hasAddedBadge: false,
                      rating: listing.ratingAvg,
                      ratingBadgeDark: true,
                      onTap: () => context.push('/home/listing/${listing.id}'),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, s) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Error: $e',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
