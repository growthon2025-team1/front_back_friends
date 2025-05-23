import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PostService {
  // 게시글 생성
  static Future<Map<String, dynamic>> createPost(
    Map<String, dynamic> postData,
    String token,
  ) async {
    final response = await ApiClient.post(
      '/posts',
      postData,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // 게시글 목록 조회
  static Future<List<dynamic>> fetchPostList() async {
    final response = await ApiClient.get('/posts');
    return jsonDecode(response.body);
  }

  // 게시글 상세 조회
  static Future<Map<String, dynamic>> fetchPostDetail(int postId) async {
    final response = await ApiClient.get('/posts/$postId');
    return jsonDecode(response.body);
  }

  // 게시글 삭제
  static Future<void> deletePost(int postId, String token) async {
    final uri = Uri.parse('$baseUrl/posts/$postId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode != 204) {
      throw Exception('게시글 삭제 실패: ${response.statusCode}');
    }
  }

  // 게시글 수정
  static Future<Map<String, dynamic>> updatePost(
    int postId,
    Map<String, dynamic> updateData,
    String token,
  ) async {
    final uri = Uri.parse('$baseUrl/posts/$postId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(updateData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('게시글 수정 실패: ${response.statusCode}');
    }
  }
}
