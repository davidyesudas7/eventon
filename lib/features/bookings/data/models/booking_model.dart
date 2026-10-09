import 'package:json_annotation/json_annotation.dart';

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
  final DateTime? reviewedAt;
  final DateTime? disputedAt;
  final String? disputeReason;
  final DateTime? disputeResolvedAt;
  final String? disputeResolution;

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
    this.reviewedAt,
    this.disputedAt,
    this.disputeReason,
    this.disputeResolvedAt,
    this.disputeResolution,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  bool get isCancelled => status?.toLowerCase() == 'cancelled';
  bool get isDisputeResolved => disputeResolvedAt != null;
  bool get isDisputed =>
      (status?.toLowerCase() == 'disputed' || disputedAt != null) &&
      disputeResolvedAt == null;
  bool get isCompleted =>
      (status?.toLowerCase() == 'completed' && !isDisputed) ||
      (status?.toLowerCase() == 'disputed' && disputeResolvedAt != null);
  bool get isInProgress {
    final s = status?.toLowerCase();
    return s == 'in_progress' || s == 'inprogress';
  }
  bool get isConfirmed => status?.toLowerCase() == 'confirmed';
  bool get isPendingAdvance {
    final s = status?.toLowerCase();
    return s == 'pending_advance' || s == 'pending' || s == 'awaiting_advance';
  }

  bool get isPast {
    if (isCompleted) return true;
    if (isCancelled || isDisputed) return false;
    if (isPendingAdvance || isConfirmed || isInProgress) return false;
    if (eventDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return eventDate!.isBefore(today);
  }

  bool get isUpcoming => !isCancelled && !isCompleted && !isPast;
  
  double get minAdvance => (amount ?? 0) * (minAdvancePercent ?? 20) / 100.0;
  double get totalAmount => amount ?? 0;
  double get paidAdvance => advanceAmount ?? minAdvance;
  double get paidAmount => advanceAmount ?? minAdvance;
  double get effectiveBalance =>
      balanceAmount ?? ((amount ?? 0) - (advanceAmount ?? minAdvance));
  String get serviceName => description ?? 'Service';
}
