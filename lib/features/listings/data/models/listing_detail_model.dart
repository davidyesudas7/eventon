import 'package:json_annotation/json_annotation.dart';

part 'listing_detail_model.g.dart';

@JsonSerializable()
class ListingMediaModel {
  final MediaAssetModel? cover;
  final List<MediaAssetModel>? gallery;

  ListingMediaModel({
    this.cover,
    this.gallery,
  });

  factory ListingMediaModel.fromJson(Map<String, dynamic> json) => _$ListingMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListingMediaModelToJson(this);
}

@JsonSerializable()
class MediaAssetModel {
  final String url;
  
  MediaAssetModel({
    required this.url,
  });

  factory MediaAssetModel.fromJson(Map<String, dynamic> json) => _$MediaAssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$MediaAssetModelToJson(this);
}

@JsonSerializable()
class ListingDetailModel {
  final String id;
  final String vendorId;
  final String categoryId;
  final String title;
  final String description;
  final Map<String, dynamic> attributes;
  final ListingMediaModel? media;
  final double? ratingAvg;
  final int? ratingCount;
  final num? priceFrom;

  ListingDetailModel({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.attributes,
    this.media,
    this.ratingAvg,
    this.ratingCount,
    this.priceFrom,
  });

  factory ListingDetailModel.fromJson(Map<String, dynamic> json) => _$ListingDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListingDetailModelToJson(this);
}
