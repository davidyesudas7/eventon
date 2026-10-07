import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_result.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchListingModel {
  final String id;
  final String title;
  final String categoryId;
  final String? description;
  final num? priceFrom;
  final Map<String, dynamic>? media;

  const SearchListingModel({
    required this.id,
    required this.title,
    required this.categoryId,
    this.description,
    this.priceFrom,
    this.media,
  });

  factory SearchListingModel.fromJson(Map<String, dynamic> json) =>
      _$SearchListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchListingModelToJson(this);

  SearchListing toEntity() {
    String? coverUrl;
    if (media != null && media!['cover'] != null) {
      coverUrl = media!['cover']['url'] as String?;
    }
    return SearchListing(
      id: id,
      title: title,
      categoryId: categoryId,
      description: description,
      coverUrl: coverUrl,
      priceFrom: priceFrom,
    );
  }
}

@JsonSerializable()
class SearchResultModel {
  final List<SearchListingModel> items;
  final int total;
  final int page;
  final int limit;

  const SearchResultModel({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);

  SearchResult toEntity() {
    return SearchResult(
      items: items.map((e) => e.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
    );
  }
}
