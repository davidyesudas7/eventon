// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchListingModel _$SearchListingModelFromJson(Map<String, dynamic> json) =>
    SearchListingModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      description: json['description'] as String?,
      priceFrom: json['priceFrom'] as num?,
      media: json['media'] as Map<String, dynamic>?,
      ratingAvg: (json['ratingAvg'] ?? json['rating']) as num?,
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      distanceMeters: json['distanceMeters'] as num?,
    );

Map<String, dynamic> _$SearchListingModelToJson(SearchListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'categoryId': instance.categoryId,
      'description': instance.description,
      'priceFrom': instance.priceFrom,
      'media': instance.media,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'distanceMeters': instance.distanceMeters,
    };

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) =>
    SearchResultModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => SearchListingModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
