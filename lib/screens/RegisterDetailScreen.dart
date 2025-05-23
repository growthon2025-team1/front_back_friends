import 'package:flutter/material.dart';

class RegisterDetailScreen extends StatefulWidget {
  const RegisterDetailScreen({super.key});

  @override
  State<RegisterDetailScreen> createState() => _RegisterDetailScreenState();
}

class _RegisterDetailScreenState extends State<RegisterDetailScreen> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    double scaleW(double x) => x * w / 375;
    double scaleH(double y) => y * h / 812;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        fontFamily: 'Noto Sans KR',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB4B4B4),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: scaleW(12)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: scaleH(1150),
          child: Stack(
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
                left: scaleW(90.5),
                top: scaleH(82),
                width: scaleW(200),
                height: scaleH(30),
                child: const Text(
                  '이건 꼭 알아야 해요',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: scaleW(40.5),
                top: scaleH(124),
                width: scaleW(300),
                height: scaleH(47),
                child: const Text(
                  '나눔 혹은 교환 전에 상대방이 알아야 할\n중요한 정보를 알려주세요',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9E9E9E),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(203),
                width: scaleW(346),
                height: scaleH(159),
                child: GestureDetector(
                  onTap: () {
                    if (_isTapped) {
                      Navigator.pushNamed(context, '/registerCategory');
                    } else {
                      setState(() {
                        _isTapped = true;
                      });
                    }
                  },
                  child: Image.asset(
                    _isTapped
                        ? 'assets/images/Frame22.png'
                        : 'assets/images/Frame20.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(388),
                width: scaleW(200),
                height: scaleH(30),
                child: const Text('제목', style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(432),
                width: scaleW(346),
                height: scaleH(42),
                child: TextField(
                  readOnly: true,
                  decoration: inputDecoration.copyWith(hintText: '글 제목'),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(500),
                width: scaleW(200),
                height: scaleH(30),
                child: const Text('수량', style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(544),
                child: Row(
                  children: ['1개', '2개', '3개', '직접 입력'].map((label) {
                    return Padding(
                      padding: EdgeInsets.only(right: scaleW(8)),
                      child: Container(
                        width: scaleW(77),
                        height: scaleH(30),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFB4B4B4),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(600),
                width: scaleW(100),
                height: scaleH(30),
                child: const Text('방식', style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(644),
                child: Row(
                  children: ['나눔', '교환'].map((label) {
                    return Padding(
                      padding: EdgeInsets.only(right: scaleW(8)),
                      child: Container(
                        width: scaleW(77),
                        height: scaleH(30),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFB4B4B4),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(700),
                width: scaleW(200),
                height: scaleH(30),
                child: const Text('거래희망 장소', style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(744),
                width: scaleW(346),
                height: scaleH(42),
                child: TextField(
                  readOnly: true,
                  decoration: inputDecoration.copyWith(hintText: '위치 추가'),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(820),
                width: scaleW(80),
                height: scaleH(30),
                child: const Text(
                  '자세한 설명',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202020),
                  ),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(860),
                width: scaleW(346),
                height: scaleH(157),
                child: TextField(
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 14),
                  decoration: inputDecoration.copyWith(
                    hintText: '등록할 식품의 구매일자, 유통기한(완제품의 경우)을\n알려주시면 좋아요.',
                    hintStyle: const TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB4B4B4),
                      height: 1.4,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: scaleH(-140),
                      left: scaleW(12),
                      right: scaleW(12),
                      bottom: scaleH(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(1059),
                width: scaleW(346),
                height: scaleH(53),
                child: Image.asset('assets/images/okkk.png', fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}