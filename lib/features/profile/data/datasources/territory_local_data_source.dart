import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_models.dart';

abstract interface class TerritoryLocalDataSource {
  Future<Map<String, dynamic>?> getSavedLocationRaw();
  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg);
  Future<void> saveFromLogin(String? pincode, String? lsgId);
  Future<void> clearLocation();
}

class TerritoryLocalDataSourceImpl implements TerritoryLocalDataSource {
  static const _key = 'home_location';

  @override
  Future<Map<String, dynamic>?> getSavedLocationRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'pincode': pin.pincode,
        'lsgDetails': lsg?.toJson(),
      }),
    );
  }

  @override
  Future<void> saveFromLogin(String? pincode, String? lsgId) async {
    if (pincode == null || pincode.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'pincode': pincode,
        'lsgDetails': lsgId != null
            ? {
                'id': lsgId,
                'name': '',
                'type': '',
                'district': '',
                'state': 'Kerala',
              }
            : null,
      }),
    );
  }

  @override
  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
