import 'package:flutter/material.dart';

class RegisterDetailScreen2 extends StatefulWidget {
  const RegisterDetailScreen2({super.key});

  @override
  State<RegisterDetailScreen2> createState() => _RegisterDetailScreen2State();
}

class _RegisterDetailScreen2State extends State<RegisterDetailScreen2> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  String selectedAmount = '';
  String selectedType = '';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    _locationFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    double scaleW(double x) => x * w / 375;
    double scaleH(double y) => y * h / 812;

    InputDecoration customInputDecoration(String hintText, FocusNode node) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    hintStyle: const TextStyle(
      fontFamily: 'Noto Sans KR',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFFB4B4B4),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: node.hasFocus ? Colors.black : Color(0xFFD9D9D9),
        width: node.hasFocus ? 1 : 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: node.hasFocus ? Colors.black : Color(0xFFD9D9D9),
        width: node.hasFocus ? 1 : 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
    ),
  );
}

    Widget buildSelectableButton(String label, String selected, void Function(String) onSelect) {
      final isSelected = label == selected;
      return GestureDetector(
        onTap: () => setState(() => onSelect(label)),
        child: Container(
          width: scaleW(77),
          height: scaleH(30),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF657AE3) : const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFFB4B4B4),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: scaleH(1200),
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
                width: scaleW(79),
                height: scaleH(79),
                child: Image.asset('assets/images/banana.png'),
              ),
              Positioned(
                left: scaleW(114),
                top: scaleH(203),
                width: scaleW(79),
                height: scaleH(79),
                child: Image.asset('assets/images/banana2.png'),
              ),
              Positioned(
                left: scaleW(205),
                top: scaleH(203),
                width: scaleW(79),
                height: scaleH(79),
                child: Image.asset('assets/images/plus.png'),
              ),

              Positioned(
                left: scaleW(22),
                top: scaleH(308),
                child: const Text('제목',
                    style: TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020),
                    )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(352),
                width: scaleW(346),
                height: scaleH(42),
                child: TextField(
                  focusNode: _titleFocus,
                  controller: _titleController,
                  cursorColor: const Color(0xFF657AE3),
                  decoration: customInputDecoration('글 제목', _titleFocus),
                ),
              ),

              Positioned(
                left: scaleW(22),
                top: scaleH(420),
                child: const Text('수량',
                    style: TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020),
                    )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(464),
                child: Row(
                  children: ['1개', '2개', '3개', '직접 입력'].map((label) {
                    return Padding(
                      padding: EdgeInsets.only(right: scaleW(8)),
                      child: buildSelectableButton(label, selectedAmount, (val) => selectedAmount = val),
                    );
                  }).toList(),
                ),
              ),

              Positioned(
                left: scaleW(22),
                top: scaleH(520),
                child: const Text('방식',
                    style: TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020),
                    )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(564),
                child: Row(
                  children: ['나눔', '교환'].map((label) {
                    return Padding(
                      padding: EdgeInsets.only(right: scaleW(8)),
                      child: buildSelectableButton(label, selectedType, (val) => selectedType = val),
                    );
                  }).toList(),
                ),
              ),

              Positioned(
                left: scaleW(22),
                top: scaleH(620),
                child: const Text('거래희망 장소',
                    style: TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020),
                    )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(664),
                width: scaleW(346),
                height: scaleH(42),
                child: Stack(
                  children: [
                    TextField(
                      focusNode: _locationFocus,
                      controller: _locationController,
                      cursorColor: const Color(0xFF657AE3),
                      decoration: customInputDecoration('위치 추가', _locationFocus),
                    ),
                    if (!_locationFocus.hasFocus)
                      Positioned(
                        right: scaleW(12),
                        top: scaleH(13),
                        width: scaleW(8),
                        height: scaleH(16),
                        child: Image.asset('assets/images/Vector13.png'),
                      )
                  ],
                ),
              ),

              Positioned(
                left: scaleW(22),
                top: scaleH(750),
                child: const Text('자세한 설명',
                    style: TextStyle(
                      fontFamily: 'Noto Sans KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020),
                    )),
              ),
              Positioned(
                left: scaleW(22),
                top: scaleH(800),
                width: scaleW(346),
                height: scaleH(157),
                child: TextField(
                  focusNode: _descFocus,
                  controller: _descController,
                  cursorColor: const Color(0xFF657AE3),
                  maxLines: null,
                  expands: true,
                  decoration: customInputDecoration(
                    '등록할 식품의 구매일자, 유통기한(완제품의 경우)을\n알려주시면 좋아요.',
                    _descFocus,
                  ).copyWith(
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
                top: scaleH(1000),
                width: scaleW(346),
                height: scaleH(53),
                child: GestureDetector(
  onTap: () {
    if (_titleController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        selectedAmount.isNotEmpty &&
        selectedType.isNotEmpty) {
      print('모든 입력 완료됨');
    }
  },
  child: Image.asset(
    (_titleController.text.isNotEmpty &&
     _locationController.text.isNotEmpty &&
     _descController.text.isNotEmpty &&
     selectedAmount.isNotEmpty &&
     selectedType.isNotEmpty)
      ? 'assets/images/okok.png'
      : 'assets/images/okkk.png',
    fit: BoxFit.fill,
  ),
),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
