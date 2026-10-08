import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // Listen to socket for new messages
    final socketService = ref.watch(socketServiceProvider);
    
    final subscription = socketService.messageStream.listen((data) {
      final newMessage = MessageModel.fromJson(data);
      if (newMessage.conversationId == conversationId) {
         final currentState = state.value ?? [];
         // Add new message to the list (assuming latest at the bottom)
         state = AsyncValue.data([...currentState, newMessage]); 
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

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
        // The backend might echo the message via socket, 
        // but if we want it to show immediately, we can uncomment below:
        // final currentState = state.value ?? [];
        // state = AsyncValue.data([...currentState, newMessage]);
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

  Future<ConversationModel?> createConversation(String listingId, DateTime eventDate) async {
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
      state = false;
      return null;
    }
  }
}
