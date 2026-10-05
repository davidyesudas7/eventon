import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/listing.dart';

class ListingDetailsScreen extends StatefulWidget {
  const ListingDetailsScreen({super.key, required this.listing});

  final Listing listing;

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  bool _addedToQuote = false;

  void _toggleQuote() {
    setState(() => _addedToQuote = !_addedToQuote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_addedToQuote ? 'Added to quote request' : 'Removed from quote request'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _bookNow(ListingPackage package) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting booking for ${package.name}…')),
    );
  }

  void _messageBusiness() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat with business…')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
            children: [
              _buildHero(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.title, style: AppTextStyles.headlineMd.copyWith(fontSize: 22)),
                    const SizedBox(height: 4),
                    if (l.isNew)
                      Text('New on EventOn', style: AppTextStyles.bodyMd),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderStrong),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(l.category, style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 12),
                        Text('By ${l.providerName}', style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary)),
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
                            onTap: _toggleQuote,
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _addedToQuote ? AppColors.surfaceMintPill : Colors.white,
                                border: Border.all(color: _addedToQuote ? AppColors.primary : AppColors.borderStrong),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _addedToQuote ? Icons.check : Icons.add,
                                    size: 16,
                                    color: _addedToQuote ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _addedToQuote ? 'Added' : 'Add to quote request',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: _addedToQuote ? AppColors.primary : AppColors.textPrimary,
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
                    Text('About', style: AppTextStyles.headlineSm.copyWith(fontSize: 17)),
                    const SizedBox(height: 12),
                    Text(l.about, style: AppTextStyles.bodyMd.copyWith(height: 1.5)),
                  ],
                ),
              ),

              if (l.details.isNotEmpty) ...[
                const Divider(color: AppColors.borderSubtle, height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details', style: AppTextStyles.headlineSm.copyWith(fontSize: 17)),
                      const SizedBox(height: 20),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3,
                        ),
                        itemCount: l.details.length,
                        itemBuilder: (context, index) {
                          final key = l.details.keys.elementAt(index);
                          final value = l.details[key]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key, style: AppTextStyles.bodySm),
                              const SizedBox(height: 4),
                              Text(value, style: AppTextStyles.labelMd.copyWith(fontSize: 15)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              if (l.packages.isNotEmpty) ...[
                const Divider(color: AppColors.borderSubtle, height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Packages', style: AppTextStyles.headlineSm.copyWith(fontSize: 17)),
                      const SizedBox(height: 16),
                      for (final pkg in l.packages) ...[
                        _buildPackageCard(pkg),
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
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
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
                        Text(formatRupees(l.startingPrice), style: AppTextStyles.headlineSm.copyWith(fontSize: 17)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _messageBusiness,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF155E56),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        textStyle: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Message business'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        Container(
          height: 290,
          color: const Color(0xFFE2E8F0), // Placeholder color
          width: double.infinity,
        ),
        Positioned(
          top: 16, left: 16,
          child: InkWell(
            onTap: () => context.pop(),
            customBorder: const CircleBorder(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(ListingPackage pkg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pkg.name, style: AppTextStyles.headlineSm.copyWith(fontSize: 17)),
                    if (pkg.duration != null) ...[
                      const SizedBox(height: 2),
                      Text(pkg.duration!, style: AppTextStyles.bodyMd),
                    ],
                  ],
                ),
              ),
              Text(
                formatRupees(pkg.price),
                style: AppTextStyles.labelLg.copyWith(color: AppColors.primary, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final f in pkg.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(f, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          for (final f in pkg.excludedFeatures)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(f, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => _bookNow(pkg),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderStrong),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Book now', style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
