import 'dart:async';
import 'dart:convert';
import 'package:eventon/features/auth/presentation/providers/auth_providers.dart';
import 'package:eventon/features/quotes/presentation/providers/quote_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../../core/widgets/typewriter_hint.dart';
import '../widgets/location_chip.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/domain/entities/ui_hint.dart';
import '../../../listings/presentation/widgets/listing_card.dart';
import '../providers/explore_providers.dart';
import '../providers/location_search_provider.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/saved_location.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const ExploreScreen({super.key, this.initialCategoryId});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _openingSearch = false;
  bool _isFetchingLocation = false;

  String? _selectedCategoryId;
  String? _appliedCategoryId;
  Map<String, dynamic> _selectedAttributes = {};
  Map<String, dynamic> _appliedAttributes = {};

  // Rotating Hint
  Timer? _hintTimer;
  int _currentHintIndex = 0;
  List<String> _hintCategories = ['services']; // fallback

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _appliedCategoryId = widget.initialCategoryId;

    // Start rotating hint
    _startHintTimer();

    // Check location permission on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationServiceProvider).checkAndRequestPermission();
    });
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
    _hintTimer = Timer.periodic(const Duration(seconds: 2, milliseconds: 500), (
      timer,
    ) {
      if (_searchController.text.isNotEmpty) {
        return; // Pause rotating if user is typing
      }
      if (_hintCategories.length <= 1) return;
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % _hintCategories.length;
      });
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
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
    final categoriesAsync = ref.watch(categoriesProvider);
    final location = ref.watch(exploreLocationProvider);

    final Map<String, dynamic> queries = {};
    if (_searchController.text.isNotEmpty) {
      queries['q'] = _searchController.text;
    }
    if (_appliedCategoryId != null) {
      queries['categoryId'] = _appliedCategoryId;
    }
    queries.addAll(_appliedAttributes);

    if (location != null && location.radiusKm != null) {
      queries['lat'] = location.latitude;
      queries['lng'] = location.longitude;
      queries['radiusKm'] = location.radiusKm;
    }

    final searchAsync = ref.watch(searchProvider(jsonEncode(queries)));

    categoriesAsync.whenData((categories) {
      if (categories.isNotEmpty) {
        final newHints = categories.map((c) => c.name.toLowerCase()).toList();
        if (_hintCategories.length != newHints.length ||
            !_hintCategories.every((element) => newHints.contains(element))) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _hintCategories = newHints;
              });
            }
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light gray background
      appBar: const EventOnAppBar(
        showBack: false,
        actions: [SizedBox.shrink()],
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
                          child: Hero(
                            tag: 'explore_search_bar',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderStrong,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    if (_searchController.text.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 44.0,
                                        ),
                                        child: TypewriterHint(
                                          prefix: 'Search \'',
                                          texts: _hintCategories,
                                          currentIndex: _currentHintIndex,
                                          style: AppTextStyles.bodyMd.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    TextField(
                                      controller: _searchController,
                                      onChanged: (val) {
                                        setState(
                                          () {},
                                        ); // trigger rebuild to hide hint
                                        _onSearchChanged(val);
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: false,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.textMuted,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                border: Border.all(
                                  color: AppColors.borderStrong,
                                ),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/explore/location'),
                          child: LocationChip(
                            label: location != null
                                ? '${location.name}${location.radiusKm != null ? ' · ${location.radiusKm} km' : ''}'
                                : 'Anywhere',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (location == null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'See businesses near you',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Or pick the place your event is at.',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isFetchingLocation
                              ? null
                              : () async {
                                  setState(() {
                                    _isFetchingLocation = true;
                                  });

                                  try {
                                    final locationService = ref.read(
                                      locationServiceProvider,
                                    );
                                    final position = await locationService
                                        .getCurrentPosition();

                                    if (position != null) {
                                      final locationData = SavedLocation(
                                        placeId: 'current',
                                        name: 'Current Location',
                                        address: 'Current Location',
                                        latitude: position.latitude,
                                        longitude: position.longitude,
                                      );
                                      ref
                                          .read(
                                            exploreLocationProvider.notifier,
                                          )
                                          .setLocation(locationData);
                                    } else {
                                      final isDeniedForever =
                                          await locationService
                                              .isPermissionDeniedForever();
                                      if (isDeniedForever && context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Location permissions are permanently denied.',
                                            ),
                                            action: SnackBarAction(
                                              label: 'Settings',
                                              onPressed: () => locationService
                                                  .openAppSettings(),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to fetch location: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isFetchingLocation = false;
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF15272A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: _isFetchingLocation
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Use my location',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Vendor Feed
              Expanded(
                child: searchAsync.when(
                  data: (result) {
                    if (result.items.isEmpty) {
                      return const Center(child: Text('No listings found'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 96),
                      itemCount: result.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final listing = result.items[index];
                        final quoteCart = ref.watch(quoteCartProvider);
                        final isAdded = ref
                            .read(quoteCartProvider.notifier)
                            .isAdded(listing.id);

                        return ListingCard(
                          id: listing.id,
                          title: listing.title,
                          category:
                              '', // Handled by description mostly in this variant
                          description: listing.description,
                          imageUrl: listing.coverUrl,
                          price: listing.priceFrom != null
                              ? 'From ₹${listing.priceFrom}'
                              : null,
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
                          onTap: () =>
                              context.push('/explore/listing/${listing.id}'),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),

          // Floating Action Bar
          if (ref.watch(quoteCartProvider).isNotEmpty)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  final authState = ref.read(authControllerProvider);
                  if (authState is! AuthStateAuthenticated) {
                    context.push('/sign-in-mobile');
                    return;
                  }
                  context.push('/request-quotes');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13222A), // Dark slate
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ref.watch(quoteCartProvider).length} business${ref.watch(quoteCartProvider).length == 1 ? '' : 'es'} picked',
                        style: AppTextStyles.labelMd.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Request quotes',
                            style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
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

  // Removed _buildVendorCard as we now use ListingCard

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
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // Category
                  Text(
                    'CATEGORY',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final categoriesAsync = ref.watch(categoriesProvider);

                      return categoriesAsync.when(
                        data: (categories) {
                          Category? selectedCategory;
                          if (_selectedCategoryId != null) {
                            for (final c in categories) {
                              if (c.id == _selectedCategoryId) {
                                selectedCategory = c;
                                break;
                              }
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryId = null;
                                        _selectedAttributes.clear();
                                      });
                                    },
                                    child: _buildFilterChip(
                                      'Any',
                                      isSelected: _selectedCategoryId == null,
                                    ),
                                  ),
                                  ...categories.map((c) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryId = c.id;
                                          _selectedAttributes.clear();
                                        });
                                      },
                                      child: _buildFilterChip(
                                        c.name,
                                        isSelected: _selectedCategoryId == c.id,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              if (selectedCategory != null &&
                                  selectedCategory.uiHints.isNotEmpty) ...[
                                const SizedBox(height: 32),
                                Text(
                                  '${selectedCategory.name.toUpperCase()} FILTERS',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                ...selectedCategory.uiHints.map(
                                  (attr) => _buildDynamicAttributeFilter(attr),
                                ),
                              ],
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            const Text('Failed to load categories'),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Budget
                  Text(
                    'BUDGET (₹)',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Min',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.borderStrong,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '—',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Max',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.borderStrong,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Minimum Rating
                  Text(
                    'MINIMUM RATING',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
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
                  Text(
                    'SORT BY',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
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
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                        items:
                            [
                                  'Recommended',
                                  'Price: Low to High',
                                  'Price: High to Low',
                                  'Rating: High to Low',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: AppTextStyles.bodyLg),
                                  ),
                                )
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
                  onPressed: () {
                    setState(() {
                      _appliedCategoryId = _selectedCategoryId;
                      _appliedAttributes = Map.from(_selectedAttributes);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15272A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Show results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return AppFilterChip(
      label: label,
      isSelected: isSelected,
      variant: FilterChipVariant.mint,
    );
  }

  Widget _buildDynamicAttributeFilter(UiHint hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          hint.label,
          style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        _buildAttributeInput(hint),
      ],
    );
  }

  Widget _buildAttributeInput(UiHint hint) {
    switch (hint.widget) {
      case 'multiselect':
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: hint.options.map((option) {
            final isSelected =
                (_selectedAttributes[hint.key] as List<String>?)?.contains(
                  option.value,
                ) ??
                false;
            return GestureDetector(
              onTap: () {
                setState(() {
                  final current = List<String>.from(
                    _selectedAttributes[hint.key] as List<String>? ?? [],
                  );
                  if (isSelected) {
                    current.remove(option.value);
                  } else {
                    current.add(option.value);
                  }
                  _selectedAttributes[hint.key] = current;
                });
              },
              child: _buildFilterChip(option.label, isSelected: isSelected),
            );
          }).toList(),
        );
      case 'select':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAttributes[hint.key] as String?,
              isExpanded: true,
              hint: const Text('Any'),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('Any')),
                ...hint.options.map(
                  (e) => DropdownMenuItem<String>(
                    value: e.value,
                    child: Text(e.label),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  if (v != null) {
                    _selectedAttributes[hint.key] = v;
                  } else {
                    _selectedAttributes.remove(hint.key);
                  }
                });
              },
            ),
          ),
        );
      case 'boolean':
        final currentValue = _selectedAttributes[hint.key] as bool?;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            GestureDetector(
              onTap: () => setState(() => _selectedAttributes.remove(hint.key)),
              child: _buildFilterChip('Any', isSelected: currentValue == null),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedAttributes[hint.key] = true),
              child: _buildFilterChip('Yes', isSelected: currentValue == true),
            ),
            GestureDetector(
              onTap: () =>
                  setState(() => _selectedAttributes[hint.key] = false),
              child: _buildFilterChip('No', isSelected: currentValue == false),
            ),
          ],
        );
      case 'number':
        return Row(
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
                onChanged: (v) {
                  final map = Map<String, dynamic>.from(
                    _selectedAttributes[hint.key] as Map<String, dynamic>? ??
                        {},
                  );
                  map['min'] = v;
                  _selectedAttributes[hint.key] = map;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '—',
                style: TextStyle(color: AppColors.textMuted, fontSize: 20),
              ),
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
                onChanged: (v) {
                  final map = Map<String, dynamic>.from(
                    _selectedAttributes[hint.key] as Map<String, dynamic>? ??
                        {},
                  );
                  map['max'] = v;
                  _selectedAttributes[hint.key] = map;
                },
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
