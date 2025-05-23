import 'package:flutter/material.dart';
import '../services/chat_socket_service.dart';
import '../utils/auth_token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;
  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    final myUserId = AuthToken().userId;
    print('✅ 현재 로그인한 사용자 ID: $myUserId');

    _controller.addListener(() {
      setState(() {
        _canSend = _controller.text.trim().isNotEmpty;
      });
    });
    fetchOldMessages();
    ChatSocketService.connect(
      chatRoomId: widget.chatRoomId,
      onMessageReceived: (msg) {
        setState(() {
          messages.add(msg);
          print('📩 새 메시지 도착: ${msg['content']} / 보낸 사람: ${msg['senderId']}');
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      },
    );
  }

  Future<void> fetchOldMessages() async {
    final token = AuthToken().accessToken;
    final url = Uri.parse(
      'http://34.64.149.252:8080/api/chatrooms/${widget.chatRoomId}/messages',
    );
    final response = await http.get(url, headers: {'Authorization': '$token'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        messages = data.cast<Map<String, dynamic>>();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } else {
      print('❌ 과거 메시지 로드 실패: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    ChatSocketService.disconnect();
    super.dispose();
  }

  void _handleSend() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    ChatSocketService.sendMessage(
      chatRoomId: widget.chatRoomId,
      content: content,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
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
                child: Image.asset(
                  'assets/images/chatroom/btn_back.png',
                  width: 36,
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/chatroom/btn_menu.png', width: 24),
            ],
          ),
          const Text(
            '채팅방',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final myUserId = AuthToken().userId;

    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final senderId = msg['senderId'];
        final isMine = senderId == myUserId;
        return Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMine) ...[
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(
                  'assets/images/chatroom/avatar_default.png',
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? Colors.deepPurple : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                msg['content'] ?? '',
                style: TextStyle(color: isMine ? Colors.white : Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
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
            onTap: _canSend ? _handleSend : null,
            child: Image.asset(
              _canSend
                  ? 'assets/images/chatroom/btn_send_enabled.png'
                  : 'assets/images/chatroom/btn_send_disabled.png',
              width: 32,
            ),
          ),
        ],
      ),
    );
  }
}
