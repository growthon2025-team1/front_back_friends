import 'dart:convert';
import 'dart:developer' as dev;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'api_client.dart';
import '../utils/auth_token.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    const endpoint = '/auth/signup';
    final body = {
      'username': email,
      'password': password,
      'nickname': name,
      'email': email,
    };

    try {
      final response = await ApiClient.post(endpoint, body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('회원가입 실패: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('회원가입 오류: $e');
      return {'success': true, 'message': '오프라인 모드 - 회원가입 성공'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    const endpoint = '/auth/login';
    final body = {'username': email, 'password': password};

    try {
      final response = await ApiClient.post(endpoint, body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AuthToken().accessToken = data['token'];

        final userInfo = await getUserInfo();
        AuthToken().userId = userInfo['id'];
        return {'success': true, 'token': data['token']};
      } else {
        throw Exception('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('로그인 오류: $e');
      throw Exception('로그인 실패: 서버 연결 오류');
    }
  }

  static Future<Map<String, dynamic>> loginWithKakao(User kakaoUser) async {
    const endpoint = '/auth/kakao';
    final body = {
      'email': kakaoUser.kakaoAccount?.email ?? '',
      'nickname': kakaoUser.kakaoAccount?.profile?.nickname ?? '',
      'profileImage': kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? '',
    };

    try {
      final response = await ApiClient.post(endpoint, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AuthToken().accessToken = data['token']; // ✅ 토큰 저장 추가
        final userInfo = await getUserInfo(); // ✅ 사용자 정보 저장
        AuthToken().userId = userInfo['id'];
        return {'success': true, 'token': data['token']};
      } else {
        throw Exception('카카오 로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('카카오 로그인 오류: $e');
      rethrow;
    }
  }

  static Future<bool> checkIdDuplicate(String userId) async {
    final endpoint = '/auth/check-id?request=$userId';

    try {
      final response = await ApiClient.post(endpoint, {});
      return response.statusCode == 200;
    } catch (e) {
      dev.log('중복 확인 오류: $e');
      return true;
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    const endpoint = '/auth/me';
    final token = AuthToken().accessToken;

    try {
      final response = await ApiClient.get(
        endpoint,
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('사용자 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('사용자 정보 오류: $e');
      rethrow;
    }
  }
}
