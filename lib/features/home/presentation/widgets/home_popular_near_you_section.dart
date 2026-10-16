import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../explore/presentation/providers/explore_providers.dart';
import '../../../listings/presentation/widgets/listing_card.dart';

class HomePopularNearYouSection extends ConsumerStatefulWidget {
  const HomePopularNearYouSection({super.key});

  @override
  ConsumerState<HomePopularNearYouSection> createState() =>
      _HomePopularNearYouSectionState();
}

class _HomePopularNearYouSectionState
    extends ConsumerState<HomePopularNearYouSection> {
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
              onTap: () => context.goNamed(AppRoutes.explore),
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
                      onTap: () => context.pushNamed(
                        AppRoutes.homeListingDetails,
                        pathParameters: {'id': listing.id},
                      ),
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
