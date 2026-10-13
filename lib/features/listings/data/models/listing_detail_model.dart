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
  final String? type; // "image" or "video"
  final String? thumbnailUrl;
  final String? caption;
  final int? order;

  MediaAssetModel({
    required this.url,
    this.type = 'image',
    this.thumbnailUrl,
    this.caption,
    this.order = 0,
  });

  bool get isVideo =>
      (type?.toLowerCase() == 'video') ||
      url.toLowerCase().endsWith('.mp4') ||
      url.toLowerCase().endsWith('.mov') ||
      url.toLowerCase().endsWith('.webm');

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
  final List<MediaAssetModel>? gallery;
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
    this.gallery,
    this.ratingAvg,
    this.ratingCount,
    this.priceFrom,
  });

  List<MediaAssetModel> get allGalleryItems {
    final items = <MediaAssetModel>[];
    if (gallery != null && gallery!.isNotEmpty) {
      items.addAll(gallery!);
    } else if (media?.gallery != null && media!.gallery!.isNotEmpty) {
      items.addAll(media!.gallery!);
    }
    items.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return items;
  }

  factory ListingDetailModel.fromJson(Map<String, dynamic> json) => _$ListingDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListingDetailModelToJson(this);
}
