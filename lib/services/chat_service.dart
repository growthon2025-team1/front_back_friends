import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_client.dart';
import '../utils/auth_token.dart';

class ChatService {
  static Future<List<Map<String, dynamic>>> fetchChatRooms() async {
    final token = AuthToken().accessToken;

    final response = await ApiClient.get(
      '/api/chatrooms',
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final List json = jsonDecode(response.body);
      return json.cast<Map<String, dynamic>>();
    } else {
      throw Exception('채팅방 불러오기 실패: ${response.statusCode}');
    }
  }
}
