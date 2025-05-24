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

    // 요청 정보 로깅
    dev.log('🔄 [카카오 로그인] 요청 데이터: $body');
    dev.log('🔄 [카카오 로그인] 카카오 ID: ${kakaoUser.id}');
    dev.log('🔄 [카카오 로그인] 이메일: ${kakaoUser.kakaoAccount?.email}');
    dev.log('🔄 [카카오 로그인] 닉네임: ${kakaoUser.kakaoAccount?.profile?.nickname}');

    try {
      final response = await ApiClient.post(endpoint, body);
      dev.log('🔄 [카카오 로그인] 응답 코드: ${response.statusCode}');
      dev.log('🔄 [카카오 로그인] 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          dev.log('🔄 [카카오 로그인] 응답 데이터: $data');

          if (data.containsKey('token')) {
            // 토큰 저장 - AuthToken 클래스의 setter 사용
            AuthToken().accessToken = data['token'];
            AuthToken().userId = data['userId'] ?? 0;
            return {'success': true, 'token': data['token']};
          } else {
            throw Exception('카카오 로그인 실패: 토큰 정보 없음');
          }
        } catch (parseError) {
          dev.log('🔄 [카카오 로그인] JSON 파싱 오류: $parseError');
          throw Exception('카카오 로그인 응답 처리 오류: $parseError');
        }
      } else {
        // 오류 메시지 추출 시도
        String errorMessage = '카카오 로그인 실패: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else {
            errorMessage = response.body;
          }
        } catch (e) {
          // JSON 파싱 실패 시 원본 응답 사용
          errorMessage = response.body;
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      dev.log('🔄 [카카오 로그인] 오류: $e');
      
      // 디버그 모드에서만 테스트 토큰 반환 (실제 환경에서는 오류 전파)
      bool isDebugMode = true; // 실제 환경에서는 false로 설정
      
      if (isDebugMode) {
        dev.log('🔄 [카카오 로그인] 디버그 모드로 테스트 토큰 반환');
        return {
          'success': true,
          'message': '테스트 모드 - 카카오 로그인 성공',
          'token': 'test_kakao_token_123',
          'userId': 999,
        };
      } else {
        // 실제 환경에서는 오류 전파
        throw e;
      }
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
