import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // 반응형 사이즈 스케일 함수 정의
  double scaleW(BuildContext context, double size) {
    return MediaQuery.of(context).size.width / 375 * size;
  }

  double scaleH(BuildContext context, double size) {
    return MediaQuery.of(context).size.height / 812 * size;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('채팅 화면')),

          Positioned(
            left: 0,
            bottom: 0,
            width: w,
            height: scaleH(context, 83),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: scaleW(context, 36)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton(
                    context,
                    icon: 'assets/images/home.png',
                    label: '홈',
                    onTap: () {
                      print('홈 클릭');
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/map.png',
                    label: '지도',
                    onTap: () {
                      print('지도 클릭');
                      Navigator.of(context).pushNamed('/map');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/chatClicked.png',
                    label: '채팅',
                    onTap: () {
                      print('채팅 클릭');
                      Navigator.of(context).pushNamed('/chat');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/my.png',
                    label: '마이',
                    onTap: () {
                      print('마이 클릭');
                      Navigator.of(context).pushNamed('/mypage');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 하단 탭 버튼 위젯 함수
  Widget _buildTabButton(BuildContext context,
      {required String icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(scaleW(context, 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: scaleW(context, 24),
              height: scaleH(context, 24),
            ),
            SizedBox(height: scaleH(context, 4)),
            Text(
              label,
              style: const TextStyle(
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
    );
  }
}
