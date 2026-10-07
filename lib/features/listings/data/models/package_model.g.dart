// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) => PackageModel(
  id: json['id'] as String,
  listingId: json['listingId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  price: json['price'] as num,
  durationLabel: json['durationLabel'] as String?,
  inclusions: (json['inclusions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PackageModelToJson(PackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'durationLabel': instance.durationLabel,
      'inclusions': instance.inclusions,
    };
