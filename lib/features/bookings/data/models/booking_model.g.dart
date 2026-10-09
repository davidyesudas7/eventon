// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  status: json['status'] as String?,
  eventDate: json['eventDate'] == null
      ? null
      : DateTime.parse(json['eventDate'] as String),
  amount: (json['amount'] as num?)?.toDouble(),
  advanceAmount: (json['advanceAmount'] as num?)?.toDouble(),
  balanceAmount: (json['balanceAmount'] as num?)?.toDouble(),
  description: json['description'] as String?,
  listingId: json['listingId'] as String?,
  vendorId: json['vendorId'] as String?,
  customerId: json['customerId'] as String?,
  conversationId: json['conversationId'] as String?,
  minAdvancePercent: (json['minAdvancePercent'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
  disputedAt: json['disputedAt'] == null
      ? null
      : DateTime.parse(json['disputedAt'] as String),
  disputeReason: json['disputeReason'] as String?,
  disputeResolvedAt: json['disputeResolvedAt'] == null
      ? null
      : DateTime.parse(json['disputeResolvedAt'] as String),
  disputeResolution: json['disputeResolution'] as String?,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'eventDate': instance.eventDate?.toIso8601String(),
      'amount': instance.amount,
      'advanceAmount': instance.advanceAmount,
      'balanceAmount': instance.balanceAmount,
      'description': instance.description,
      'listingId': instance.listingId,
      'vendorId': instance.vendorId,
      'customerId': instance.customerId,
      'conversationId': instance.conversationId,
      'minAdvancePercent': instance.minAdvancePercent,
      'createdAt': instance.createdAt?.toIso8601String(),
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'disputedAt': instance.disputedAt?.toIso8601String(),
      'disputeReason': instance.disputeReason,
      'disputeResolvedAt': instance.disputeResolvedAt?.toIso8601String(),
      'disputeResolution': instance.disputeResolution,
    };
