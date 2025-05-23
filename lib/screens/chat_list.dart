import 'package:flutter/material.dart';
import 'chat_room.dart';
import '../services/chat_service.dart';
import '../utils/auth_token.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chatRooms = [];
  final List<String> categories = ['전체', '교환', '나눔', '예약카드'];
  String selectedCategory = '전체';

  double scaleW(BuildContext context, double size) {
    return MediaQuery.of(context).size.width / 375 * size;
  }

  double scaleH(BuildContext context, double size) {
    return MediaQuery.of(context).size.height / 812 * size;
  }

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    try {
      final rooms = await ChatService.fetchChatRooms();
      setState(() {
        chatRooms = rooms;
      });
    } catch (e) {
      print('❌ 채팅방 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // 상단 앱바
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/images/chatlist/btn_back.png',
                            width: 36,
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/images/chatlist/btn_menu.png',
                          width: 24,
                        ),
                      ],
                    ),
                    const Text(
                      '채팅',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 카테고리 버튼
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children:
                      categories.map((category) {
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            onPressed:
                                () =>
                                    setState(() => selectedCategory = category),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  isSelected
                                      ? const Color(0xFF5D5FEF)
                                      : Colors.white,
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              // 채팅 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final room = chatRooms[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const CircleAvatar(child: Text("👤")),
                      title: Text(
                        room['receiverName'] ?? '알 수 없음',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('채팅방 ID: ${room['id']}'),
                      trailing: Text(
                        room['createdAt'].toString().substring(0, 10),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatRoomScreen(
                                  chatRoomId: room['id'].toString(),
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 83),
            ],
          ),

          // 하단 탭바
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
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/map.png',
                    label: '지도',
                    onTap: () {
                      Navigator.of(context).pushNamed('/map');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/chatClicked.png',
                    label: '채팅',
                    onTap: () {
                      Navigator.of(context).pushNamed('/chat');
                    },
                  ),
                  _buildTabButton(
                    context,
                    icon: 'assets/images/my.png',
                    label: '마이',
                    onTap: () {
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
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
