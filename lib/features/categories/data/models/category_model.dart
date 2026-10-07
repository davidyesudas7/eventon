import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';
import 'ui_hint_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.icon,
    this.iconUrl,
    required this.isActive,
    required this.occasionIds,
    this.uiHints,
    this.attributeSchema,
  });

  final String id;
  final String name;
  final String slug;
  final String description;
  final String? icon;
  final String? iconUrl;
  final bool isActive;
  final List<String> occasionIds;
  final List<UiHintModel>? uiHints;
  final Map<String, dynamic>? attributeSchema;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      slug: slug,
      description: description,
      icon: icon,
      iconUrl: iconUrl,
      isActive: isActive,
      occasionIds: occasionIds,
      uiHints: uiHints?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
