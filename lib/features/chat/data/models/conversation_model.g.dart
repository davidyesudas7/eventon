// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      vendorId: json['vendorId'] as String,
      listingId: json['listingId'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      bookingId: json['bookingId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      unreadCount: (json['unreadCount'] as num).toInt(),
      participantName: json['participantName'] as String?,
      participantImage: json['participantImage'] as String?,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'vendorId': instance.vendorId,
      'listingId': instance.listingId,
      'eventDate': instance.eventDate.toIso8601String(),
      'bookingId': instance.bookingId,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessagePreview': instance.lastMessagePreview,
      'unreadCount': instance.unreadCount,
      'participantName': instance.participantName,
      'participantImage': instance.participantImage,
    };
