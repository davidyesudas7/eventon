import 'dart:convert';
import 'package:eventon/features/auth/presentation/providers/auth_providers.dart';
import 'package:eventon/features/explore/presentation/providers/explore_providers.dart';
import 'package:eventon/features/quotes/presentation/providers/quote_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/domain/entities/occasion.dart';
import '../../../categories/presentation/widgets/category_grid.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../listings/presentation/widgets/listing_card.dart';
import '../../../profile/presentation/providers/home_location_provider.dart';
import '../widgets/home_search_bar.dart';

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
            backgroundColor: const Color(0xFF0D2226),
            pinned: true,
            expandedHeight: 240, // Increased to show greeting text fully
            flexibleSpace: FlexibleSpaceBar(
              background: _buildTopHeroContent(context, ref),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(72),
              child: HomeSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0D2226),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: _buildOccasionSection(ref),
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
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      Icons.location_on,
                      color: AppColors.success,
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
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          locationSubtitle,
                          style: AppTextStyles.labelSm.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (initial != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.success,
                    child: Text(
                      initial,
                      style: AppTextStyles.labelLg.copyWith(
                        color: const Color(0xFF0D2226),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Greeting
            Text(
              greeting,
              style: AppTextStyles.headlineLg.copyWith(color: Colors.white),
            ),
            Text(
              'what are we celebrating?',
              style: AppTextStyles.headlineLg.copyWith(
                color: AppColors.success,
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
          style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 195,
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
            error: (err, _) => const Center(
              child: Text(
                'Failed to load occasions',
                style: TextStyle(color: Colors.white),
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
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[800], // fallback
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: occasion.coverUrl != null
                  ? Image.network(occasion.coverUrl!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[700]),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.black26, Colors.transparent],
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
                    style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${occasion.categoryCount} services',
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white70,
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
      color: const Color(
        0xFF081B19,
      ), // Extends the dark hero background behind the radius
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20), // Added top padding
        decoration: const BoxDecoration(
          color: AppColors.surfaceBase,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
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
            const SizedBox(height: 24),
            _buildPlanningWeddingBanner(context),
            const SizedBox(height: 32),
            _buildPopularNearYou(context, ref),
            const SizedBox(height: 32),
            _buildTrustBadges(),
            const SizedBox(height: 32),
            _buildPartnerCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanningWeddingBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF2DF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLANNING A WEDDING?',
                style: AppTextStyles.labelSm.copyWith(
                  color: const Color(0xFFB87616),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore curated vendors',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.push('/home/occasion/wedding'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9822B),
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularNearYou(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchProvider(jsonEncode({'limit': 8})));

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
            Text(
              'See all',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppFilterChip(label: 'All', isSelected: true),
              const SizedBox(width: 8),
              AppFilterChip(label: 'Top rated'),
              const SizedBox(width: 8),
              AppFilterChip(label: 'Under ₹25k'),
              const SizedBox(width: 8),
              AppFilterChip(label: 'New'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        searchAsync.when(
          data: (result) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: result.items.take(8).map((listing) {
                final isAdded = ref
                    .watch(quoteCartProvider)
                    .any((l) => l.id == listing.id);

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ListingCard(
                    id: listing.id,
                    title: listing.title,
                    category: '',
                    description: listing.description,
                    imageUrl: listing.coverUrl,
                    price: listing.priceFrom != null
                        ? 'From ₹${listing.priceFrom}'
                        : null,
                    width: 275,
                    isVerified: true,
                    hasQuoteButton: !isAdded,
                    hasAddedBadge: isAdded,
                    onQuoteTap: () {
                      final authState = ref.read(authControllerProvider);
                      if (authState is! AuthStateAuthenticated) {
                        context.push('/sign-in-mobile');
                        return;
                      }
                      if (isAdded) {
                        ref
                            .read(quoteCartProvider.notifier)
                            .removeQuote(listing.id);
                      } else {
                        ref
                            .read(quoteCartProvider.notifier)
                            .addQuote(
                              QuoteItem(
                                id: listing.id,
                                title: listing.title,
                                imageUrl: listing.coverUrl,
                                price: listing.priceFrom != null
                                    ? 'From ₹${listing.priceFrom}'
                                    : null,
                              ),
                            );
                      }
                    },
                    onTap: () => context.push('/home/listing/${listing.id}'),
                  ),
                );
              }).toList(),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Verified businesses',
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Every business checked',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 60, width: 1, color: AppColors.borderSubtle),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Help next door',
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'A local partner near you',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF091F1C),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.storefront, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Run an event business?',
                  style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                ),
                Text(
                  'List it on EventOn — it\'s free to join',
                  style: AppTextStyles.labelSm.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78DDBE),
              foregroundColor: const Color(0xFF052922),
              minimumSize: const Size(60, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Join',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
