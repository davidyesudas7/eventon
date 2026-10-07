import 'package:eventon/features/quotes/presentation/providers/quote_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../widgets/listing_package_card.dart';
import '../../../../core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/package_model.dart';
import '../providers/listing_details_providers.dart';
import '../widgets/listing_review_card.dart';

class ListingDetailsScreen extends ConsumerStatefulWidget {
  const ListingDetailsScreen({super.key, required this.listingId});

  final String listingId;

  @override
  ConsumerState<ListingDetailsScreen> createState() =>
      _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends ConsumerState<ListingDetailsScreen> {
  void _toggleQuote(String title, String? imageUrl, int? startingPrice) {
    if (!_checkAuth()) return;

    final isAdded = ref
        .read(quoteCartProvider.notifier)
        .isAdded(widget.listingId);
    if (isAdded) {
      ref.read(quoteCartProvider.notifier).removeQuote(widget.listingId);
    } else {
      ref
          .read(quoteCartProvider.notifier)
          .addQuote(
            QuoteItem(
              id: widget.listingId,
              title: title,
              imageUrl: imageUrl,
              price: startingPrice != null ? 'From ₹$startingPrice' : null,
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

  bool _checkAuth() {
    final authState = ref.read(authControllerProvider);
    if (authState is! AuthStateAuthenticated) {
      context.push('/sign-in-mobile');
      return false;
    }
    return true;
  }

  void _bookNow(PackageModel package) {
    if (!_checkAuth()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting booking for ${package.name}…')),
    );
  }

  void _messageBusiness() {
    if (!_checkAuth()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat with business…')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(listingDetailsProvider(widget.listingId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(),
      body: asyncData.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load listing', style: AppTextStyles.headlineSm),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(listingDetailsProvider(widget.listingId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          final l = data.listing;
          final vendorName =
              data.vendor?.businessName ??
              data.vendor?.fullName ??
              'Unknown vendor';
          final categoryName = data.category?.name ?? 'Unknown category';
          final _addedToQuote = ref
              .watch(quoteCartProvider)
              .any((q) => q.id == widget.listingId);

          final startingPrice =
              l.priceFrom ??
              (data.packages.isNotEmpty
                  ? data.packages
                        .map((p) => p.price)
                        .reduce((a, b) => a < b ? a : b)
                  : 0);

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // Space for bottom bar
                children: [
                  _buildHero(
                    l.media?.cover?.url,
                    _addedToQuote,
                    () => _toggleQuote(
                      l.title,
                      l.media?.cover?.url,
                      startingPrice.toInt(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.title,
                          style: AppTextStyles.headlineMd.copyWith(
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderStrong,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                categoryName,
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'By $vendorName',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (l.ratingCount != null &&
                                l.ratingCount! > 0) ...[
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFB800),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${l.ratingAvg?.toStringAsFixed(1)} (${l.ratingCount})',
                                    style: AppTextStyles.labelMd,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Quote Request Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderSubtle),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Comparing prices? Ask this business and others for a quote in one go.',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () => _toggleQuote(
                                  l.title,
                                  l.media?.cover?.url,
                                  startingPrice.toInt(),
                                ),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _addedToQuote
                                        ? AppColors.surfaceMintPill
                                        : Colors.white,
                                    border: Border.all(
                                      color: _addedToQuote
                                          ? AppColors.primary
                                          : AppColors.borderStrong,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _addedToQuote ? Icons.check : Icons.add,
                                        size: 16,
                                        color: _addedToQuote
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _addedToQuote
                                            ? 'Added'
                                            : 'Add to quote request',
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: _addedToQuote
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: AppColors.borderSubtle, height: 1),

                  // About
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.description,
                          style: AppTextStyles.bodyMd.copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  if (l.attributes.isNotEmpty) ...[
                    const Divider(color: AppColors.borderSubtle, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 24,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 3,
                                ),
                            itemCount: l.attributes.length,
                            itemBuilder: (context, index) {
                              final key = l.attributes.keys.elementAt(index);
                              final dynamic rawValue = l.attributes[key];

                              // Format label using schema if available, otherwise humanize key
                              String label = key;
                              if (data.category?.attributeSchema != null) {
                                final schemaProps =
                                    data
                                            .category!
                                            .attributeSchema?['properties']
                                        as Map<String, dynamic>?;
                                if (schemaProps != null &&
                                    schemaProps.containsKey(key)) {
                                  label = schemaProps[key]?['title'] ?? key;
                                }
                              }

                              // Convert snake_case/camelCase to Title Case if still raw
                              if (label == key) {
                                label = label
                                    .replaceAll(RegExp(r'([A-Z])'), ' \$1')
                                    .replaceAll('_', ' ');
                                label =
                                    label.substring(0, 1).toUpperCase() +
                                    label.substring(1).toLowerCase();
                              }

                              // Format value
                              String valueStr = '';
                              if (rawValue is bool) {
                                valueStr = rawValue ? 'Yes' : 'No';
                              } else if (rawValue is List) {
                                valueStr = rawValue.join(', ');
                              } else {
                                valueStr = rawValue.toString();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: AppTextStyles.bodySm,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    valueStr,
                                    style: AppTextStyles.labelMd.copyWith(
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (data.packages.isNotEmpty) ...[
                    const Divider(color: AppColors.borderSubtle, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Packages',
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (final pkg in data.packages) ...[
                            ListingPackageCard(
                              package: pkg,
                              onBook: () => _bookNow(pkg),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ],

                  if (data.reviews.isNotEmpty) ...[
                    const Divider(color: AppColors.borderSubtle, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reviews (${data.reviewTotal})',
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (final review in data.reviews) ...[
                            ListingReviewCard(review: review),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              // Fixed Bottom Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.borderSubtle),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Starting at', style: AppTextStyles.labelSm),
                            Text(
                              formatRupees(startingPrice.toInt()),
                              style: AppTextStyles.headlineSm.copyWith(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _messageBusiness,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF155E56),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            textStyle: AppTextStyles.labelLg.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Message business'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHero(
    String? imageUrl,
    bool isAdded,
    VoidCallback onToggleQuote,
  ) {
    return Stack(
      children: [
        if (imageUrl != null)
          Image.network(
            imageUrl,
            height: 290,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 290,
            color: const Color(0xFFE2E8F0),
            width: double.infinity,
          ),
        // Positioned(
        //   top: 16,
        //   left: 16,
        //   child: CircleIconButton(
        //     icon: Icons.arrow_back,
        //     onTap: () => context.pop(),
        //   ),
        // ),
      ],
    );
  }
}
