import 'package:eventon/features/bookings/presentation/providers/booking_providers.dart';
import 'package:eventon/features/quotes/presentation/providers/quote_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../widgets/listing_package_card.dart';
import '../../../../core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/package_model.dart';
import '../providers/listing_details_providers.dart';
import '../widgets/listing_review_card.dart';
import '../../../../features/chat/presentation/providers/chat_providers.dart';
import '../../../../core/widgets/inline_error_banner.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) =>
          _BookPackageSheet(listingId: widget.listingId, package: package),
    );
  }

  void _messageBusiness() {
    if (!_checkAuth()) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _MessageBusinessSheet(listingId: widget.listingId),
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
          final isAddedToQuote = ref
              .watch(quoteCartProvider)
              .any((q) => q.id == widget.listingId);

          final startingPrice =
              l.priceFrom ??
              (data.packages.isNotEmpty
                  ? data.packages
                        .map((p) => p.price)
                        .reduce((a, b) => a < b ? a : b)
                  : 0);

          final hasRating = l.ratingAvg != null && l.ratingAvg! > 0;

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // Space for bottom bar
                children: [
                  _buildHero(
                    l.media?.cover?.url,
                    isAddedToQuote,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                l.title,
                                style: AppTextStyles.headlineMd.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            if (hasRating) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2F4F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Color(0xFF0F766E),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      l.ratingAvg!.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFF0F766E),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (hasRating &&
                            l.ratingCount != null &&
                            l.ratingCount! > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${l.ratingCount} ${l.ratingCount == 1 ? 'review' : 'reviews'}',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
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
                                    color: isAddedToQuote
                                        ? AppColors.surfaceMintPill
                                        : Colors.white,
                                    border: Border.all(
                                      color: isAddedToQuote
                                          ? AppColors.primary
                                          : AppColors.borderStrong,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isAddedToQuote ? Icons.check : Icons.add,
                                        size: 16,
                                        color: isAddedToQuote
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isAddedToQuote
                                            ? 'Added'
                                            : 'Add to quote request',
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: isAddedToQuote
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

class _BookPackageSheet extends ConsumerStatefulWidget {
  final String listingId;
  final PackageModel package;

  const _BookPackageSheet({required this.listingId, required this.package});

  @override
  ConsumerState<_BookPackageSheet> createState() => _BookPackageSheetState();
}

class _BookPackageSheetState extends ConsumerState<_BookPackageSheet> {
  DateTime? _selectedDate;
  String? _errorMessage;

  void _confirmBooking() async {
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Please select your event date');
      return;
    }
    setState(() => _errorMessage = null);
    final notifier = ref.read(createBookingProvider.notifier);
    final booking = await notifier.createBooking(
      listingId: widget.listingId,
      packageId: widget.package.id,
      eventDate: _selectedDate!,
    );
    if (booking != null && mounted) {
      Navigator.pop(context); // Close sheet
      context.go('/bookings/${booking.id}', extra: booking); // Go to details
    } else if (mounted) {
      setState(() {
        _errorMessage = notifier.lastError ?? 'Failed to create booking';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(createBookingProvider);
    final dateStr = _selectedDate != null
        ? '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}'
        : 'mm/dd/yyyy';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Book ${widget.package.name}',
            style: AppTextStyles.headlineSm.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            formatRupees(widget.package.price.toInt()),
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text("When's your event?", style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _errorMessage = null;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
          if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 16),
            InlineErrorBanner(
              message: _errorMessage,
              margin: EdgeInsets.zero,
              onDismiss: () => setState(() => _errorMessage = null),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedDate == null || isCreating
                  ? null
                  : _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Confirm booking'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBusinessSheet extends ConsumerStatefulWidget {
  final String listingId;

  const _MessageBusinessSheet({required this.listingId});

  @override
  ConsumerState<_MessageBusinessSheet> createState() => _MessageBusinessSheetState();
}

class _MessageBusinessSheetState extends ConsumerState<_MessageBusinessSheet> {
  DateTime? _selectedDate;
  String? _errorMessage;

  void _startConversation() async {
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Please select your event date');
      return;
    }
    setState(() => _errorMessage = null);
    final notifier = ref.read(createConversationProvider.notifier);
    final conversation = await notifier.createConversation(widget.listingId, _selectedDate!);
        
    if (conversation != null && mounted) {
      Navigator.pop(context); // Close sheet
      context.push('/chats/${conversation.id}'); // Go to chat screen
    } else if (mounted) {
      setState(() {
        _errorMessage = notifier.lastError ?? 'Failed to start conversation';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(createConversationProvider);
    final dateStr = _selectedDate != null
        ? '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}'
        : 'mm/dd/yyyy';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "When's your event?",
            style: AppTextStyles.headlineSm.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            "This starts a chat with the business about that date.",
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _errorMessage = null;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
          if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 16),
            InlineErrorBanner(
              message: _errorMessage,
              margin: EdgeInsets.zero,
              onDismiss: () => setState(() => _errorMessage = null),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedDate == null || isCreating
                  ? null
                  : _startConversation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155E56),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Start conversation'),
            ),
          ),
        ],
      ),
    );
  }
}
