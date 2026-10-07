// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedLocation _$SavedLocationFromJson(Map<String, dynamic> json) =>
    SavedLocation(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusKm: (json['radiusKm'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SavedLocationToJson(SavedLocation instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
    };
