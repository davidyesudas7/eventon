import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String id;
  final num rating;
  final String comment;
  final String createdAt;
  final String customerId;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.customerId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class PaginatedReviewsModel {
  final List<ReviewModel> items;
  final int total;
  final int page;
  final int limit;

  PaginatedReviewsModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedReviewsModel.fromJson(Map<String, dynamic> json) => _$PaginatedReviewsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedReviewsModelToJson(this);
}
