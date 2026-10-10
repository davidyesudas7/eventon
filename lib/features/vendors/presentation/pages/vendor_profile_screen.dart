import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../quotes/presentation/providers/quote_cart_provider.dart';
import '../../domain/entities/vendor_listing.dart';
import '../providers/vendor_providers.dart';
import '../widgets/vendor_header_card.dart';
import '../widgets/vendor_listing_card.dart';
import '../widgets/vendor_review_item.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({
    super.key,
    required this.vendorId,
  });

  final String vendorId;

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger lazy loading when user is 200px from the bottom
    if (currentScroll >= maxScroll - 200) {
      ref
          .read(vendorReviewsProvider(widget.vendorId).notifier)
          .loadMore(widget.vendorId);
    }
  }

  bool _checkAuth() {
    final authState = ref.read(authControllerProvider);
    if (authState is! AuthStateAuthenticated) {
      context.push('/sign-in-mobile');
      return false;
    }
    return true;
  }

  void _toggleQuote(VendorListing listing) {
    if (!_checkAuth()) return;

    final isAdded = ref.read(quoteCartProvider.notifier).isAdded(listing.id);
    if (isAdded) {
      ref.read(quoteCartProvider.notifier).removeQuote(listing.id);
    } else {
      ref.read(quoteCartProvider.notifier).addQuote(
        QuoteItem(
          id: listing.id,
          title: listing.title,
          imageUrl: listing.coverUrl,
          price: listing.priceFrom != null ? 'From ₹${listing.priceFrom}' : null,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !isAdded ? 'Added to quote request' : 'Removed from quote request',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToListing(String listingId) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/explore')) {
      context.push('/explore/listing/$listingId');
    } else {
      context.push('/home/listing/$listingId');
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Future<void> _onRefresh() async {
    ref.invalidate(vendorProfileProvider(widget.vendorId));
    ref.invalidate(vendorListingsProvider(widget.vendorId));
    await ref
        .read(vendorReviewsProvider(widget.vendorId).notifier)
        .refresh(widget.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(vendorProfileProvider(widget.vendorId));
    final listingsAsync = ref.watch(vendorListingsProvider(widget.vendorId));
    final reviewsState =
        ref.watch(vendorReviewsProvider(widget.vendorId));
    final quoteCart = ref.watch(quoteCartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EventOnAppBar(
        onBack: _handleBack,
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onRefresh,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) {
          final titleName = profile.displayName;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _onRefresh,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                // Secondary Header Bar with Back Button & Vendor Name
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: _handleBack,
                      ),
                      Expanded(
                        child: Text(
                          titleName,
                          style: AppTextStyles.headlineMd.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vendor Profile Header
                VendorHeaderCard(
                  profile: profile,
                  ratingAvg: reviewsState.averageRating,
                  totalReviews: reviewsState.total,
                ),

                const Divider(
                  color: AppColors.borderSubtle,
                  height: 1,
                  thickness: 1,
                ),

                // Listings Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'Listings',
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                listingsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      'Failed to load listings',
                      style: AppTextStyles.bodyMd.copyWith(color: Colors.red),
                    ),
                  ),
                  data: (listings) {
                    if (listings.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Text(
                          'No listings found for this vendor.',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: listings.map((listing) {
                          final isAdded = quoteCart.any((q) => q.id == listing.id);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: VendorListingCard(
                              listing: listing,
                              isAddedToQuote: isAdded,
                              onQuoteTap: () => _toggleQuote(listing),
                              onTap: () => _navigateToListing(listing.id),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                // Reviews Section (shown when reviews exist or are loading)
                if (reviewsState.isLoading || reviewsState.reviews.isNotEmpty) ...[
                  const Divider(
                    color: AppColors.borderSubtle,
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Text(
                      'Reviews',
                      style: AppTextStyles.headlineSm.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (reviewsState.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...reviewsState.reviews.map(
                            (review) => VendorReviewItem(review: review),
                          ),
                          if (reviewsState.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
