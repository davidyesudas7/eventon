import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/services/socket_service.dart';
import '../../../listings/data/models/listing_detail_model.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_providers.g.dart';

@riverpod
Future<ConversationModel> conversationDetail(Ref ref, String id) async {
  return ref.watch(apiClientProvider).getConversation(id);
}

@riverpod
Future<ListingDetailModel> listingDetail(Ref ref, String id) async {
  return ref.watch(apiClientProvider).getListing(id);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(apiClient: ref.watch(apiClientProvider));
}

@riverpod
class ConversationsNotifier extends _$ConversationsNotifier {
  @override
  FutureOr<List<ConversationModel>> build() async {
    return _fetchConversations();
  }

  Future<List<ConversationModel>> _fetchConversations() async {
    final repository = ref.watch(chatRepositoryProvider);
    final result = await repository.getConversations();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (conversations) => conversations,
    );
  }
}

@riverpod
class ChatDetailNotifier extends _$ChatDetailNotifier {
  @override
  FutureOr<List<MessageModel>> build(String conversationId) async {
    final socketService = ref.watch(socketServiceProvider);

    // 1. Connect to socket with auth token and join conversation room
    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token != null) {
      socketService.connect(
        token: token,
        conversationId: conversationId,
      );
    }

    // 2. Listen to socket message event with deduplication
    final subscription = socketService.messageStream.listen((data) {
      try {
        final newMessage = MessageModel.fromJson(data);
        if (newMessage.conversationId == conversationId) {
          final currentState = state.value ?? [];
          // Deduplication: prevent adding if message ID already exists
          if (currentState.any((m) => m.id == newMessage.id)) {
            return;
          }
          state = AsyncValue.data([...currentState, newMessage]);
        }
      } catch (e) {
        // Catch parsing error if payload format differs
      }
    });

    // 3. Lifecycle: Cancel listener and disconnect socket on dispose
    ref.onDispose(() {
      subscription.cancel();
      socketService.disconnect();
    });

    // 4. Initial load of messages via REST API
    return _fetchMessages(conversationId);
  }

  Future<List<MessageModel>> _fetchMessages(String conversationId) async {
    final repository = ref.watch(chatRepositoryProvider);
    final result = await repository.getMessages(conversationId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (messages) => messages,
    );
  }

  Future<void> sendMessage(String text) async {
    final repository = ref.read(chatRepositoryProvider);
    final result = await repository.sendMessage(conversationId, text);

    result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (newMessage) {
        final currentState = state.value ?? [];
        if (!currentState.any((m) => m.id == newMessage.id)) {
          state = AsyncValue.data([...currentState, newMessage]);
        }
      },
    );
  }

  Future<MessageModel> respondToQuote({
    required String messageId,
    required bool accept,
  }) async {
    final repository = ref.read(chatRepositoryProvider);
    final result = accept
        ? await repository.acceptQuote(conversationId, messageId)
        : await repository.rejectQuote(conversationId, messageId);

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (updatedMessage) {
        final currentMessages = state.value ?? [];
        final index = currentMessages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          final updatedList = List<MessageModel>.from(currentMessages);
          updatedList[index] = updatedMessage;
          state = AsyncValue.data(updatedList);
        }
        return updatedMessage;
      },
    );
  }
}

@riverpod
class CreateConversationNotifier extends _$CreateConversationNotifier {
  @override
  bool build() {
    return false; // isCreating
  }

  String? lastError;

  Future<ConversationModel?> createConversation(String listingId, DateTime eventDate) async {
    lastError = null;
    state = true;
    try {
      final client = ref.read(apiClientProvider);
      final conversation = await client.createConversation({
        'listingId': listingId,
        'eventDate': eventDate.toUtc().toIso8601String(),
      });
      // Invalidate the conversations list so the new chat shows up in the Chats tab
      ref.invalidate(conversationsProvider);
      state = false;
      return conversation;
    } catch (e) {
      lastError = extractErrorMessage(e, defaultMessage: 'Failed to start conversation');
      state = false;
      return null;
    }
  }
}
