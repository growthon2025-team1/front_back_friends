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
  bool _isWeb = false;

  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();

  bool _showIdError = false;
  bool _showPwError = false;

  bool _isPwVisible = false; // 👈 비밀번호 보기 여부

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
    setState(() {
      _isButtonEnabled = id.isNotEmpty && pw.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(_checkFields);
    _pwController.addListener(_checkFields);
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

  Future<void> _handleLogin() async {
    if (!_isButtonEnabled) return;
    setState(() => _isLoading = true);

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
      final response = await AuthService.login(
        email: _idController.text,
        password: _pwController.text,
      );

      if (Navigator.canPop(context)) Navigator.of(context).pop();
      _log('로그인 성공!');
      Navigator.pushReplacementNamed(context, '/home_ok');
    } catch (error) {
      if (Navigator.canPop(context)) Navigator.of(context).pop();
      _log('로그인 실패: $error');
      setState(() {
        _showIdError = true;
        _showPwError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: 아이디와 비밀번호를 확인하세요'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleKakaoLogin() async {
    _isWeb = identical(0, 0.0);
    dev.log('카카오 로그인 시작 - 웹 환경여부: $_isWeb');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('카카오 로그인 중...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('로그인 처리중입니다.'),
          ],
        ),
      ),
    );

    try {
      if (_isWeb) {
        try {
          await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
          final user = await UserApi.instance.me();
          final response = await AuthService.loginWithKakao(user);
          if (Navigator.canPop(context)) Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/home_ok');
        } catch (error) {
          dev.log('카카오 로그인 오류(WEB): $error');
          if (Navigator.canPop(context)) Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('카카오 로그인 오류: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        try {
          bool isKakaoInstalled = await isKakaoTalkInstalled();
          if (isKakaoInstalled) {
            await UserApi.instance.loginWithKakaoTalk();
          } else {
            await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
          }
          final user = await UserApi.instance.me();
          final response = await AuthService.loginWithKakao(user);
          if (Navigator.canPop(context)) Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/home_ok');
        } catch (error) {
          dev.log('카카오 로그인 오류(Mobile): $error');
          if (Navigator.canPop(context)) Navigator.of(context).pop();
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
      dev.log('카카오 로그인 중 예외 발생: $e');
      if (Navigator.canPop(context)) Navigator.of(context).pop();
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
      Positioned(
      left: scaleW(124),
      top: scaleH(125),
      width: scaleW(142),
      height: scaleH(95),
        child: Image.asset(
         'assets/images/Group330.png',
          fit: BoxFit.contain,
  ),
),

          Positioned(
            left: scaleW(22),
            top: scaleH(249),
            child: const Text(
              '아이디',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            left: scaleW(22),
            top: scaleH(277),
            child: SizedBox(
              width: scaleW(346),
              height: scaleH(42),
              child: TextField(
                controller: _idController,
                focusNode: _idFocus,
                cursorColor: _showIdError ? Color(0xFFDE4242) : Color(0xFF657AE3),
                style: TextStyle(fontSize: 12),
                onChanged: (_) {
                  _checkFields();
                  setState(() {
                    _showIdError = false;
                  });
                },
      decoration: InputDecoration(
  hintText: _idFocus.hasFocus ? null : '아이디를 입력해 주세요.',
  contentPadding: EdgeInsets.symmetric(horizontal: 16),
  suffixIcon: _showIdError
      ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/error_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        )
      : null,
         suffixIconConstraints: const BoxConstraints(
         minWidth: 30,
         minHeight: 30,
         maxWidth: 30,
         maxHeight: 30,
       ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
          color: _showIdError ? Color(0xFFDE4242) : Color(0xFF929292),
          width: 1.5,
          ),
        ),
       focusedBorder: OutlineInputBorder(
       borderRadius: BorderRadius.circular(8),
       borderSide: BorderSide(
           color: _showIdError ? Color(0xFFDE4242) : Color(0xFF929292),
           width: 1.5,
                         ),
                      ),
                   ),
                ),
              ),
            ),
          if (_showIdError)
            Positioned(
              left: scaleW(24),
              top: scaleH(323),
              child: const Text(
                '아이디 또는 비밀번호가 틀렸습니다.',
                style: TextStyle(color: Color(0xFFDE4242), fontSize: 10),
              ),
            ),
          Positioned(
            left: scaleW(22),
            top: scaleH(350),
            child: const Text(
              '비밀번호',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
         Positioned(
  left: scaleW(22),
  top: scaleH(380),
  child: SizedBox(
    width: scaleW(346),
    height: scaleH(42),
    child: TextField(
      controller: _pwController,
      focusNode: _pwFocus,
      obscureText: !_isPwVisible,
      cursorColor: _showPwError ? Color(0xFFDE4242) : Color(0xFF657AE3),
      style: TextStyle(fontSize: 12),
      onChanged: (_) {
        _checkFields();
        setState(() {
          _showPwError = false;
        });
      },
      decoration: InputDecoration(
        hintText: _pwFocus.hasFocus ? null : '비밀번호(특수문자 포함 8자 이상)',
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        suffixIcon: GestureDetector(
          onTapDown: (_) => setState(() => _isPwVisible = true),
          onTapUp: (_) => setState(() => _isPwVisible = false),
          onTapCancel: () => setState(() => _isPwVisible = false),
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                'assets/images/NoPreview1.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 30,
          maxHeight: 30,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _showPwError ? Color(0xFFDE4242) : Color(0xFF929292),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _showPwError ? Color(0xFFDE4242) : Color(0xFF929292),
            width: 1.5,
          ),
        ),
      ),
    ),
  ),
),

          if (_showPwError)
            Positioned(
              left: scaleW(24),
              top: scaleH(425),
              child: const Text(
                '아이디 또는 비밀번호가 틀렸습니다.',
                style: TextStyle(color: Color(0xFFDE4242), fontSize: 10),
              ),
            ),
          Positioned(
            left: scaleW(131),
            top: scaleH(_showPwError ? 455 : 425),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('아이디 찾기', style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B))),
                ),
                const Text(' | ', style: TextStyle(color: Color(0xFFD9D9D9))),
                TextButton(
                  onPressed: () {},
                  child: const Text('비밀번호 찾기', style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B))),
                ),
              ],
            ),
          ),
          Positioned(
            left: scaleW(22),
            top: scaleH(500),
            child: InkWell(
              onTap: _isButtonEnabled ? _handleLogin : null,
              child: Image.asset(
                _isButtonEnabled ? 'assets/images/Group245.png' : 'assets/images/Group223.png',
                width: scaleW(346),
                height: scaleH(53),
                fit: BoxFit.contain,
              ),
            ),
          ),
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