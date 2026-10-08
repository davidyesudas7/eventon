import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/places_api_client.dart';
import '../../data/repositories/location_history_repository.dart';
import '../../domain/entities/saved_location.dart';

part 'location_search_provider.g.dart';

@Riverpod(keepAlive: true)
class ExploreLocation extends _$ExploreLocation {
  @override
  SavedLocation? build() {
    _loadPersistedLocation();
    return null;
  }

  Future<void> _loadPersistedLocation() async {
    final repo = ref.read(locationHistoryRepositoryProvider);
    final saved = await repo.getCurrentSelectedLocation();
    if (saved != null) {
      state = saved;
    }
  }

  void setLocation(SavedLocation location) {
    state = location;
    ref.read(locationHistoryRepositoryProvider).saveCurrentSelectedLocation(location);
  }

  void clearLocation() {
    state = null;
    ref.read(locationHistoryRepositoryProvider).clearCurrentSelectedLocation();
  }
}

class LocationSearchState {
  final String query;
  final List<PlaceSuggestion> suggestions;
  final List<SavedLocation> recentLocations;
  final bool isLoading;

  const LocationSearchState({
    this.query = '',
    this.suggestions = const [],
    this.recentLocations = const [],
    this.isLoading = false,
  });

  LocationSearchState copyWith({
    String? query,
    List<PlaceSuggestion>? suggestions,
    List<SavedLocation>? recentLocations,
    bool? isLoading,
  }) {
    return LocationSearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      recentLocations: recentLocations ?? this.recentLocations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class LocationSearchController extends _$LocationSearchController {
  Timer? _debounce;
  String? _sessionToken;

  @override
  LocationSearchState build() {
    _loadRecentLocations();
    return const LocationSearchState();
  }

  Future<void> _loadRecentLocations() async {
    final repo = ref.read(locationHistoryRepositoryProvider);
    final recents = await repo.getRecentLocations();
    state = state.copyWith(recentLocations: recents);
  }

  void onQueryChanged(String query) {
    print("📍 onQueryChanged called with: '$query'");
    state = state.copyWith(query: query, isLoading: query.isNotEmpty);

    if (query.isEmpty) {
      _sessionToken = null; // reset session when empty
      state = state.copyWith(suggestions: [], isLoading: false);
      _debounce?.cancel();
      return;
    }

    if (_sessionToken == null) {
      _sessionToken = const Uuid().v4();
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      print("📍 Debounce finished, fetching suggestions...");
      await _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    print("📍 _fetchSuggestions executing...");
    final client = ref.read(placesApiClientProvider);
    try {
      final results = await client.autocomplete(query, _sessionToken ?? '');
      print("📍 _fetchSuggestions got ${results.length} results.");
      state = state.copyWith(suggestions: results, isLoading: false);
    } catch (e) {
      print("📍 _fetchSuggestions ERROR: $e");
      state = state.copyWith(suggestions: [], isLoading: false);
    }
  }

  Future<SavedLocation?> selectPlace(PlaceSuggestion suggestion, {int? radiusKm}) async {
    final client = ref.read(placesApiClientProvider);
    final repo = ref.read(locationHistoryRepositoryProvider);

    try {
      state = state.copyWith(isLoading: true);
      final details = await client.getPlaceDetails(suggestion.placeId, _sessionToken ?? '');
      
      // End of session, clear token
      _sessionToken = null;

      if (details != null) {
        final location = SavedLocation(
          placeId: details.id,
          name: details.name.isNotEmpty ? details.name : suggestion.primaryText,
          address: details.address.isNotEmpty ? details.address : suggestion.secondaryText,
          latitude: details.latitude,
          longitude: details.longitude,
          radiusKm: radiusKm,
        );

        await repo.saveLocation(location);
        await _loadRecentLocations();
        
        state = state.copyWith(isLoading: false);
        return location;
      }
    } catch (e) {
      // Ignore
    }
    state = state.copyWith(isLoading: false);
    return null;
  }

  Future<void> selectRecent(SavedLocation location, {int? radiusKm}) async {
    final repo = ref.read(locationHistoryRepositoryProvider);
    final updated = location.copyWith(radiusKm: radiusKm, clearRadius: radiusKm == null);
    await repo.saveLocation(updated);
    await _loadRecentLocations();
  }
}
