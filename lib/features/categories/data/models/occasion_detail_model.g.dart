// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionDetailModel _$OccasionDetailModelFromJson(Map<String, dynamic> json) =>
    OccasionDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      tagline: json['tagline'] as String?,
      coverUrl: json['coverUrl'] as String?,
      order: (json['order'] as num).toInt(),
      isActive: json['isActive'] as bool,
      categoryCount: (json['categoryCount'] as num).toInt(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OccasionDetailModelToJson(
  OccasionDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'tagline': instance.tagline,
  'coverUrl': instance.coverUrl,
  'order': instance.order,
  'isActive': instance.isActive,
  'categoryCount': instance.categoryCount,
  'categories': instance.categories,
};
