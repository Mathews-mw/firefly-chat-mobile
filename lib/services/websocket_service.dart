import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:firefly_chat_mobile/services/auth_service.dart';

typedef EventCallback = void Function(dynamic payload);

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _reconnectInterval = Duration(seconds: 5);
  bool _manuallyDisconnected = false;

  final Map<String, EventCallback> _listeners = {};

  bool get isConnected => _channel != null;

  void connect() async {
    final token = await AuthService().getToken();

    if (token == null) {
      return;
    }

    final uri = Uri.parse('ws://10.0.2.2:3737/ws/chat/members');

    final headers = {'Authorization': 'Bearer $token'};

    final socket = await WebSocket.connect(uri.toString(), headers: headers);

    // _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel = IOWebSocketChannel(socket);

    _subscription = _channel!.stream.listen(
      (data) {
        try {
          final decoded = jsonDecode(data);
          final event = decoded['event'];
          final payload = decoded['payload'];

          final handler = _listeners[event];

          if (handler != null) {
            handler(payload);
          }
        } catch (e) {
          print('Erro ao decodificar evento WebSocket: $e');
        }
      },
      onError: (error) {
        print('Erro no WebSocket: $error');
        _tryReconnect();
      },
      onDone: () {
        print('WebSocket desconectado.');
        if (!_manuallyDisconnected) _tryReconnect();
      },
    );
  }

  void on(String event, EventCallback callback) {
    _listeners[event] = callback;
  }

  void send(String event, dynamic payload) {
    final data = jsonEncode({'event': event, 'payload': payload});

    _channel?.sink.add(data);
  }

  void disconnect() {
    _manuallyDisconnected = true;
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  void _tryReconnect() {
    Future.delayed(_reconnectInterval, () {
      if (!_manuallyDisconnected) {
        connect();
      }
    });
  }
}
