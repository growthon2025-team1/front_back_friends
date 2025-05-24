import 'package:flutter/material.dart';

class HomeOkScreen extends StatelessWidget {
  const HomeOkScreen({super.key});

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
          SingleChildScrollView(
            child: SizedBox(
              height: hp(1200),
              child: Stack(
                children: [
                  // 인사 텍스트
                  Positioned(
                    left: wp(22),
                    top: hp(100),
                    child: SizedBox(
                      width: wp(300),
                      height: hp(70),
                      child: const Text(
                        '안녕하세요, 마루님\n오늘의 냉장고에는 무엇이 있나요?',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // 하트 아이콘
                  Positioned(
                    left: wp(298),
                    top: hp(57),
                    width: wp(24),
                    height: hp(24),
                    child: Image.asset('assets/images/heart.png'),
                  ),

                  // 알림 아이콘
                  Positioned(
                    left: wp(342),
                    top: hp(56),
                    width: wp(26),
                    height: hp(26),
                    child: Image.asset('assets/images/Bell.png'),
                  ),

                  // 음식 아이콘들
                  Positioned(
                    left: wp(22),
                    top: hp(220),
                    width: wp(79),
                    height: hp(79),
                    child: Image.asset('assets/images/ramen1.png', fit: BoxFit.contain),
                  ),
                  Positioned(
                    left: wp(111),
                    top: hp(220),
                    width: wp(79),
                    height: hp(79),
                    child: Image.asset('assets/images/sweetpotato1.png', fit: BoxFit.contain),
                  ),
                  Positioned(
                    left: wp(200),
                    top: hp(220),
                    width: wp(79),
                    height: hp(79),
                    child: Image.asset('assets/images/water.png', fit: BoxFit.contain),
                  ),

                  Positioned(
                    left: wp(22),
                    top: hp(320),
                    width: wp(346),
                    height: hp(46),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/registerFood'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/CTA1.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  // 구분선
                  Positioned(
                    left: wp(-3),
                    top: hp(400),
                    width: wp(397),
                    height: hp(8),
                    child: Image.asset('assets/images/Rectangle344.png', fit: BoxFit.fill),
                  ),

                  // 텍스트: 정을 나누고 있는 냉장고
                  Positioned(
                    left: wp(22),
                    top: hp(430),
                    child: SizedBox(
                      width: wp(130),
                      height: hp(20),
                      child: const Text(
                        '정을 나누고 있는 냉장고',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xFF657AE3),
                        ),
                      ),
                    ),
                  ),

                  // 텍스트: 진행 중인 거래
                  Positioned(
                    left: wp(22),
                    top: hp(450),
                    child: SizedBox(
                      width: wp(120),
                      height: hp(30),
                      child: const Text(
                        '진행 중인 거래',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF202020),
                        ),
                      ),
                    ),
                  ),

                  // 텍스트: 전체보기
                  Positioned(
                    left: wp(320),
                    top: hp(470),
                    child: SizedBox(
                      width: wp(100),
                      height: hp(30),
                      child: const Text(
                        '전체보기',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                  ),

                  // Frame35.png
                  Positioned(
                    left: wp(22),
                    top: hp(500),
                    width: wp(163),
                    height: hp(208),
                    child: Image.asset('assets/images/Frame35.png', fit: BoxFit.cover),
                  ),

                  // Frame36.png
                  Positioned(
                    left: wp(197),
                    top: hp(500),
                    width: wp(163),
                    height: hp(208),
                    child: Image.asset('assets/images/Frame36.png', fit: BoxFit.cover),
                  ),

                  // Group285.png
                  Positioned(
                    left: wp(372),
                    top: hp(500),
                    width: wp(163),
                    height: hp(208),
                    child: Image.asset('assets/images/Group285.png', fit: BoxFit.cover),
                  ),

                  // Rectangle44.png (아래 구분선)
                  Positioned(
                    left: wp(-3),
                    top: hp(750),
                    width: wp(397),
                    height: hp(8),
                    child: Image.asset('assets/images/Rectangle44.png', fit: BoxFit.fill),
                  ),

                  // 텍스트: 혼자보다는 함께
                  Positioned(
                    left: wp(22),
                    top: hp(780),
                    child: SizedBox(
                      width: wp(100),
                      height: hp(20),
                      child: const Text(
                        '혼자보다는 함께',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xFF657AE3),
                        ),
                      ),
                    ),
                  ),

                  // 텍스트: 냉장고 나눔 후기
                  Positioned(
                    left: wp(22),
                    top: hp(800),
                    child: SizedBox(
                      width: wp(120),
                      height: hp(30),
                      child: const Text(
                        '냉장고 나눔 후기',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF202020),
                        ),
                      ),
                    ),
                  ),

                  // 텍스트: 전체보기 (후기 섹션)
                  Positioned(
                    left: wp(320),
                    top: hp(810),
                    child: SizedBox(
                      width: wp(50),
                      height: hp(30),
                      child: const Text(
                        '전체보기',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                  ),

                  // Frame2.png
                  Positioned(
                    left: wp(23),
                    top: hp(850),
                    width: wp(163),
                    height: hp(198),
                    child: Image.asset('assets/images/Frame2.png', fit: BoxFit.contain),
                  ),

                  // Frame3.png
                  Positioned(
                    left: wp(197),
                    top: hp(850),
                    width: wp(163),
                    height: hp(198),
                    child: Image.asset('assets/images/Frame3.png', fit: BoxFit.contain),
                  ),

                  // Group278.png
                  Positioned(
                    left: wp(371),
                    top: hp(850),
                    width: wp(163),
                    height: hp(198),
                    child: Image.asset('assets/images/Group278.png', fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),

          // 하단 네비게이션 바
          Positioned(
            left: 0,
            bottom: 0,
            width: w,
            height: hp(83),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: wp(36)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/home.png',
                        width: wp(24),
                        height: hp(24),
                      ),
                      SizedBox(height: hp(4)),
                      const Text(
                        '홈',
                        style: TextStyle(
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w300,
                          fontSize: 9,
                          color: Color(0xFFB4B4B4),
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/map'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/map.png',
                          width: wp(24),
                          height: hp(24),
                        ),
                        SizedBox(height: hp(4)),
                        const Text(
                          '지도',
                          style: TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            color: Color(0xFFB4B4B4),
                            height: 1.22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/chatlist'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/chat.png',
                          width: wp(24),
                          height: hp(24),
                        ),
                        SizedBox(height: hp(4)),
                        const Text(
                          '채팅',
                          style: TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            color: Color(0xFFB4B4B4),
                            height: 1.22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/mypage'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/my.png',
                          width: wp(24),
                          height: hp(24),
                        ),
                        SizedBox(height: hp(4)),
                        const Text(
                          '마이',
                          style: TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            color: Color(0xFFB4B4B4),
                            height: 1.22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
