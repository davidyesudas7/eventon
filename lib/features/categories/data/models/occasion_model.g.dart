// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionModel _$OccasionModelFromJson(Map<String, dynamic> json) =>
    OccasionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      tagline: json['tagline'] as String?,
      coverUrl: json['coverUrl'] as String?,
      order: (json['order'] as num).toInt(),
      isActive: json['isActive'] as bool,
      categoryCount: (json['categoryCount'] as num).toInt(),
    );

Map<String, dynamic> _$OccasionModelToJson(OccasionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'tagline': instance.tagline,
      'coverUrl': instance.coverUrl,
      'order': instance.order,
      'isActive': instance.isActive,
      'categoryCount': instance.categoryCount,
    };
