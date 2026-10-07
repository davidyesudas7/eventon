import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_attribute.dart';

part 'category_attribute_model.g.dart';

@JsonSerializable()
class CategoryAttributeModel {
  const CategoryAttributeModel({
    required this.id,
    required this.name,
    required this.uiHint,
    this.options,
    this.min,
    this.max,
  });

  final String id;
  final String name;
  final String uiHint;
  final List<String>? options;
  final num? min;
  final num? max;

  factory CategoryAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryAttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryAttributeModelToJson(this);

  CategoryAttribute toEntity() {
    return CategoryAttribute(
      id: id,
      name: name,
      uiHint: uiHint,
      options: options ?? [],
      min: min,
      max: max,
    );
  }
}
