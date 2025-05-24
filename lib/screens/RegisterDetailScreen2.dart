import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../services/post_service.dart';
import '../../utils/auth_token.dart';
import 'map_select_screen.dart';

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
  double? selectedLat;
  double? selectedLng;

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
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  Widget buildSelectableButton(
    String label,
    String selected,
    void Function(String) onSelect,
  ) {
    final isSelected = label == selected;
    return GestureDetector(
      onTap: () => setState(() => onSelect(label)),
      child: Container(
        width: 77,
        height: 30,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF657AE3) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFFB4B4B4),
          ),
        ),
      ),
    );
  }

  Future<void> _selectLocationFromMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapSelectScreen()),
    );

    if (result is Map<String, dynamic> &&
        result['lat'] != null &&
        result['lng'] != null &&
        result['address'] != null) {
      setState(() {
        selectedLat = result['lat'];
        selectedLng = result['lng'];
        _locationController.text = result['address'];
      });
    }
  }

  Future<void> _submitPost() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _locationController.text.isEmpty ||
        selectedAmount.isEmpty ||
        selectedLat == null ||
        selectedLng == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("모든 항목을 입력해주세요.")));
      return;
    }

    final auth = AuthToken();
    final token = auth.accessToken;
    final userId = auth.userId;

    if (token == null || userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("로그인이 필요합니다.")));
      return;
    }

    final postData = {
      "title": _titleController.text,
      "details": _descController.text,
      "location": _locationController.text,
      "lat": selectedLat ?? 0.0,
      "lng": selectedLng ?? 0.0,
      "category": "FRUIT",
      "quantity": int.tryParse(selectedAmount[0]) ?? 0,
      "imageUrl": null,
      "isClosed": false,
    };

    try {
      final result = await PostService.createPost(postData, token);
      print('✅ 등록 성공: $result');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('❌ 등록 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("게시글 등록 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                '이건 꼭 알아야 해요',
                style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/banana.png', width: 79, height: 79),
                const SizedBox(width: 8),
                Image.asset('assets/images/banana2.png', width: 79, height: 79),
                const SizedBox(width: 8),
                Image.asset('assets/images/plus.png', width: 79, height: 79),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '제목',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              focusNode: _titleFocus,
              controller: _titleController,
              decoration: customInputDecoration('글 제목', _titleFocus),
            ),
            const SizedBox(height: 20),
            const Text(
              '수량',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children:
                  ['1개', '2개', '3개'].map((label) {
                    return buildSelectableButton(
                      label,
                      selectedAmount,
                      (val) => selectedAmount = val,
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              '거래희망 장소',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectLocationFromMap,
              child: AbsorbPointer(
                child: TextField(
                  controller: _locationController,
                  decoration: customInputDecoration('위치 추가', _locationFocus),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '자세한 설명',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: TextField(
                focusNode: _descFocus,
                controller: _descController,
                maxLines: 8,
                expands: false,
                decoration: customInputDecoration(
                  '등록할 식품의 구매일자, 유통기한(완제품의 경우)을\n알려주시면 좋아요.',
                  _descFocus,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF657AE3),
                ),
                child: const Text(
                  '등록하기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
