import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import 'dart:developer' as dev;

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
      
      _log('로그인 실패: $error');
      
      // 오류가 발생하면 홈으로 이동하지 않고 에러 메시지만 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: 아이디와 비밀번호를 확인하세요'),
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
              Text('로그인 처리중입니다.')
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
          // 브라우저 환경에서 카카오로그인 방식 변경
          bool isPopupMode = false; // true면 팝업, false면 리다이렉트
          
          if (isPopupMode) {
            await UserApi.instance.loginWithKakaoAccount();
          } else {
            // 리다이렉트 모드 사용 - 이 방식이 웹에서 더 안정적
            await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
          }
          
          final user = await UserApi.instance.me();
          
          dev.log('카카오 로그인 성공: ${user.id}');
          dev.log('사용자 정보: ${user.kakaoAccount?.profile?.nickname}, ${user.kakaoAccount?.email}');
          
          // 서버로 카카오 로그인 정보 전송
          final response = await AuthService.loginWithKakao(user);
          
          // 로그인 성공
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }
          Navigator.pushReplacementNamed(context, '/home');
        } catch (error) {
          dev.log('카카오 로그인 오류(WEB): $error');
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('카카오 로그인 오류: $error'),
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
          
          // 카카오톡 어플리케이션 설치 여부에 따라 분기 처리
          if (isKakaoInstalled) {
            await UserApi.instance.loginWithKakaoTalk();
          } else {
            await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
          }
          
          // 카카오 사용자 정보 요청
          final user = await UserApi.instance.me();
          dev.log('카카오 로그인 성공: ${user.id}');
          
          // 서버로 카카오 로그인 정보 전송
          final response = await AuthService.loginWithKakao(user);
          
          // 로그인 성공
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }
          Navigator.pushReplacementNamed(context, '/home');
        } catch (error) {
          dev.log('카카오 로그인 오류(Mobile): $error');
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // 로딩 대화상자 닫기
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('카카오 로그인 오류: $error'),
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

  // 원래 로직 보존
  bool isValid = _isButtonEnabled;

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
              cursorColor: _showIdError ? const Color(0xFFDE4242) : const Color(0xFF657AE3),
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
                suffixIcon: _showIdError
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.asset(
                          'assets/images/error_icon.png',
                          width: 18,
                          height: 18,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _showIdError ? const Color(0xFFDE4242) : const Color(0xFF929292),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _showIdError ? const Color(0xFFDE4242) : const Color(0xFF929292),
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
              cursorColor: _showPwError ? const Color(0xFFDE4242) : const Color(0xFF657AE3),
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
                suffixIcon: _showPwError
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _showPwError ? const Color(0xFFDE4242) : const Color(0xFF929292),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _showPwError ? const Color(0xFFDE4242) : const Color(0xFF929292),
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
          child: GestureDetector(
            onTap: _isButtonEnabled ? _handleLogin : null,
            child: Image.asset(
              isValid ? 'assets/images/Group245.png' : 'assets/images/Group223.png',
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
          child: GestureDetector(
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
          child: GestureDetector(
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
