import 'package:json_annotation/json_annotation.dart';

part 'quote_request_model.g.dart';

@JsonSerializable()
class QuoteRequestModel {
  final String id;
  final DateTime? eventDate;
  final int? guestCount;
  final num? budget;
  @JsonKey(name: 'eventLocation')
  final String? location;
  @JsonKey(name: 'message')
  final String? requirements;
  final String? status;
  final int? vendorsAsked;
  final int? quotesReceived;
  @JsonKey(name: 'items')
  final List<QuoteRequestVendorModel> vendors;

  QuoteRequestModel({
    required this.id,
    this.eventDate,
    this.guestCount,
    this.budget,
    this.location,
    this.requirements,
    this.status,
    this.vendorsAsked,
    this.quotesReceived,
    this.vendors = const [],
  });

  factory QuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteRequestModelToJson(this);
}

@JsonSerializable()
class QuoteRequestVendorModel {
  final String listingId;
  @JsonKey(name: 'listingTitle')
  final String? name;
  @JsonKey(name: 'listingCoverUrl')
  final String? coverUrl;
  @JsonKey(name: 'vendorName')
  final String? subtitle;
  final String? status;
  final String? state;
  final String? conversationId;
  final dynamic latestQuote;

  QuoteRequestVendorModel({
    required this.listingId,
    this.name,
    this.coverUrl,
    this.subtitle,
    this.status,
    this.state,
    this.conversationId,
    this.latestQuote,
  });

  factory QuoteRequestVendorModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteRequestVendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteRequestVendorModelToJson(this);
}

@JsonSerializable()
class PaginatedQuoteRequestsModel {
  final List<QuoteRequestModel> items;
  final int? total;
  final int? page;
  final int? limit;

  PaginatedQuoteRequestsModel({
    this.items = const [],
    this.total,
    this.page,
    this.limit,
  });

  factory PaginatedQuoteRequestsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedQuoteRequestsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedQuoteRequestsModelToJson(this);
}
