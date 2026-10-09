import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient apiClient;

  ChatRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations() async {
    try {
      final response = await apiClient.getConversations();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationModel>> getConversation(String id) async {
    try {
      final response = await apiClient.getConversation(id);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(
    String conversationId,
  ) async {
    try {
      final response = await apiClient.getMessages(conversationId);

      return Right(response.items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(
    String conversationId,
    String text,
  ) async {
    try {
      final response = await apiClient.sendMessage(conversationId, {
        'text': text,
      });
      log('the message send response is ${response.toString()}');
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> acceptQuote(
    String conversationId,
    String messageId,
  ) async {
    try {
      final response = await apiClient.acceptQuote(conversationId, messageId);
      log('Accept quote response: ${response.toString()}');
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> rejectQuote(
    String conversationId,
    String messageId,
  ) async {
    try {
      final response = await apiClient.rejectQuote(conversationId, messageId);
      log('Reject quote response: ${response.toString()}');
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
