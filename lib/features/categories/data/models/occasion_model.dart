import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/occasion.dart';

part 'occasion_model.g.dart';

@JsonSerializable()
class OccasionModel {
  const OccasionModel({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.coverUrl,
    required this.order,
    required this.isActive,
    required this.categoryCount,
  });

  final String id;
  final String name;
  final String slug;
  final String? tagline;
  final String? coverUrl;
  final int order;
  final bool isActive;
  final int categoryCount;

  factory OccasionModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionModelToJson(this);

  Occasion toEntity() {
    return Occasion(
      id: id,
      name: name,
      slug: slug,
      tagline: tagline,
      coverUrl: coverUrl,
      order: order,
      isActive: isActive,
      categoryCount: categoryCount,
    );
  }
}
