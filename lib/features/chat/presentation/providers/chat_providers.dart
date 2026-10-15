import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/services/socket_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../listings/data/models/listing_detail_model.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_providers.g.dart';

/// Tracks the ID of the conversation currently open on screen (if any)
class ActiveChatNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setActive(String? id) => state = id;
}

final activeChatConversationIdProvider =
    NotifierProvider<ActiveChatNotifier, String?>(ActiveChatNotifier.new);

/// Sum of unread messages across all active conversations
final totalUnreadMessagesCountProvider = Provider<int>((ref) {
  final authState = ref.watch(authControllerProvider);
  if (authState is! AuthStateAuthenticated) {
    return 0;
  }
  final conversationsAsync = ref.watch(conversationsProvider);
  return conversationsAsync.maybeWhen(
    data: (conversations) => conversations.fold<int>(
      0,
      (sum, c) => sum + (c.unreadCount > 0 ? c.unreadCount : 0),
    ),
    orElse: () => 0,
  );
});

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
    final authState = ref.watch(authControllerProvider);
    if (authState is! AuthStateAuthenticated) {
      return [];
    }

    final token = await ref.watch(tokenStorageProvider).getAccessToken();
    if (token == null || token.isEmpty) {
      return [];
    }

    return _fetchConversations();
  }

  Future<List<ConversationModel>> _fetchConversations() async {
    final authState = ref.read(authControllerProvider);
    if (authState is! AuthStateAuthenticated) {
      return [];
    }

    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token == null || token.isEmpty) {
      return [];
    }

    final repository = ref.watch(chatRepositoryProvider);
    final result = await repository.getConversations();
    return result.fold(
      (failure) => [],
      (conversations) => conversations,
    );
  }

  void setConversations(List<ConversationModel> list) {
    state = AsyncValue.data(list);
  }

  Future<void> markAsRead(String conversationId) async {
    final current = state.asData?.value;
    if (current != null) {
      final index = current.indexWhere((c) => c.id == conversationId);
      if (index != -1 && current[index].unreadCount > 0) {
        final old = current[index];
        final updated = ConversationModel(
          id: old.id,
          customerId: old.customerId,
          vendorId: old.vendorId,
          listingId: old.listingId,
          eventDate: old.eventDate,
          bookingId: old.bookingId,
          lastMessageAt: old.lastMessageAt,
          lastMessagePreview: old.lastMessagePreview,
          unreadCount: 0,
          participantName: old.participantName,
          participantImage: old.participantImage,
        );
        final list = List<ConversationModel>.from(current);
        list[index] = updated;
        state = AsyncValue.data(list);
      }
    }
    // Also send markAsRead to backend
    await ref.read(chatRepositoryProvider).markAsRead(conversationId);
  }
}

@riverpod
class ChatDetailNotifier extends _$ChatDetailNotifier {
  @override
  FutureOr<List<MessageModel>> build(String conversationId) async {
    final socketService = ref.watch(socketServiceProvider);

    // 1. Connect or ensure conversation room joined
    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token != null) {
      if (!socketService.isConnected) {
        socketService.connect(
          token: token,
          conversationId: conversationId,
        );
      } else {
        socketService.joinConversation(conversationId);
      }
    } else {
      socketService.joinConversation(conversationId);
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
          // Mark as read immediately while viewing this chat
          ref.read(conversationsProvider.notifier).markAsRead(conversationId);
        }
      } catch (e) {
        // Catch parsing error if payload format differs
      }
    });

    // 3. Lifecycle: Cancel listener on dispose (do NOT disconnect socket globally)
    ref.onDispose(() {
      subscription.cancel();
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
      // Invalidate the conversations list and join room
      ref.invalidate(conversationsProvider);
      ref.read(socketServiceProvider).joinConversation(conversation.id);
      state = false;
      return conversation;
    } catch (e) {
      lastError = extractErrorMessage(e, defaultMessage: 'Failed to start conversation');
      state = false;
      return null;
    }
  }
}

/// Service that keeps the socket and conversations synced globally
class ChatSyncService {
  final Ref ref;
  StreamSubscription? _socketSub;

  ChatSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is AuthStateAuthenticated) {
        _sync();
      } else {
        _cleanup();
      }
    }, fireImmediately: true);
  }

  Future<void> _sync() async {
    final authState = ref.read(authControllerProvider);
    if (authState is! AuthStateAuthenticated) return;

    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token == null || token.isEmpty) return;

    final socketService = ref.read(socketServiceProvider);
    socketService.connect(token: token);

    // Fetch initial conversations and join their rooms
    try {
      final conversations = await ref.read(conversationsProvider.future);
      for (final c in conversations) {
        socketService.joinConversation(c.id);
      }
    } catch (e) {
      debugPrint('[ChatSyncService] Error fetching conversations: $e');
    }

    _socketSub?.cancel();
    _socketSub = socketService.messageStream.listen((data) {
      _handleIncomingMessage(data);
    });
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    try {
      final msg = MessageModel.fromJson(data);
      final currentList = ref.read(conversationsProvider).asData?.value;
      if (currentList != null) {
        final index = currentList.indexWhere((c) => c.id == msg.conversationId);
        final activeChatId = ref.read(activeChatConversationIdProvider);
        final isChatActive = activeChatId == msg.conversationId;

        if (index != -1) {
          final old = currentList[index];
          final updated = ConversationModel(
            id: old.id,
            customerId: old.customerId,
            vendorId: old.vendorId,
            listingId: old.listingId,
            eventDate: old.eventDate,
            bookingId: old.bookingId,
            lastMessageAt: msg.createdAt,
            lastMessagePreview: msg.text,
            unreadCount: isChatActive ? 0 : (old.unreadCount + 1),
            participantName: old.participantName,
            participantImage: old.participantImage,
          );
          final updatedList = List<ConversationModel>.from(currentList);
          updatedList.removeAt(index);
          updatedList.insert(0, updated);
          ref.read(conversationsProvider.notifier).setConversations(updatedList);
        } else {
          // New conversation room came in, refresh list and join
          ref.invalidate(conversationsProvider);
          ref.read(socketServiceProvider).joinConversation(msg.conversationId);
        }
      } else {
        ref.invalidate(conversationsProvider);
      }
    } catch (e) {
      ref.invalidate(conversationsProvider);
    }
  }

  void _cleanup() {
    _socketSub?.cancel();
    _socketSub = null;
    ref.read(socketServiceProvider).disconnect();
  }

  void dispose() {
    _cleanup();
  }
}

/// Global provider keeping the socket and conversations active
final chatSyncProvider = Provider<ChatSyncService>((ref) {
  final service = ChatSyncService(ref);
  ref.onDispose(service.dispose);
  return service;
});
