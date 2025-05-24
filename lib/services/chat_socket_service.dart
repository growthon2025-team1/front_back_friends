import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../utils/auth_token.dart';

class ChatSocketService {
  static StompClient? _client;

  static void connect({
    required String chatRoomId,
    required Function(Map<String, dynamic>) onMessageReceived,
  }) {
    final token = AuthToken().accessToken;

    _client = StompClient(
      config: StompConfig(
        url: 'ws://34.64.149.252:8080/ws-chat',
        onConnect: (StompFrame frame) {
          _client!.subscribe(
            destination: '/sub/chat/room/$chatRoomId',
            callback: (frame) {
              final message = frame.body!;
              try {
                final parsed =
                    message.isNotEmpty
                        ? Map<String, dynamic>.from(jsonDecode(message) as Map)
                        : <String, dynamic>{};
                onMessageReceived(parsed);
              } catch (e) {
                print('❌ 메시지 파싱 오류: $e');
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => print('❌ WebSocket 에러: $error'),
        stompConnectHeaders: {'Authorization': '$token'},
        webSocketConnectHeaders: {'Authorization': 'bearer $token'},
        reconnectDelay: const Duration(seconds: 5),
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );

    _client!.activate();
  }

  static void sendMessage({
    required String chatRoomId,
    required String content,
  }) {
    final token = AuthToken().accessToken;

    if (_client == null || !_client!.connected) {
      print('❌ STOMP 연결이 아직 설정되지 않았습니다.');
      return;
    }

    final message = {
      'chatRoomId': int.parse(chatRoomId),
      'senderId': null,
      'content': content,
    };

    _client?.send(
      destination: '/pub/chat/message',
      body: jsonEncode(message),
      headers: {'Authorization': 'bearer $token'},
    );
  }

  static void disconnect() {
    _client?.deactivate();
  }
}
