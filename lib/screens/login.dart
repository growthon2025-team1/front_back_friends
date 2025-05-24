import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import '../utils/auth_token.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _isWeb = false; // 웹 환경 여부

  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();

  bool _showIdError = false;
  bool _showPwError = false;

  // 로그 메시지 출력 함수
  void _log(String message) {
    dev.log(message);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  void _checkFields() {
    String id = _idController.text;
    String pw = _pwController.text;

    final passwordRegExp = RegExp(r'^(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$');

    setState(() {
      _isButtonEnabled = id.isNotEmpty && pw.isNotEmpty;
      // 개발 중에는 비밀번호 정규식 검사를 일시적으로 완화함
      // _isButtonEnabled = id.isNotEmpty && passwordRegExp.hasMatch(pw);
    });
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(_checkFields);
    _pwController.addListener(_checkFields);

    // 웹 환경 감지 - identical(0, 0.0)은 웹에서는 true, 네이티브에서는 false
    _isWeb = identical(0, 0.0);
    dev.log('웹 환경여부: $_isWeb');
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _idFocus.dispose();
    _pwFocus.dispose();
    super.dispose();
  }

  // 일반 로그인 처리 함수
  Future<void> _handleLogin() async {
    if (!_isButtonEnabled) return;

    setState(() {
      _isLoading = true;
      // 오류 메시지 초기화
      _showIdError = false;
      _showPwError = false;
    });

    // 로딩 상태 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('로그인 중...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('잠시만 기다려주세요...'),
          ],
        ),
      ),
    );

    try {
      // 서버에 로그인 요청 전송
      dev.log('로그인 시도: ${_idController.text}');
      final response = await AuthService.login(
        email: _idController.text,
        password: _pwController.text,
      );

      // 로딩 대화상자 닫기
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      _log('로그인 성공!');

      // 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      // 로딩 대화상자 닫기
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      dev.log('로그인 오류 상세: $error');
      
      // 에러 메시지 처리 및 표시
      String errorMessage = '아이디 또는 비밀번호가 틀렸습니다.';
      
      if (error.toString().contains('가입되지 않은 아이디')) {
        errorMessage = '가입되지 않은 아이디입니다.';
      } else if (error.toString().contains('비밀번호가 일치하지 않')) {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      } else if (error.toString().contains('서버 연결 오류')) {
        errorMessage = '서버 연결에 실패했습니다. 인터넷 연결을 확인해주세요.';
      }
      
      _log('로그인 실패: $errorMessage');
      setState(() {
        _showIdError = true;
        _showPwError = true;
      });

      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 카카오 로그인 처리 함수
  Future<void> _handleKakaoLogin() async {
    // 로딩 대화상자 표시 전 웹 환경 감지 확인
    _isWeb = identical(0, 0.0);
    dev.log('카카오 로그인 시작 - 웹 환경여부: $_isWeb');

    // 로딩 상태 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카카오 로그인 중...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('로그인 처리중입니다.'),
            ],
          ),
        );
      },
    );

    try {
      // 웹 환경에서 카카오 로그인 처리
      if (_isWeb) {
        dev.log('웹 환경에서 카카오 로그인 시도');
        try {
          // 웹 환경 감지 및 설정 확인
          dev.log('웹 환경 설정 확인 - 리디렉션 URI가 올바르게 설정되어 있는지 확인하세요');
          
          // 웹 환경에서는 리디렉션 모드가 더 안정적
          bool isPopupMode = false;
          
          try {
            if (isPopupMode) {
              // 팝업 모드 - 일부 브라우저에서 차단될 수 있음
              dev.log('팝업 모드로 카카오 로그인 시도');
              await UserApi.instance.loginWithKakaoAccount();
            } else {
              // 리디렉션 모드 - 웹에서 권장되는 방식
              dev.log('리디렉션 모드로 카카오 로그인 시도');
              await UserApi.instance.loginWithKakaoAccount(
                prompts: [Prompt.login],
              );
            }
            
            // 로그인 성공 후 사용자 정보 요청
            dev.log('카카오 계정 로그인 성공, 사용자 정보 요청');
            final user = await UserApi.instance.me();
            
            dev.log('카카오 로그인 성공: ${user.id}');
            dev.log('사용자 정보: ${user.kakaoAccount?.profile?.nickname}, ${user.kakaoAccount?.email}');
            
            // 사용자 정보 상세 로깅
            if (user.kakaoAccount != null) {
              dev.log('이메일: ${user.kakaoAccount?.email ?? "없음"}');
              dev.log('이메일 인증됨: ${user.kakaoAccount?.isEmailVerified ?? false}');
              dev.log('닉네임: ${user.kakaoAccount?.profile?.nickname ?? "없음"}');
            }

            // 서버로 카카오 로그인 정보 전송
            dev.log('서버에 카카오 로그인 정보 전송');
            final response = await AuthService.loginWithKakao(user);
            dev.log('서버 응답: $response');

            // 로그인 성공
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop(); // 로딩 대화상자 닫기
            }
            
            dev.log('홈 화면으로 이동');
            Navigator.pushReplacementNamed(context, '/home');
          } catch (sdkError) {
            dev.log('카카오 SDK 오류: $sdkError');
            throw Exception('카카오 SDK 오류: $sdkError');
          }
        } catch (error) {
          dev.log('카카오 로그인 오류(WEB): $error');
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }

          // 오류 메시지 개선
          String errorMessage = '카카오 로그인 중 오류가 발생했습니다';
          if (error.toString().contains('cancelled')) {
            errorMessage = '로그인이 취소되었습니다';
          } else if (error.toString().contains('network')) {
            errorMessage = '네트워크 연결을 확인해주세요';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      // 모바일 환경에서 카카오 로그인 처리
      else {
        dev.log('모바일 환경에서 카카오 로그인 시도');
        try {
          // 카카오톡 어플리케이션 설치 여부 확인
          bool isKakaoInstalled = await isKakaoTalkInstalled();
          dev.log('카카오톡 앱 설치 여부: $isKakaoInstalled');

          // 카카오톡 어플리케이션 설치 여부에 따라 분기 처리
          if (isKakaoInstalled) {
            dev.log('카카오톡 앱으로 로그인 시도');
            await UserApi.instance.loginWithKakaoTalk();
          } else {
            dev.log('카카오 계정으로 로그인 시도');
            await UserApi.instance.loginWithKakaoAccount(
              prompts: [Prompt.login],
            );
          }

          // 카카오 사용자 정보 요청
          dev.log('카카오 사용자 정보 요청');
          final user = await UserApi.instance.me();
          dev.log('카카오 로그인 성공: ${user.id}');
          
          // 사용자 정보 상세 로깅
          if (user.kakaoAccount != null) {
            dev.log('이메일: ${user.kakaoAccount?.email ?? "없음"}');
            dev.log('이메일 인증됨: ${user.kakaoAccount?.isEmailVerified ?? false}');
            dev.log('닉네임: ${user.kakaoAccount?.profile?.nickname ?? "없음"}');
          }

          // 서버로 카카오 로그인 정보 전송
          dev.log('서버에 카카오 로그인 정보 전송');
          final response = await AuthService.loginWithKakao(user);
          dev.log('서버 응답: $response');

          // 토큰 저장 - 개선된 AuthToken 클래스 사용
          if (response.containsKey('token')) {
            dev.log('토큰 저장: ${response['token']}');
            AuthToken().accessToken = response['token'];
          } else {
            dev.log('응답에 토큰이 없음: $response');
          }

          // 사용자 정보 조회 및 저장
          dev.log('사용자 정보 조회');
          final userInfo = await AuthService.getUserInfo();
          dev.log('사용자 정보: $userInfo');
          AuthToken().userId = userInfo['id'];

          // 로그인 성공
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }
          
          dev.log('홈 화면으로 이동');
          Navigator.pushReplacementNamed(context, '/home');
        } catch (error) {
          dev.log('카카오 로그인 오류(Mobile): $error');
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }

          // 오류 메시지 개선
          String errorMessage = '카카오 로그인 중 오류가 발생했습니다';
          if (error.toString().contains('cancelled') || error.toString().contains('취소')) {
            errorMessage = '로그인이 취소되었습니다';
          } else if (error.toString().contains('network') || error.toString().contains('네트워크')) {
            errorMessage = '네트워크 연결을 확인해주세요';
          } else if (error.toString().contains('token') || error.toString().contains('토큰')) {
            errorMessage = '인증 정보를 처리하는 중 오류가 발생했습니다';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // 기타 예외 처리
      dev.log('카카오 로그인 중 예외 발생: $e');
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(); // 로딩 대화상자 닫기
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('카카오 로그인 오류: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    double scaleW(double x) => x * w / 375;
    double scaleH(double y) => y * h / 812;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 앱 이름
          Positioned(
            left: scaleW(125),
            top: scaleH(82),
            width: scaleW(150),
            height: scaleH(30),
            child: const Text(
              '혼자여도 함께인 식탁',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.85,
                color: Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 아이디 라벨
          Positioned(
            left: scaleW(22),
            top: scaleH(249),
            child: const Text(
              '아이디',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.65,
                color: Color(0xFF000000),
              ),
            ),
          ),

          // 아이디 입력 필드
          Positioned(
            left: scaleW(22),
            top: scaleH(277),
            child: SizedBox(
              width: scaleW(346),
              height: scaleH(42),
              child: TextField(
                controller: _idController,
                focusNode: _idFocus,
                cursorColor:
                    _showIdError
                        ? const Color(0xFFDE4242)
                        : const Color(0xFF657AE3),
                style: const TextStyle(fontSize: 12),
                onChanged: (text) {
                  _checkFields(); // 원래 로직 유지
                  setState(() {
                    _showIdError = false; // 입력 중에는 에러 숨기기
                  });
                },
                decoration: InputDecoration(
                  hintText: _idFocus.hasFocus ? null : '아이디를 입력해 주세요.',
                  hintStyle: const TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                    color: Color(0xFF929292),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon:
                      _showIdError
                          ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset(
                              'assets/images/error_icon.png',
                              width: 18,
                              height: 18,
                            ),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _showIdError
                              ? const Color(0xFFDE4242)
                              : const Color(0xFF929292),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _showIdError
                              ? const Color(0xFFDE4242)
                              : const Color(0xFF929292),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 아이디 에러 메시지
          if (_showIdError)
            Positioned(
              left: scaleW(24),
              top: scaleH(323),
              child: const Text(
                '아이디 또는 비밀번호가 틀렸습니다.',
                style: TextStyle(color: Color(0xFFDE4242), fontSize: 10),
              ),
            ),

          // 비밀번호 라벨
          Positioned(
            left: scaleW(22),
            top: scaleH(333),
            child: const Text(
              '비밀번호',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.65,
                color: Color(0xFF000000),
              ),
            ),
          ),

          // 비밀번호 입력 필드
          Positioned(
            left: scaleW(22),
            top: scaleH(361),
            child: SizedBox(
              width: scaleW(346),
              height: scaleH(42),
              child: TextField(
                controller: _pwController,
                focusNode: _pwFocus,
                obscureText: true,
                cursorColor:
                    _showPwError
                        ? const Color(0xFFDE4242)
                        : const Color(0xFF657AE3),
                style: const TextStyle(fontSize: 12),
                onChanged: (text) {
                  _checkFields(); // 원래 로직 유지
                  setState(() {
                    _showPwError = false; // 입력 중에는 에러 숨기기
                  });
                },
                decoration: InputDecoration(
                  hintText: _pwFocus.hasFocus ? null : '비밀번호(특수문자 포함 8자 이상)',
                  hintStyle: const TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                    color: Color(0xFF929292),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon:
                      _showPwError
                          ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset(
                              'assets/images/error_icon.png',
                              width: 18,
                              height: 18,
                            ),
                          )
                          : (_pwFocus.hasFocus
                              ? Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Image.asset(
                                  'assets/images/NoPreview1.png',
                                  width: 20,
                                  height: 20,
                                ),
                              )
                              : null),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _showPwError
                              ? const Color(0xFFDE4242)
                              : const Color(0xFF929292),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _showPwError
                              ? const Color(0xFFDE4242)
                              : const Color(0xFF929292),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 비밀번호 에러 메시지
          if (_showPwError)
            Positioned(
              left: scaleW(24),
              top: scaleH(407),
              child: const Text(
                '아이디 또는 비밀번호가 틀렸습니다.',
                style: TextStyle(color: Color(0xFFDE4242), fontSize: 10),
              ),
            ),

          // 아이디/비밀번호 찾기 버튼
          Positioned(
            left: scaleW(131),
            top: scaleH(_showPwError ? 432 : 412),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '아이디 찾기',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B)),
                  ),
                ),
                const Text(' | ', style: TextStyle(color: Color(0xFFD9D9D9))),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B)),
                  ),
                ),
              ],
            ),
          ),

          // 로그인 버튼
          Positioned(
            left: scaleW(22),
            top: scaleH(462),
            child: InkWell(
              onTap: _isButtonEnabled ? _handleLogin : null,
              child: Image.asset(
                _isButtonEnabled
                    ? 'assets/images/Group245.png'
                    : 'assets/images/Group223.png',
                width: scaleW(346),
                height: scaleH(53),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 카카오 로그인 버튼
          Positioned(
            left: scaleW(24),
            top: scaleH(631),
            child: InkWell(
              onTap: _handleKakaoLogin,
              child: Image.asset(
                'assets/images/kakao-icon.png',
                width: scaleW(342),
                height: scaleH(70),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 회원가입 버튼
          Positioned(
            left: scaleW(24),
            top: scaleH(721),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: Image.asset(
                'assets/images/button1.png',
                width: scaleW(342),
                height: scaleH(40),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
