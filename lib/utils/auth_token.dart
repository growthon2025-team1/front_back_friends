class AuthToken {
  static final AuthToken _instance = AuthToken._internal();

  factory AuthToken() {
    return _instance;
  }

  AuthToken._internal();

  String? _accessToken;
  int? userId;

  // 토큰 설정 - 원시 토큰만 저장
  set accessToken(String? token) {
    _accessToken = token;
  }
  
  // 토큰 가져오기 - 필요시 Bearer 접두사를 자동으로 추가
  String get accessToken {
    if (_accessToken == null) return '';
    
    // 이미 Bearer가 있는지 확인하여 중복 방지
    if (_accessToken!.startsWith('Bearer ')) {
      return _accessToken!;
    }
    
    return 'Bearer $_accessToken';
  }
  
  // 원본 토큰만 가져오기 (Bearer 없이)
  String get rawToken {
    if (_accessToken == null) return '';
    
    // Bearer 접두사 제거
    if (_accessToken!.startsWith('Bearer ')) {
      return _accessToken!.substring(7);
    }
    
    return _accessToken!;
  }
  
  // 토큰이 있는지 확인
  bool get hasToken {
    return _accessToken != null && _accessToken!.isNotEmpty;
  }
  
  // 로그아웃 시 토큰 삭제
  void clear() {
    _accessToken = null;
    userId = null;
  }
}
