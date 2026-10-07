// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingMediaModel _$ListingMediaModelFromJson(Map<String, dynamic> json) =>
    ListingMediaModel(
      cover: json['cover'] == null
          ? null
          : MediaAssetModel.fromJson(json['cover'] as Map<String, dynamic>),
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => MediaAssetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListingMediaModelToJson(ListingMediaModel instance) =>
    <String, dynamic>{'cover': instance.cover, 'gallery': instance.gallery};

MediaAssetModel _$MediaAssetModelFromJson(Map<String, dynamic> json) =>
    MediaAssetModel(url: json['url'] as String);

Map<String, dynamic> _$MediaAssetModelToJson(MediaAssetModel instance) =>
    <String, dynamic>{'url': instance.url};

ListingDetailModel _$ListingDetailModelFromJson(Map<String, dynamic> json) =>
    ListingDetailModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      attributes: json['attributes'] as Map<String, dynamic>,
      media: json['media'] == null
          ? null
          : ListingMediaModel.fromJson(json['media'] as Map<String, dynamic>),
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      priceFrom: json['priceFrom'] as num?,
    );

Map<String, dynamic> _$ListingDetailModelToJson(ListingDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'attributes': instance.attributes,
      'media': instance.media,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'priceFrom': instance.priceFrom,
    };
