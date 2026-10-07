import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/ui_hint.dart';

part 'ui_hint_model.g.dart';

@JsonSerializable()
class UiHintOptionModel {
  const UiHintOptionModel({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  factory UiHintOptionModel.fromJson(Map<String, dynamic> json) =>
      _$UiHintOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$UiHintOptionModelToJson(this);

  UiHintOption toEntity() {
    return UiHintOption(
      value: value,
      label: label,
    );
  }
}

@JsonSerializable()
class UiHintModel {
  const UiHintModel({
    required this.key,
    required this.label,
    required this.widget,
    this.group,
    required this.order,
    this.unit,
    this.options,
  });

  final String key;
  final String label;
  final String widget;
  final String? group;
  final int order;
  final String? unit;
  final List<UiHintOptionModel>? options;

  factory UiHintModel.fromJson(Map<String, dynamic> json) =>
      _$UiHintModelFromJson(json);

  Map<String, dynamic> toJson() => _$UiHintModelToJson(this);

  UiHint toEntity() {
    return UiHint(
      key: key,
      label: label,
      widget: widget,
      group: group,
      order: order,
      unit: unit,
      options: options?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
