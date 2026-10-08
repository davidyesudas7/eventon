import 'package:dartz/dartz.dart';
import 'package:eventon/features/chat/data/models/conversation_model.dart';
import 'package:eventon/features/chat/data/models/message_model.dart';
import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationModel>>> getConversations();
  Future<Either<Failure, ConversationModel>> getConversation(String id);
  Future<Either<Failure, List<MessageModel>>> getMessages(
    String conversationId,
  );
  // Future<Either<Failure, void>> markAsRead(String conversationId);
  Future<Either<Failure, MessageModel>> sendMessage(String conversationId, String text);
}
