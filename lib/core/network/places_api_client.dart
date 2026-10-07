import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'places_api_client.g.dart';

@riverpod
PlacesApiClient placesApiClient(Ref ref) {
  return PlacesApiClient();
}

class PlaceSuggestion {
  final String placeId;
  final String primaryText;
  final String secondaryText;

  PlaceSuggestion({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    final prediction = json['placePrediction'] as Map<String, dynamic>? ?? {};
    final structuredFormat =
        prediction['structuredFormat'] as Map<String, dynamic>? ?? {};

    final primary =
        structuredFormat['mainText']?['text'] as String? ??
        prediction['text']?['text'] as String? ??
        '';
    final secondary =
        structuredFormat['secondaryText']?['text'] as String? ?? '';

    return PlaceSuggestion(
      placeId: prediction['placeId'] as String? ?? '',
      primaryText: primary,
      secondaryText: secondary,
    );
  }
}

class PlaceDetails {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      id: json['id'] as String? ?? '',
      name: json['displayName']?['text'] as String? ?? '',
      address: json['formattedAddress'] as String? ?? '',
      latitude: (json['location']?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['location']?['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PlacesApiClient {
  String get _apiKey => dotenv.env['GOOGLE_API'] ?? '';

  Future<List<PlaceSuggestion>> autocomplete(
    String query,
    String sessionToken,
  ) async {
    log(_apiKey);
    if (query.isEmpty) return [];

    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:autocomplete'),
      headers: {'Content-Type': 'application/json', 'X-Goog-Api-Key': _apiKey},
      body: jsonEncode({'input': query, 'sessionToken': sessionToken}),
    );
    log("the google api response is ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final suggestions = data['suggestions'] as List<dynamic>? ?? [];
      return suggestions
          .map((e) => PlaceSuggestion.fromJson(e as Map<String, dynamic>))
          .where((e) => e.placeId.isNotEmpty)
          .toList();
    }
    return [];
  }

  Future<PlaceDetails?> getPlaceDetails(
    String placeId,
    String sessionToken,
  ) async {
    final response = await http.get(
      Uri.parse('https://places.googleapis.com/v1/places/$placeId'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': 'id,displayName,formattedAddress,location',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PlaceDetails.fromJson(data);
    }
    return null;
  }
}
