// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryAttributeModel _$CategoryAttributeModelFromJson(
  Map<String, dynamic> json,
) => CategoryAttributeModel(
  id: json['id'] as String,
  name: json['name'] as String,
  uiHint: json['uiHint'] as String,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  min: json['min'] as num?,
  max: json['max'] as num?,
);

Map<String, dynamic> _$CategoryAttributeModelToJson(
  CategoryAttributeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'uiHint': instance.uiHint,
  'options': instance.options,
  'min': instance.min,
  'max': instance.max,
};
