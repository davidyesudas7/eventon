// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['id'] as String,
  rating: json['rating'] as num,
  comment: json['comment'] as String,
  createdAt: json['createdAt'] as String,
  customerId: json['customerId'] as String,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'customerId': instance.customerId,
    };

PaginatedReviewsModel _$PaginatedReviewsModelFromJson(
  Map<String, dynamic> json,
) => PaginatedReviewsModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedReviewsModelToJson(
  PaginatedReviewsModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
