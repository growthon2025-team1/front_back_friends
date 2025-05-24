import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, String>> chatData = [
    {
      'avatar': 'avatar_apple.png',
      'name': '수민',
      'message': '몇시가 편하실까요?!',
      'time': '오후 14:21',
    },
    {
      'avatar': 'avatar_apple.png',
      'name': '지현',
      'message': '나눔 감사합니다 :) 잘 먹을게요!',
      'time': '오후 12:33',
    },
    {
      'avatar': 'avatar_apple.png',
      'name': '하린',
      'message': '서로 필요한 거 가져가서 좋네요 ㅎㅎ 학교에서 봬요!',
      'time': '6월 27일',
    },
  ];

  final List<String> categories = ['전체', '교환', '나눔', '예약 카드'];
  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 바
          Container(
            height: 100,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/chatlist/btn_back.png', width: 36),
                    ),
                    const Spacer(),
                    Image.asset('assets/images/chatlist/btn_menu.png', width: 24),
                  ],
                ),
                const Text(
                  '채팅',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 카테고리 필터
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => selectedCategory = category);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF5D5FEF) : Colors.white,
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey.shade400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 채팅 리스트
          Expanded(
            child: ListView.builder(
              itemCount: chatData.length,
              itemBuilder: (context, index) {
                final chat = chatData[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.asset(
                      'assets/images/chatlist/${chat['avatar']}',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(chat['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    chat['message']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(chat['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(name: chat['name']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
