import 'package:json_annotation/json_annotation.dart';

part 'saved_location.g.dart';

@JsonSerializable()
class SavedLocation {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int? radiusKm;

  const SavedLocation({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.radiusKm,
  });

  factory SavedLocation.fromJson(Map<String, dynamic> json) =>
      _$SavedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SavedLocationToJson(this);

  SavedLocation copyWith({
    String? placeId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? radiusKm,
    bool clearRadius = false,
  }) {
    return SavedLocation(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: clearRadius ? null : (radiusKm ?? this.radiusKm),
    );
  }
}
