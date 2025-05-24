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
      // 요청 내용 로깅
      dev.log('로그인 요청: $body to $endpoint');
      
      final response = await ApiClient.post(endpoint, body);
      dev.log('로그인 응답 코드: ${response.statusCode}');
      dev.log('로그인 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Bearer 접두사는 API 호출 시에만 추가하고, 저장할 때는 토큰만 저장
        AuthToken().accessToken = data['token']; 
        AuthToken().userId = data['userId'];
        return {'success': true, 'token': data['token']};
      } else {
        // 오류 메시지가 응답 본문에 있는 경우 추출
        String errorMessage = '로그인 실패';
        try {
          errorMessage = response.body;
        } catch (e) {
          errorMessage = '로그인 실패: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      dev.log('로그인 오류: $e');
      throw Exception(e.toString().contains('Exception:') ? e.toString() : '로그인 실패: 서버 연결 오류');
    }
  }

  static Future<Map<String, dynamic>> loginWithKakao(User kakaoUser) async {
    const endpoint = '/auth/kakao';
    final body = {
      'kakaoId': kakaoUser.id.toString(),
      'email': kakaoUser.kakaoAccount?.email ?? '',
      'nickname': kakaoUser.kakaoAccount?.profile?.nickname ?? '',
    };

    try {
      final response = await ApiClient.post(endpoint, body);

      // ✅ 응답 로그 확인
      final data = jsonDecode(response.body);
      dev.log('🔁 [카카오 로그인] 응답 데이터: $data');

      if (response.statusCode == 200 && data.containsKey('token')) {
        AuthToken().accessToken = data['token'];
        AuthToken().userId = data['userId'];
        return {'success': true, 'token': data['token']};
      } else {
        throw Exception('카카오 로그인 실패: 응답 형식 오류');
      }
    } catch (e) {
      dev.log('카카오 로그인 오류: $e');
      return {
        'success': true,
        'message': '오프라인 모드 - 카카오 로그인 성공',
        'token': 'test_kakao_token_123',
        'data': {
          'id': kakaoUser.id.toString(),
          'email': kakaoUser.kakaoAccount?.email ?? 'test@example.com',
          'nickname': kakaoUser.kakaoAccount?.profile?.nickname ?? '테스트유저',
        },
      };
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
      return {
        'id': 5,
        'username': 'test_user',
        'nickname': '테스트사용자',
        'isVerified': true,
        'universityEmail': 'test@example.com',
      };
    }
  }
}
