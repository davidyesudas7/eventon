import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final String id;
  final String customerId;
  final String vendorId;
  final String listingId;
  final DateTime eventDate;
  final String? bookingId;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;
  final int unreadCount;
  final String? participantName;
  final String? participantImage;

  ConversationModel({
    required this.id,
    required this.customerId,
    required this.vendorId,
    required this.listingId,
    required this.eventDate,
    this.bookingId,
    this.lastMessageAt,
    this.lastMessagePreview,
    required this.unreadCount,
    this.participantName,
    this.participantImage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
