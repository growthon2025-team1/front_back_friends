import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../constants.dart';

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

    // ✅ 응답이 비어도 처리할 수 있도록
    if (response.body.isNotEmpty) {
      return jsonDecode(response.body);
    } else {
      return {}; // 빈 응답이면 기본값
    }
  }

  // 게시글 목록 조회
  static Future<List<dynamic>> fetchPostList() async {
    try {
      final response = await ApiClient.get('/posts');
      return jsonDecode(response.body);
    } catch (e) {
      print('게시글 목록 가져오기 오류: $e');
      print('테스트 데이터 사용');
      // 테스트 데이터 사용
      return [
        {
          'id': 1,
          'title': '고구마 나눐어요',
          'content': '지난 번에 많이 사서 남은 고구마가 있습니다. 필요하신 분 가져가세요!',
          'latitude': 37.5665,
          'longitude': 126.9780,
          'userId': 1,
          'createdAt': '2025-05-23T10:30:00Z',
        },
        {
          'id': 2,
          'title': '상한 사과 나누기',
          'content': '사과가 많이 남았어요. 누구나 가져가세요~',
          'latitude': 37.5607,
          'longitude': 126.9961,
          'userId': 2,
          'createdAt': '2025-05-23T09:15:00Z',
        },
        {
          'id': 3,
          'title': '계란 나눐어요',
          'content': '지금 많은 계란이 남았는데 누군가 필요하신가요?',
          'latitude': 37.5540,
          'longitude': 126.9704,
          'userId': 3,
          'createdAt': '2025-05-23T11:45:00Z',
        },
        {
          'id': 4,
          'title': '오렌지 나눐어요',
          'content': '오렌지가 너무 많이 남았어요. 필요하신 분은 댓글 달아주세요.',
          'latitude': 37.5727,
          'longitude': 126.9881,
          'userId': 4,
          'createdAt': '2025-05-23T14:20:00Z',
        },
        {
          'id': 5,
          'title': '사용하지 않는 맥북 프로 나눔니다',
          'content': '새 맥북 프로 살아서 오래된 맥북을 나눐니다. 물과자집 근처에서 만나요!',
          'latitude': 37.5503,
          'longitude': 126.9903,
          'userId': 5,
          'createdAt': '2025-05-23T16:00:00Z',
        },
      ];
    }
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
