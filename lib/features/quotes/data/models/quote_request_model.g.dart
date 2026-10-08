// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteRequestModel _$QuoteRequestModelFromJson(Map<String, dynamic> json) =>
    QuoteRequestModel(
      id: json['id'] as String,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      guestCount: (json['guestCount'] as num?)?.toInt(),
      budget: json['budget'] as num?,
      location: json['eventLocation'] as String?,
      requirements: json['message'] as String?,
      status: json['status'] as String?,
      vendorsAsked: (json['vendorsAsked'] as num?)?.toInt(),
      quotesReceived: (json['quotesReceived'] as num?)?.toInt(),
      vendors:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    QuoteRequestVendorModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuoteRequestModelToJson(QuoteRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventDate': instance.eventDate?.toIso8601String(),
      'guestCount': instance.guestCount,
      'budget': instance.budget,
      'eventLocation': instance.location,
      'message': instance.requirements,
      'status': instance.status,
      'vendorsAsked': instance.vendorsAsked,
      'quotesReceived': instance.quotesReceived,
      'items': instance.vendors,
    };

QuoteRequestVendorModel _$QuoteRequestVendorModelFromJson(
  Map<String, dynamic> json,
) => QuoteRequestVendorModel(
  listingId: json['listingId'] as String,
  name: json['listingTitle'] as String?,
  coverUrl: json['listingCoverUrl'] as String?,
  subtitle: json['vendorName'] as String?,
  status: json['status'] as String?,
  state: json['state'] as String?,
  conversationId: json['conversationId'] as String?,
  latestQuote: json['latestQuote'],
);

Map<String, dynamic> _$QuoteRequestVendorModelToJson(
  QuoteRequestVendorModel instance,
) => <String, dynamic>{
  'listingId': instance.listingId,
  'listingTitle': instance.name,
  'listingCoverUrl': instance.coverUrl,
  'vendorName': instance.subtitle,
  'status': instance.status,
  'state': instance.state,
  'conversationId': instance.conversationId,
  'latestQuote': instance.latestQuote,
};

PaginatedQuoteRequestsModel _$PaginatedQuoteRequestsModelFromJson(
  Map<String, dynamic> json,
) => PaginatedQuoteRequestsModel(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => QuoteRequestModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginatedQuoteRequestsModelToJson(
  PaginatedQuoteRequestsModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
