import 'package:flutter/material.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/registered.dart';
import 'screens/home.dart';
import 'screens/RegisterFoodScreen.dart';
import 'screens/RegisterDetailScreen.dart';
import 'screens/RegisterCategoryScreen.dart';
import 'screens/RegisterDetailScreen2.dart';
import 'screens/chat_list_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: '5ba08a3f7dfc40d9faf0daa0b9053d5a',
    javaScriptAppKey: 'a7e4980f47456ce077cd8f7945702814',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모두의 냉장고',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignupStartScreen(),
        '/registered': (context) => SignupCompleteScreen(),
        '/home': (context) => HomeScreen(),
        '/chatlist': (context) => const ChatListScreen(), // ✅ 목록만 유지
        // '/chatroom': 제거됨, 파라미터 전달이 필요하므로 push에서 직접 처리
        '/registerFood': (context) => const RegisterFoodScreen(),
        '/registerDetail': (context) => const RegisterDetailScreen(),
        '/registerDetail2': (context) => const RegisterDetailScreen2(),
        '/registerCategory': (context) => const RegisterCategoryScreen(),
      },
    );
  }
}

