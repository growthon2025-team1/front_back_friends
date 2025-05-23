import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            left: scaleW(22),
            top: scaleH(82),
            child: SizedBox(
              width: scaleW(300),
              height: scaleH(70),
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

          Positioned(
            left: scaleW(298),
            top: scaleH(57),
            width: scaleW(24),
            height: scaleH(24),
            child: Image.asset('assets/images/heart.png'),
          ),

          Positioned(
            left: scaleW(342),
            top: scaleH(56),
            width: scaleW(26),
            height: scaleH(26),
            child: Image.asset('assets/images/Bell.png'),
          ),

          Positioned(
            left: scaleW(22),
            top: scaleH(169),
            width: scaleW(346),
            height: scaleH(151),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/home'),
              child: Image.asset('assets/images/Frame1.png', fit: BoxFit.contain),
            ),
          ),

          Positioned(
            left: scaleW(22),
            top: scaleH(335),
            width: scaleW(346),
            height: scaleH(46),
            child: Image.asset('assets/images/CTA1.png', fit: BoxFit.contain),
          ),

          Positioned(
            left: scaleW(-3),
            top: scaleH(407),
            width: scaleW(397),
            height: scaleH(8),
            child: Image.asset('assets/images/Rectangle344.png', fit: BoxFit.cover),
          ),

          Positioned(
            left: scaleW(22),
            top: scaleH(435),
            width: scaleW(88),
            height: scaleH(20),
            child: const Text(
              '혼자보다는 함께',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF657AE3),
              ),
            ),
          ),

          Positioned(
            left: scaleW(23),
            top: scaleH(450),
            width: scaleW(130),
            height: scaleH(30),
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

          Positioned(
            left: scaleW(331),
            top: scaleH(453),
            width: scaleW(40),
            height: scaleH(30),
            child: const Text(
              '전체보기',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),

          Positioned(
            left: scaleW(22),
            top: scaleH(494),
            width: scaleW(163),
            height: scaleH(198),
            child: Image.asset('assets/images/Frame2.png'),
          ),
          Positioned(
            left: scaleW(205),
            top: scaleH(494),
            width: scaleW(163),
            height: scaleH(198),
            child: Image.asset('assets/images/Frame3.png'),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            width: w,
            height: scaleH(83),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: scaleW(36)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/home.png',
                        width: scaleW(24),
                        height: scaleH(24),
                      ),
                      SizedBox(height: scaleH(4)),
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
                          width: scaleW(24),
                          height: scaleH(24),
                        ),
                        SizedBox(height: scaleH(4)),
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
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/chat.png',
                          width: scaleW(24),
                          height: scaleH(24),
                        ),
                        SizedBox(height: scaleH(4)),
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
                          width: scaleW(24),
                          height: scaleH(24),
                        ),
                        SizedBox(height: scaleH(4)),
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
