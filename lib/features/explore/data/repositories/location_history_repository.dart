import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/saved_location.dart';

part 'location_history_repository.g.dart';

@riverpod
LocationHistoryRepository locationHistoryRepository(Ref ref) {
  return LocationHistoryRepository();
}

class LocationHistoryRepository {
  static const String _key = 'recent_locations';
  static const String _currentLocationKey = 'current_selected_location';
  static const int _maxHistory = 10;

  Future<List<SavedLocation>> getRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    
    return jsonList.map((jsonStr) {
      return SavedLocation.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  Future<void> saveLocation(SavedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getRecentLocations();

    // Remove if already exists (to prevent duplicates)
    currentList.removeWhere((loc) => loc.placeId == location.placeId);

    // Add to top
    currentList.insert(0, location);

    // Limit size
    if (currentList.length > _maxHistory) {
      currentList.removeRange(_maxHistory, currentList.length);
    }

    // Save back
    final jsonList = currentList.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<SavedLocation?> getCurrentSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_currentLocationKey);
    if (jsonStr != null) {
      try {
        return SavedLocation.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveCurrentSelectedLocation(SavedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentLocationKey, jsonEncode(location.toJson()));
  }

  Future<void> clearCurrentSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentLocationKey);
  }
}
