import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/occasion_detail.dart';
import 'category_model.dart';

part 'occasion_detail_model.g.dart';

@JsonSerializable()
class OccasionDetailModel {
  const OccasionDetailModel({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.coverUrl,
    required this.order,
    required this.isActive,
    required this.categoryCount,
    required this.categories,
  });

  final String id;
  final String name;
  final String slug;
  final String? tagline;
  final String? coverUrl;
  final int order;
  final bool isActive;
  final int categoryCount;
  final List<CategoryModel> categories;

  factory OccasionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionDetailModelToJson(this);

  OccasionDetail toEntity() {
    return OccasionDetail(
      id: id,
      name: name,
      slug: slug,
      tagline: tagline,
      coverUrl: coverUrl,
      order: order,
      isActive: isActive,
      categoryCount: categoryCount,
      categories: categories.map((c) => c.toEntity()).toList(),
    );
  }
}
