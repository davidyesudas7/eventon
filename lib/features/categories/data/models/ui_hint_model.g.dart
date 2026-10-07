// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_hint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UiHintOptionModel _$UiHintOptionModelFromJson(Map<String, dynamic> json) =>
    UiHintOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$UiHintOptionModelToJson(UiHintOptionModel instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};

UiHintModel _$UiHintModelFromJson(Map<String, dynamic> json) => UiHintModel(
  key: json['key'] as String,
  label: json['label'] as String,
  widget: json['widget'] as String,
  group: json['group'] as String?,
  order: (json['order'] as num).toInt(),
  unit: json['unit'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => UiHintOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UiHintModelToJson(UiHintModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'widget': instance.widget,
      'group': instance.group,
      'order': instance.order,
      'unit': instance.unit,
      'options': instance.options,
    };
