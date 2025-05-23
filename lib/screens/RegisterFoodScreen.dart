import 'package:flutter/material.dart';

class RegisterFoodScreen extends StatefulWidget {
  const RegisterFoodScreen({super.key});

  @override
  State<RegisterFoodScreen> createState() => _RegisterFoodScreenState();
}

class _RegisterFoodScreenState extends State<RegisterFoodScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    double scaleW(double x) => x * w / 375;
    double scaleH(double y) => y * h / 812;

    final List<String> labels = [
      '과일', '채소', '냉동식품',
      '라면', '식사', '유제품',
      '빵', '생수', '음료',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: scaleW(4),
            top: scaleH(42),
            width: scaleW(60),
            height: scaleH(50),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset('assets/images/angleleft.png'),
            ),
          ),
          Positioned(
            left: scaleW(158),
            top: scaleH(82),
            width: scaleW(80),
            height: scaleH(30),
            child: const Text(
              '카테고리',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            left: scaleW(65),
            top: scaleH(124),
            width: scaleW(300),
            height: scaleH(20),
            child: const Text(
              '냉장고에 등록할 음식의 종류를 선택해 주세요',
              style: TextStyle(
                fontFamily: 'Noto Sans KR',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
          Positioned(
            left: scaleW(22),
            top: scaleH(203),
            width: scaleW(330),
            height: scaleH(300),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: scaleH(12),
              crossAxisSpacing: scaleW(12),
              childAspectRatio: 108 / 74,
              children: List.generate(9, (index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: isSelected
                      ? Container(
                          width: scaleW(108),
                          height: scaleH(74),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                fontFamily: 'Noto Sans KR',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            Image.asset(
                              'assets/images/383.png',
                              width: scaleW(108),
                              height: scaleH(74),
                              fit: BoxFit.fill,
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  labels[index],
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans KR',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB4B4B4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              }),
            ),
          ),
          Positioned(
            left: scaleW(22),
            top: scaleH(550),
            width: scaleW(330),
            height: scaleH(53),
            child: GestureDetector(
              onTap: selectedIndex != -1
                  ? () => Navigator.pushNamed(context, '/registerDetail')
                  : null,
              child: Image.asset(
                selectedIndex != -1
                    ? 'assets/images/btn_22333.png'
                    : 'assets/images/btn_2233.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}