import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  final String name;

  const ChatRoomScreen({super.key, required this.name});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _canSend = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ 상단 바
          Container(
            height: 100,
            color: const Color(0xFFE9ECFB),
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/chatroom/btn_back.png', width: 36),
                    ),
                    const Spacer(),
                    Image.asset('assets/images/chatroom/btn_menu.png', width: 24),
                  ],
                ),
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // ✅ 게시글 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset('assets/images/chatroom/avatar_default.png', width: 40),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '나눔 바나나 가져가실 분?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 0),
                      Row(
                        children: [
                          Image.asset('assets/images/chatroom/icon_calendar.png', width: 50, height: 50),
                          const SizedBox(width: 4),
                          Image.asset('assets/images/chatroom/icon_location.png', width: 50, height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Image.asset('assets/images/chatroom/divider_date.png', width: 200),
          const SizedBox(height: 8),

          // ✅ 메시지 목록
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // 왼쪽 메시지 (상대방)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/chatroom/avatar_default.png'),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('나눔 해주셔서 감사합니다!!'),
                    ),
                    const SizedBox(width: 6),
                    const Text('오후 2:17', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 12),

                // 오른쪽 메시지 (내 메시지)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('오후 2:18', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('아닙니다 ㅎㅎ.', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ 입력창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메시지 보내기',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // 전송 버튼 클릭 시 동작
                    if (_canSend) {
                      // 메시지 전송 로직 넣을 수 있음
                      _controller.clear();
                    }
                  },
                  child: Image.asset(
                    _canSend
                        ? 'assets/images/chatroom/btn_send_enabled.png'
                        : 'assets/images/chatroom/btn_send_disabled.png',
                    width: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
