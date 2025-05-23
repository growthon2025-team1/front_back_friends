import 'package:flutter/material.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/registered.dart';
import 'screens/home.dart';
import 'screens/map.dart';
<<<<<<< HEAD
import 'screens/chat_list.dart';
import 'screens/chat_room.dart';
=======
import 'screens/chat.dart';
import 'screens/mypage.dart';
import 'screens/RegisterFoodScreen.dart';
import 'screens/RegisterDetailScreen.dart';
import 'screens/RegisterCategoryScreen.dart';
import 'screens/RegisterDetailScreen2.dart';
>>>>>>> 08f96f9d67ebaaf61da8d317e3e69b94a38aa9d2
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'utils/auth_token.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: '5ba08a3f7dfc40d9faf0daa0b9053d5a',
    javaScriptAppKey: 'a7e4980f47456ce077cd8f7945702814',
  );
  AuthToken().accessToken = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모두의 냉장고',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignupStartScreen(),
        '/registered': (context) => SignupCompleteScreen(),
        '/home': (context) => HomeScreen(),
        '/map': (context) => MapScreen(),
<<<<<<< HEAD
        '/chat': (context) => ChatListScreen(),
=======
        '/mypage': (context) => MyPageScreen(),
        '/chat': (context) => ChatScreen(),
        '/registerFood': (context) => const RegisterFoodScreen(),
        '/registerDetail': (context) => const RegisterDetailScreen(),
        '/registerDetail2': (context) => const RegisterDetailScreen2(),
        '/registerCategory': (context) => const RegisterCategoryScreen(),
>>>>>>> 08f96f9d67ebaaf61da8d317e3e69b94a38aa9d2
      },
    );
  }
}
