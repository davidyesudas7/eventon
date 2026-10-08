import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/listings/data/models/listing_detail_model.dart';
import '../../../../features/listings/data/models/package_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String? status;
  final DateTime? eventDate;
  final double? amount;
  final double? advanceAmount;
  final double? balanceAmount;
  final String? description;
  final String? listingId;
  final String? vendorId;
  final String? customerId;
  final String? conversationId;
  final double? minAdvancePercent;
  final DateTime? createdAt; // Note: API might not have createdAt, but it might have advancePaidAt etc. Let's keep what we need.

  BookingModel({
    required this.id,
    this.status,
    this.eventDate,
    this.amount,
    this.advanceAmount,
    this.balanceAmount,
    this.description,
    this.listingId,
    this.vendorId,
    this.customerId,
    this.conversationId,
    this.minAdvancePercent,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  bool get isCancelled => status?.toLowerCase() == 'cancelled';
  bool get isPast {
    if (eventDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return eventDate!.isBefore(today);
  }
  bool get isUpcoming => !isCancelled && !isPast;
  
  double get minAdvance => (amount ?? 0) * (minAdvancePercent ?? 20) / 100.0;
  double get totalAmount => amount ?? 0;
  double get paidAmount => advanceAmount ?? 0;
  String get serviceName => description ?? 'Service';
}
