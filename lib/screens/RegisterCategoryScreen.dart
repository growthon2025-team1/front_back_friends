import 'package:flutter/material.dart';

class RegisterCategoryScreen extends StatefulWidget {
  const RegisterCategoryScreen({super.key});

  @override
  State<RegisterCategoryScreen> createState() => _RegisterCategoryScreenState();
}

class _RegisterCategoryScreenState extends State<RegisterCategoryScreen> {
  bool isSelected1 = false;
  bool isSelected2 = false;

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
            left: scaleW(-1),
            top: scaleH(102),
            width: scaleW(391),
            height: scaleH(788),
            child: Image.asset('assets/images/Frame23.png', fit: BoxFit.fill),
          ),

          Positioned(
            left: scaleW(4),
            top: scaleH(42),
            width: scaleW(50),
            height: scaleH(50),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset('assets/images/angleleft.png'),
            ),
          ),

          Positioned(
            left: scaleW(145),
            top: scaleH(52),
            width: scaleW(100),
            height: scaleH(30),
            child: Image.asset('assets/images/Group287.png'),
          ),

          Positioned(
            left: scaleW(342),
            top: scaleH(52),
            width: scaleW(26),
            height: scaleH(36),
            child: GestureDetector(
              onTap: () {
                if (isSelected1 && isSelected2) {
                  Navigator.pushNamed(context, '/registerDetail2');
                }
              },
              child: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 29.7 / 14,
                  color: Color(0xFF202020),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ),
          ),

          Positioned(
            left: scaleW(230),
            top: scaleH(109),
            width: scaleW(50),
            height: scaleH(50),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected1 = !isSelected1;
                });
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: scaleW(50),
                    height: scaleH(50),
                  ),
                  if (isSelected1)
                    Positioned(
                      left: -1,
                      top: 0,
                      child: Image.asset(
                        'assets/images/Ellipse36.png',
                        width: scaleW(22),
                        height: scaleH(22),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Positioned(
            left: scaleW(363),
            top: scaleH(109),
            width: scaleW(50),
            height: scaleH(50),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected2 = !isSelected2;
                });
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: scaleW(50),
                    height: scaleH(50),
                  ),
                  if (isSelected2)
                    Positioned(
                      left: -1,
                      top: 0,
                      child: Image.asset(
                        'assets/images/Ellipse36.png',
                        width: scaleW(22),
                        height: scaleH(22),
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