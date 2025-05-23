import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 여기에 마이페이지 내용 추가
          const Center(child: Text('마이페이지 내용')),

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
                    iconPath: 'assets/images/home.png',
                    label: '홈',
                    onTap: () {
                      print('홈 버튼 클릭됨');
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                  _buildTabButton(
                    context,
                    iconPath: 'assets/images/map.png',
                    label: '지도',
                    onTap: () {
                      print('맵 버튼 클릭됨');
                      Navigator.of(context).pushNamed('/map');
                    },
                  ),
                  _buildTabButton(
                    context,
                    iconPath: 'assets/images/chat.png',
                    label: '채팅',
                    onTap: () {
                      print('채팅 버튼 클릭됨');
                      Navigator.of(context).pushNamed('/chat');
                    },
                  ),
                  _buildTabButton(
                    context,
                    iconPath: 'assets/images/myClicked.png',
                    label: '마이',
                    onTap: () {
                      print('마이 버튼 클릭됨');
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

  Widget _buildTabButton(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
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
              iconPath,
              width: scaleW(context, 24),
              height: scaleH(context, 24),
            ),
            SizedBox(height: scaleH(context, 4)),
            const Text(
              '',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w300,
                fontSize: 9,
                color: Color(0xFFB4B4B4),
                height: 1.22,
              ),
            ),
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

  double scaleW(BuildContext context, double size) =>
      MediaQuery.of(context).size.width / 375 * size;

  double scaleH(BuildContext context, double size) =>
      MediaQuery.of(context).size.height / 812 * size;
}
