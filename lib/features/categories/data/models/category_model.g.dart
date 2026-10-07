// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isActive: json['isActive'] as bool,
      occasionIds: (json['occasionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      uiHints: (json['uiHints'] as List<dynamic>?)
          ?.map((e) => UiHintModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      attributeSchema: json['attributeSchema'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon': instance.icon,
      'iconUrl': instance.iconUrl,
      'isActive': instance.isActive,
      'occasionIds': instance.occasionIds,
      'uiHints': instance.uiHints,
      'attributeSchema': instance.attributeSchema,
    };
