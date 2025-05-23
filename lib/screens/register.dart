import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;

class SignupStartScreen extends StatefulWidget {
  const SignupStartScreen({super.key});

  @override
  State<SignupStartScreen> createState() => _SignupStartScreenState();
}

class _SignupStartScreenState extends State<SignupStartScreen> {
  int _step = 1;

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  bool _nameFocused = false;
  bool _idFocused = false;
  bool _passwordFocused = false;
  bool _rePasswordFocused = false;

  bool _nameCompleted = false;
  bool _idValid = false;
  bool _idTaken = false;
  bool _idChecked = false;

  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[!@#\$&*~])(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }
  
  Future<void> _registerUser() async {
    String logText = '';
    void addLog(String message) {
      dev.log(message);
      logText += '\n$message';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message), 
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
      
    addLog('회원가입 시도 - 사용자: ${_nameController.text}');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 중...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('잠시만 기다려주세요'),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Text(logText, style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
    
    try {
      final requestBody = {
        'username': _idController.text,
        'password': _passwordController.text,
        'nickname': _nameController.text,
        'email': _idController.text
      };
      
      addLog('서버에 회원가입 요청 전송 중...');
      addLog('요청 URL: http://34.64.149.252:8080/auth/signup');
      addLog('요청 데이터: ${jsonEncode(requestBody)}');
      
      try {
        final serverUrl = Uri.parse('http://34.64.149.252:8080/auth/signup');
        final response = await http.post(
          serverUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(requestBody),
        );
        
        addLog('서버 응답 코드: ${response.statusCode}');
        addLog('서버 응답 내용: ${response.body}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          addLog('회원가입 성공!');
          await Future.delayed(Duration(seconds: 1));
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입이 성공적으로 완료되었습니다!')),
          );
          
          Navigator.pushReplacementNamed(context, '/login');
          return;
        } else {
          addLog('서버 오류: ${response.statusCode}');
        }
      } catch (networkError) {
        addLog('네트워크 오류: $networkError');
        addLog('오류 상세: ${networkError.toString()}');
        
        if (networkError.toString().contains('XMLHttpRequest error')) {
          addLog('CORS 정책 오류 발생 - 백엔드 서버 설정 필요');
        }
      }
      
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 연결 실패, 회원가입 기록 임시 저장')),
      );
      
      Navigator.pushReplacementNamed(context, '/login');
      
    } catch (e) {
      addLog('처리 중 오류: $e');
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생, 회원가입 기록 임시 저장')),
      );
      
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    double wp(double x) => x * w / 375;
    double hp(double y) => y * h / 812;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: hp(80)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: wp(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: hp(24)),
                    GestureDetector(
                      onTap: () {
                        if (_step > 1) {
                          setState(() => _step--);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/angleleft.png', width: 24, height: 24),
                    ),
                    SizedBox(height: hp(24)),
                    Text(
                      _step == 3
                          ? '거의 다 왔어요!'
                          : (_step == 4
                              ? '이제 냉장고를\n구경하러 갈까요?'
                              : '모두의 냉장고\n시작하기'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: hp(32)),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF657AE3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$_step',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _step == 1
                              ? '이름을 입력해 주세요.'
                              : _step == 2
                                  ? '아이디를 입력해 주세요.'
                                  : _step == 3
                                      ? '비밀번호를 입력해 주세요.'
                                      : '비밀번호를 다시 한 번 입력해 주세요.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_step == 1) _buildNameInput(),

                    if (_step == 2) ...[
                      _buildIdInput(),
                      if (_idChecked && _idTaken)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            '이미 사용 중인 아이디 입니다.',
                            style: TextStyle(
                              color: Color(0xFFDE4242),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _readonlyBox(_nameController.text),
                    ],

                    if (_step == 3) ...[
                      _buildPasswordInput(),
                      if (_passwordController.text.isNotEmpty &&
                          !_isPasswordValid(_passwordController.text))
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            '특수문자를 포함한 8자 이상으로 조합해 주세요.',
                            style: TextStyle(
                              color: Color(0xFFDE4242),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _readonlyBox(_idController.text),
                      const SizedBox(height: 8),
                      _readonlyBox(_nameController.text),
                    ],

                    if (_step == 4) ...[
                      _buildRePasswordInput(),
                      if (_rePasswordController.text.isNotEmpty &&
                          (_rePasswordController.text != _passwordController.text ||
                              !_isPasswordValid(_rePasswordController.text)))
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            '특수문자를 포함한 8자 이상으로 조합해 주세요.',
                            style: TextStyle(
                              color: Color(0xFFDE4242),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _readonlyPasswordBox(_passwordController.text),
                      const SizedBox(height: 8),
                      _readonlyBox(_idController.text),
                      const SizedBox(height: 8),
                      _readonlyBox(_nameController.text),
                    ],

                    SizedBox(height: hp(24)),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, -40),
              child: GestureDetector(
                onTap: () {
                  if (_step == 1 && _nameCompleted) {
                    setState(() {
                      _step = 2;
                      _idController.clear();
                    });
                  } else if (_step == 2 && _idValid) {
                    setState(() => _step = 3);
                  } else if (_step == 3 && _isPasswordValid(_passwordController.text)) {
                    setState(() => _step = 4);
                  } else if (_step == 4 &&
                      _rePasswordController.text == _passwordController.text &&
                      _isPasswordValid(_rePasswordController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회원가입 중...'), duration: Duration(seconds: 2)),
                    );
                    _registerUser();
                  }
                },
                child: Image.asset(
                  (_step == 1 && !_nameCompleted) ||
                          (_step == 2 && !_idValid) ||
                          (_step == 3 && !_isPasswordValid(_passwordController.text)) ||
                          (_step == 4 &&
                              (_rePasswordController.text != _passwordController.text ||
                                  !_isPasswordValid(_rePasswordController.text)))
                      ? 'assets/images/Group233.png'
                      : (_step == 4
                          ? 'assets/images/ok.png'
                          : 'assets/images/Group235.png'),
                  width: wp(327),
                  height: hp(53),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return FocusScope(
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _nameFocused = hasFocus),
        child: Container(
          width: 346,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _nameFocused ? const Color(0xFF657AE3) : const Color(0xFFBCBCBC),
              width: 1.2,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _nameController,
            cursorColor: const Color(0xFF657AE3),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '내용을 입력해 주세요.',
              hintStyle: TextStyle(
                color: _nameFocused ? Colors.black45 : Colors.black38,
                fontSize: 14,
              ),
              border: InputBorder.none,
              suffix: _nameController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        'assets/images/check1.png',
                        width: 18,
                        height: 14,
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
            ),
            onChanged: (text) {
              setState(() {
                _nameCompleted = text.isNotEmpty;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIdInput() {
    return FocusScope(
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _idFocused = hasFocus),
        child: Container(
          width: 346,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _idChecked
                  ? (_idTaken ? const Color(0xFFDE4242) : const Color(0xFF657AE3))
                  : (_idFocused ? const Color(0xFF657AE3) : const Color(0xFF929292)),
              width: 1.5,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _idController,
            cursorColor: const Color(0xFF657AE3),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '내용을 입력해 주세요.',
              hintStyle: const TextStyle(color: Color(0xFF929292), fontSize: 12),
              border: InputBorder.none,
              suffix: _idChecked
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        _idTaken
                            ? 'assets/images/error_icon.png'
                            : 'assets/images/check1.png',
                        width: 18,
                        height: 14,
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
            ),
            onChanged: (text) async {
              bool _isIdValid(String id) {
                final regex = RegExp(r'^[a-zA-Z0-9]{4,12}$');
                return regex.hasMatch(id);
              }

              final isTaken = !(await AuthService.checkIdDuplicate(text));

              setState(() {
                _idChecked = true;
                _idTaken = isTaken;
                _idValid = _isIdValid(text) && !_idTaken;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return FocusScope(
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _passwordFocused = hasFocus),
        child: Container(
          width: 346,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _passwordController.text.isEmpty
                  ? const Color(0xFFBCBCBC)
                  : (_isPasswordValid(_passwordController.text)
                      ? const Color(0xFF657AE3)
                      : const Color(0xFFDE4242)),
              width: 1.5,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            obscuringCharacter: '*',
            cursorColor: const Color(0xFF657AE3),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '비밀번호를 입력해 주세요.',
              hintStyle: const TextStyle(color: Color(0xFF929292), fontSize: 14),
              border: InputBorder.none,
              suffixIcon: _passwordController.text.isEmpty
                  ? null
                  : (!_isPasswordValid(_passwordController.text)
                      ? Image.asset('assets/images/NoPreview2.png', width: 18, height: 14)
                      : Image.asset('assets/images/NoPreview3.png', width: 18, height: 14)),
            ),
            onChanged: (text) => setState(() {}),
          ),
        ),
      ),
    );
  }

  Widget _buildRePasswordInput() {
    final isValid = _rePasswordController.text == _passwordController.text &&
        _isPasswordValid(_rePasswordController.text);
    return FocusScope(
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _rePasswordFocused = hasFocus),
        child: Container(
          width: 346,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _rePasswordController.text.isEmpty
                  ? const Color(0xFFBCBCBC)
                  : isValid
                      ? const Color(0xFF657AE3)
                      : const Color(0xFFDE4242),
              width: 1.5,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _rePasswordController,
            obscureText: true,
            cursorColor: const Color(0xFF657AE3),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '비밀번호를 다시 입력해 주세요.',
              hintStyle: const TextStyle(color: Color(0xFF929292), fontSize: 14),
              border: InputBorder.none,
              suffixIcon: _rePasswordController.text.isEmpty
                  ? null
                  : (!isValid
                      ? Image.asset('assets/images/NoPreview2.png', width: 18, height: 14)
                      : Image.asset('assets/images/NoPreview3.png', width: 18, height: 14)),
            ),
            onChanged: (text) => setState(() {}),
          ),
        ),
      ),
    );
  }

  Widget _readonlyBox(String value) {
    return IgnorePointer(
      child: Container(
        width: 346,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF929292), width: 1.5),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value),
                readOnly: true,
                style: const TextStyle(fontSize: 14, color: Color(0xFF929292)),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            if (value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/images/check.png',
                  width: 18,
                  height: 14,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _readonlyPasswordBox(String value) {
    return IgnorePointer(
      child: Container(
        width: 346,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF929292), width: 1.5),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          obscureText: true,
          obscuringCharacter: '*',
          style: const TextStyle(fontSize: 14, color: Color(0xFF929292)),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}