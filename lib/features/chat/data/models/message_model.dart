import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String conversationId;
  final String? senderId;
  final String type;
  final String? text;
  final Map<String, dynamic>? quote;
  final Map<String, dynamic>? quoteRequest;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    this.senderId,
    required this.type,
    this.text,
    this.quote,
    this.quoteRequest,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

@JsonSerializable()
class PaginatedMessagesModel {
  final List<MessageModel> items;
  final int total;
  final int page;
  final int limit;

  PaginatedMessagesModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMessagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedMessagesModelToJson(this);
}
