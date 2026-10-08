import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'socket_service.g.dart';

class SocketService {
  io.Socket? _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  void connect() {
    final socketUrl = dotenv.env['SOCKET_URL'] ?? 'https://api.eventongo.in/';
    
    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket?.connect();

    _socket?.onConnect((_) {
      print('Socket connected');
    });

    // Listen to possible message events
    _socket?.on('message', (data) {
      if (data is Map<String, dynamic>) {
        _messageController.add(data);
      }
    });
    
    _socket?.on('newMessage', (data) {
      if (data is Map<String, dynamic>) {
        _messageController.add(data);
      }
    });

    _socket?.onDisconnect((_) {
      print('Socket disconnected');
    });
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
