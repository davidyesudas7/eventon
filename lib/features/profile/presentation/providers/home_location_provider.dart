import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data/models/location_models.dart';

part 'home_location_provider.g.dart';

@riverpod
class HomeLocationState extends _$HomeLocationState {
  bool _mounted = true;

  @override
  Future<HomeLocation?> build() async {
    _mounted = true;
    ref.onDispose(() => _mounted = false);
    
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('home_location');
    if (jsonStr != null) {
      try {
        final data = jsonDecode(jsonStr);
        final pincode = data['pincode'] as String?;
        final lsgJson = data['lsgDetails'] as Map<String, dynamic>?;
        
        LsgDetails? lsgDetails;
        if (lsgJson != null) {
          lsgDetails = LsgDetails.fromJson(lsgJson);
        }
        
        if (pincode != null && pincode.length == 6) {
          // Fetch fresh details when loading
          final response = await http.get(
            Uri.parse('https://api.eventongo.in/territories/reference/pincodes/$pincode')
          );
          if (response.statusCode == 200) {
            final pinDetails = PincodeDetails.fromJson(jsonDecode(response.body));
            return HomeLocation(pincodeDetails: pinDetails, lsgDetails: lsgDetails);
          }
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg) async {
    final location = HomeLocation(pincodeDetails: pin, lsgDetails: lsg);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('home_location', jsonEncode({
      'pincode': pin.pincode,
      'lsgDetails': lsg?.toJson(),
    }));
    state = AsyncData(location);
  }

  Future<void> saveFromLogin(String? pincode, String? lsgId) async {
    if (pincode == null || pincode.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('home_location', jsonEncode({
      'pincode': pincode,
      'lsgDetails': lsgId != null ? {
        'id': lsgId,
        'name': '',
        'type': '',
        'district': '',
        'state': 'Kerala'
      } : null,
    }));
    
    if (_mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('home_location');
    state = const AsyncData(null);
  }
}

@riverpod
Future<PincodeDetails?> fetchPincode(Ref ref, String pincode) async {
  if (pincode.length != 6) return null;

  try {
    final response = await http.get(
      Uri.parse(
        'https://api.eventongo.in/territories/reference/pincodes/$pincode',
      ),
    );
    if (response.statusCode == 200) {
      return PincodeDetails.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    // Handle or log error
  }
  return null;
}

@riverpod
Future<List<LsgDetails>> searchLsg(Ref ref, String query) async {
  if (query.trim().length < 2) return [];

  try {
    final response = await http.get(
      Uri.parse(
        'https://api.eventongo.in/territories/reference/lsg-search?state=Kerala&q=${Uri.encodeComponent(query)}',
      ),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => LsgDetails.fromJson(e)).toList();
    }
  } catch (e) {
    // Handle error
  }
  return [];
}
