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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Text(
              '혼자여도 함께인 식탁',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFF232323),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              
              // 아이디 입력 섹션
              Text('아이디', 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF232323),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF929292)),
                ),
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력해 주세요.',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // 비밀번호 입력 섹션
              Text('비밀번호', 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF232323),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF929292)),
                ),
                child: TextField(
                  controller: _pwController,
                  obscureText: true, // 비밀번호 마스킹 처리
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해 주세요.(특수문자 포함 8자 이상)',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              // 아이디 비밀번호 찾기 버튼
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('아이디 찾기',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(10, 10)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('비밀번호 찾기',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(10, 10)),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _handleLogin : null,
                  child: Text('로그인 하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Color(0xFF657AE3) : Color(0xFFE4E4E4),
                    foregroundColor: _isButtonEnabled ? Colors.white : Color(0xFFBCBCBC),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // 카카오 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleKakaoLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('카카오로 시작하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // 회원가입 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFD9D9D9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('회원가입 시작하기', 
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
