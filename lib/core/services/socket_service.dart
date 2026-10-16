import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'socket_service.g.dart';

class SocketService {
  io.Socket? _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final Set<String> _joinedConversations = {};
  String? _currentToken;
  bool _isConnecting = false;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String token,
    String? conversationId,
  }) {
    if (conversationId != null) {
      _joinedConversations.add(conversationId);
    }

    if (_socket != null && _currentToken == token) {
      if (_socket!.connected) {
        if (conversationId != null) {
          joinConversation(conversationId);
        }
        return;
      }
      if (_isConnecting) {
        return;
      }
    }

    _currentToken = token;
    _isConnecting = true;
    disconnect(clearRooms: false);

    final rawUrl = dotenv.env['SOCKET_URL'] ??
        dotenv.env['BASE_URL'] ??
        dotenv.env['BASE_URL '] ??
        'https://api.eventongo.in';
    final socketUrl = rawUrl.trim().replaceAll(RegExp(r'/+$'), '');

    // 1. Connection Options: Connect using ONLY websocket transport and pass auth token
    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableReconnection()
          .build(),
    );

    // 2. Room Joining: Listen for connect event and immediately emit joinConversation for all joined conversations
    _socket?.onConnect((_) {
      _isConnecting = false;
      debugPrint(
          '[SocketService] Connected. Emitting joinConversation for ${_joinedConversations.length} conversations');
      for (final id in _joinedConversations) {
        try {
          _socket?.emit('joinConversation', {'conversationId': id});
        } catch (e) {
          debugPrint('[SocketService] Error emitting onConnect joinConversation: $e');
        }
      }
    });

    // 3. Message Listener: Listen for 'message', 'quote_request', and 'quoteRequest' events
    void handleIncoming(dynamic data) {
      debugPrint('[SocketService] Received socket payload: $data');
      if (data is Map<String, dynamic>) {
        _messageController.add(data);
      } else if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    }

    _socket?.on('message', handleIncoming);
    _socket?.on('quote_request', handleIncoming);
    _socket?.on('quoteRequest', handleIncoming);

    _socket?.onDisconnect((_) {
      _isConnecting = false;
      debugPrint('[SocketService] Disconnected');
    });

    _socket?.onConnectError((err) {
      _isConnecting = false;
      debugPrint('[SocketService] Connect error: $err');
    });

    _socket?.onError((err) {
      _isConnecting = false;
      debugPrint('[SocketService] Error: $err');
    });

    try {
      _socket?.connect();
    } catch (e) {
      _isConnecting = false;
      debugPrint('[SocketService] Socket connect call exception: $e');
    }
  }

  void joinConversation(String conversationId) {
    _joinedConversations.add(conversationId);
    if (_socket?.connected == true) {
      try {
        debugPrint('[SocketService] Emitting joinConversation: $conversationId');
        _socket?.emit('joinConversation', {'conversationId': conversationId});
      } catch (e) {
        debugPrint('[SocketService] Error emitting joinConversation: $e');
      }
    }
  }

  void leaveConversation(String conversationId) {
    _joinedConversations.remove(conversationId);
    if (_socket?.connected == true) {
      try {
        _socket?.emit('leaveConversation', {'conversationId': conversationId});
      } catch (e) {
        debugPrint('[SocketService] Error emitting leaveConversation: $e');
      }
    }
  }

  void disconnect({bool clearRooms = true}) {
    if (clearRooms) {
      _joinedConversations.clear();
      _currentToken = null;
    }
    _isConnecting = false;
    try {
      if (_socket != null) {
        _socket?.clearListeners();
        _socket?.disconnect();
        _socket?.dispose();
      }
    } catch (e) {
      debugPrint('[SocketService] Disconnect handled gracefully: $e');
    } finally {
      _socket = null;
    }
  }

  void dispose() {
    disconnect(clearRooms: true);
    _messageController.close();
  }
}

@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) {
  final service = SocketService();

  ref.onDispose(() {
    service.dispose();
  });
  return service;
}
