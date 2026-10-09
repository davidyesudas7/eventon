import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'socket_service.g.dart';

class SocketService {
  io.Socket? _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String token,
    required String conversationId,
  }) {
    // Disconnect any existing connection before starting a new one
    disconnect();

    final rawUrl = dotenv.env['SOCKET_URL'] ??
        dotenv.env['BASE_URL'] ??
        'https://api.eventongo.in';
    final socketUrl = rawUrl.replaceAll(RegExp(r'/+$'), '');

    // 1. Connection Options: Connect using ONLY websocket transport and pass auth token
    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    // 2. Room Joining: Listen for connect event and immediately emit joinConversation
    _socket?.onConnect((_) {
      debugPrint(
          '[SocketService] Connected. Emitting joinConversation: $conversationId');
      _socket?.emit('joinConversation', {'conversationId': conversationId});
    });

    // 3. Message Listener: Listen for 'message' event
    _socket?.on('message', (data) {
      debugPrint('[SocketService] Received message: $data');
      if (data is Map<String, dynamic>) {
        _messageController.add(data);
      } else if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.onDisconnect((_) {
      debugPrint('[SocketService] Disconnected');
    });

    _socket?.onConnectError((err) {
      debugPrint('[SocketService] Connect error: $err');
    });

    _socket?.onError((err) {
      debugPrint('[SocketService] Error: $err');
    });

    _socket?.connect();
  }

  void joinConversation(String conversationId) {
    if (_socket?.connected == true) {
      _socket?.emit('joinConversation', {'conversationId': conversationId});
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

@riverpod
SocketService socketService(Ref ref) {
  final service = SocketService();

  ref.onDispose(() {
    service.dispose();
  });
  return service;
}
