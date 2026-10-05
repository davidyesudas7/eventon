import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _openingSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Opens the search sub-screen as soon as the user starts typing.
  Future<void> _onSearchChanged(String value) async {
    if (value.isEmpty || _openingSearch) return;
    _openingSearch = true;
    FocusScope.of(context).unfocus();
    final result = await context.push<String>('/explore/search', extra: value);
    _openingSearch = false;
    if (!mounted) return;
    // Clearing in the search screen returns null -> back to an empty bar.
    _searchController.text = result ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light gray background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            Text('Event', style: AppTextStyles.headlineLg.copyWith(color: AppColors.textPrimary)),
            Text('On', style: AppTextStyles.headlineLg.copyWith(color: AppColors.primary)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      endDrawer: _buildFiltersDrawer(context),
      body: Stack(
        children: [
          Column(
            children: [
              // Search & Filters Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderStrong),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: _onSearchChanged,
                                    decoration: InputDecoration(
                                      hintText: 'Search \'pandal, tent & furniture\'',
                                      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderStrong),
                              ),
                              child: const Icon(Icons.tune, color: AppColors.textSecondary, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.borderStrong),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 16),
                              const SizedBox(width: 6),
                              Text('Alappuzha · 50 km', style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary)),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Vendor Feed
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildVendorCard(
                      context: context,
                      id: 'l_001',
                      title: 'Royal Wedding Cars',
                      description: 'Chauffeur-driven sedans and vintage cars for weddings and photoshoots across the city.',
                      price: 'From ₹6,500',
                      distance: '40 km away',
                      hasAddedBadge: true,
                    ),
                    const SizedBox(height: 16),
                    _buildVendorCard(
                      context: context,
                      id: 'l_003',
                      title: 'Elite Beat DJs & Sound',
                      description: 'Premium sound systems and lighting setups for live celebrations.',
                      hasQuoteButton: true,
                    ),
                    // Add some bottom padding to avoid the floating action bar
                    const SizedBox(height: 80), 
                  ],
                ),
              ),
            ],
          ),
          
          // Floating Action Bar
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF13222A), // Dark slate
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 business picked',
                    style: AppTextStyles.labelMd.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        'Request quotes',
                        style: AppTextStyles.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard({
    required BuildContext context,
    required String id,
    required String title,
    required String description,
    String? price,
    String? distance,
    bool hasAddedBadge = false,
    bool hasQuoteButton = false,
  }) {
    return GestureDetector(
      onTap: () => context.push('/explore/listing/$id'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  if (hasAddedBadge)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C6B55).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text('Added', style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  if (hasQuoteButton)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Row(
                          children: [
                            const Text('+', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Text('Quote', style: AppTextStyles.labelSm.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineSm.copyWith(fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null || distance != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (price != null)
                          Text(price, style: AppTextStyles.labelMd.copyWith(color: const Color(0xFF0C6B55), fontWeight: FontWeight.w700)),
                        if (distance != null)
                          Text(distance, style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary)),
                      ],
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

  Widget _buildFiltersDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.headlineMd),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Reset',
                          style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  // Category
                  Text('CATEGORY', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFilterChip('Any', isSelected: true),
                      _buildFilterChip('Bridal makeup & styling'),
                      _buildFilterChip('Bridal wear & costumes'),
                      _buildFilterChip('Cakes & desserts'),
                      _buildFilterChip('Catering'),
                      _buildFilterChip('DJ & entertainment'),
                      _buildFilterChip('Decoration & stage'),
                      _buildFilterChip('Event & wedding planners'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Budget
                  Text('BUDGET (₹)', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Min',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.borderStrong),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('—', style: TextStyle(color: AppColors.textMuted, fontSize: 20)),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Max',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.borderStrong),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Minimum Rating
                  Text('MINIMUM RATING', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFilterChip('Any', isSelected: true),
                      _buildFilterChip('★ 3+'),
                      _buildFilterChip('★ 4+'),
                      _buildFilterChip('★ 4.5+'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Sort By
                  Text('SORT BY', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Recommended',
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                        items: ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Rating: High to Low']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTextStyles.bodyLg)))
                            .toList(),
                        onChanged: (v) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15272A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Show 24 results', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F3F4) : Colors.white,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderStrong),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          color: isSelected ? const Color(0xFF164850) : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
