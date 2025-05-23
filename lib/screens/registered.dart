import 'package:flutter/material.dart';

class SignupCompleteScreen extends StatelessWidget {
  const SignupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const figmaWidth = 375.0;
    const figmaHeight = 812.0;

    double wp(double x) => screenWidth * (x / figmaWidth);
    double hp(double y) => screenHeight * (y / figmaHeight);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          
          Positioned(
            top: hp(142),
            left: wp(43),
            width: wp(307),
            child: const Text(
              '작은 음식 하나,\n마음을 건네는 시작',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),

          
          Positioned(
            top: hp(258),
            left: wp(30),
            width: wp(325),
            height: hp(424),
            child: Image.asset(
              'assets/images/Asset20.png',
              fit: BoxFit.contain,
            ),
          ),

        
          Positioned(
            top: hp(708),
            left: wp(22),
            width: wp(346),
            height: hp(53),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Image.asset(
                'assets/images/Group2238.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
