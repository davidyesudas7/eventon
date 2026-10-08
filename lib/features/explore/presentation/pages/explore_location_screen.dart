import 'package:eventon/core/network/places_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../providers/location_search_provider.dart';
import '../../domain/entities/saved_location.dart';

class ExploreLocationScreen extends ConsumerStatefulWidget {
  const ExploreLocationScreen({super.key});

  @override
  ConsumerState<ExploreLocationScreen> createState() =>
      _ExploreLocationScreenState();
}

class _ExploreLocationScreenState extends ConsumerState<ExploreLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedRadiusKm;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    // Initialize radius from current location if it exists, otherwise default to 10
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLoc = ref.read(exploreLocationProvider);
      setState(() {
        _selectedRadiusKm = currentLoc?.radiusKm ?? 10;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onRadiusSelected(int? radius) {
    setState(() {
      _selectedRadiusKm = radius;
    });

    // If there is already a location selected, apply the radius change immediately
    final currentLocation = ref.read(exploreLocationProvider);
    if (currentLocation != null) {
      final updatedLocation = currentLocation.copyWith(
        radiusKm: radius,
        clearRadius: radius == null,
      );
      ref.read(exploreLocationProvider.notifier).setLocation(updatedLocation);
      
      // Save it locally to recent list only if it's not the current location
      if (updatedLocation.placeId != 'current') {
        ref.read(locationSearchControllerProvider.notifier).selectRecent(
          updatedLocation, 
          radiusKm: radius,
        );
      }
    }
  }

  Future<void> _handlePlaceSelection(dynamic place) async {
    final searchNotifier = ref.read(locationSearchControllerProvider.notifier);

    SavedLocation? location;
    if (place is PlaceSuggestion) {
      location = await searchNotifier.selectPlace(
        place,
        radiusKm: _selectedRadiusKm,
      );
    } else if (place is SavedLocation) {
      await searchNotifier.selectRecent(place, radiusKm: _selectedRadiusKm);
      location = place.copyWith(
        radiusKm: _selectedRadiusKm,
        clearRadius: _selectedRadiusKm == null,
      );
    }

    if (location != null) {
      debugPrint('📍 SELECTED LOCATION: ${location.name}');
      debugPrint('📍 LATITUDE: ${location.latitude}');
      debugPrint('📍 LONGITUDE: ${location.longitude}');
      debugPrint('📍 RADIUS: ${location.radiusKm} km');

      ref.read(exploreLocationProvider.notifier).setLocation(location);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationSearchControllerProvider);
    final notifier = ref.read(locationSearchControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Where is your event?',
          style: AppTextStyles.headlineSm.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: notifier.onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Search a town or area',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          notifier.onQueryChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderStrong),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderStrong),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Radius Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'WITHIN',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRadiusChip('10 km', 10),
                        _buildRadiusChip('25 km', 25),
                        _buildRadiusChip('50 km', 50),
                        _buildRadiusChip('100 km', 100),
                        _buildRadiusChip('Any distance', null),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.borderSubtle),

          // Current Location Button
          InkWell(
            onTap: _isFetchingLocation ? null : () async {
              setState(() {
                _isFetchingLocation = true;
              });
              
              try {
                final locationService = ref.read(locationServiceProvider);
                final position = await locationService.getCurrentPosition();
                
                if (position != null) {
                  final locationData = SavedLocation(
                    placeId: 'current',
                    name: 'Current Location',
                    address: 'Current Location',
                    latitude: position.latitude,
                    longitude: position.longitude,
                    radiusKm: _selectedRadiusKm,
                  );
                  // Set to provider but DON'T save to history
                  ref.read(exploreLocationProvider.notifier).setLocation(locationData);
                  if (context.mounted) context.pop();
                } else {
                  final isDeniedForever = await locationService.isPermissionDeniedForever();
                  if (isDeniedForever && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Location permissions are permanently denied.'),
                        action: SnackBarAction(
                          label: 'Settings',
                          onPressed: () => locationService.openAppSettings(),
                        ),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to get location: $e')),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  if (_isFetchingLocation)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(
                      Icons.my_location,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  const SizedBox(width: 16),
                  Text(
                    _isFetchingLocation ? 'Fetching location...' : 'Use current location',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.borderSubtle),

          // Results or Recent
          Expanded(
            child: state.isLoading && state.query.isNotEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.query.isEmpty
                ? _buildRecentLocations(state.recentLocations)
                : ListView.separated(
                    itemCount: state.suggestions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.borderSubtle),
                    itemBuilder: (context, index) {
                      final suggestion = state.suggestions[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                        ),
                        title: Text(
                          suggestion.primaryText,
                          style: AppTextStyles.bodyMd,
                        ),
                        subtitle: suggestion.secondaryText.isNotEmpty
                            ? Text(
                                suggestion.secondaryText,
                                style: AppTextStyles.labelSm,
                              )
                            : null,
                        onTap: () => _handlePlaceSelection(suggestion),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusChip(String label, int? radius) {
    final isSelected = _selectedRadiusKm == radius;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _onRadiusSelected(radius),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFE5EEED),
        checkmarkColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        labelStyle: AppTextStyles.labelMd.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildRecentLocations(List<SavedLocation> recents) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        if (recents.isNotEmpty) ...[
          Text(
            'RECENT',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...recents.map(
            (loc) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.access_time,
                color: AppColors.textSecondary,
                size: 20,
              ),
              title: Text(loc.name, style: AppTextStyles.bodyMd),
              subtitle: loc.address.isNotEmpty
                  ? Text(loc.address, style: AppTextStyles.labelSm)
                  : null,
              onTap: () => _handlePlaceSelection(loc),
            ),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          'Photographers and planners often travel — try "Any distance" to see them all, nearest labelled.',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            ref.read(exploreLocationProvider.notifier).clearLocation();
            context.pop();
          },
          child: Text(
            'Search everywhere instead',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
