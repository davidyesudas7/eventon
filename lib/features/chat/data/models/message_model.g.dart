// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  senderId: json['senderId'] as String?,
  type: json['type'] as String,
  text: json['text'] as String?,
  quote: json['quote'] as Map<String, dynamic>?,
  quoteRequest: json['quoteRequest'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'type': instance.type,
      'text': instance.text,
      'quote': instance.quote,
      'quoteRequest': instance.quoteRequest,
      'createdAt': instance.createdAt.toIso8601String(),
    };

PaginatedMessagesModel _$PaginatedMessagesModelFromJson(
  Map<String, dynamic> json,
) => PaginatedMessagesModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedMessagesModelToJson(
  PaginatedMessagesModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
