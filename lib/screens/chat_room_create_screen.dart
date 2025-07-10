import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/chat_room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomCreateScreen extends ConsumerWidget {
  final int userId;
  final String nickname;

  const ChatRoomCreateScreen({
    super.key,
    required this.userId,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final TextEditingController chatController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(nickname),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
            ref.refresh(getChatRoomProvider(1));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // <-- 가상 키보드 숨기기
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              decoration: InputDecoration(
                                hintText: '메시지 입력',
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFA48AFF),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFA48AFF),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFA48AFF),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () async {
                              final chatRoomResult = await ref
                                  .read(chatRoomProvider.notifier)
                                  .postChatRoom(userId);
                              if (chatRoomResult['result_code'] == 200) {
                                final chatRoomId = chatRoomResult['result_data']
                                    ['chat_room']['id'];
                                final result = await ref
                                    .read(chatRoomProvider.notifier)
                                    .postChatRoomDetailChat(
                                      chatRoomId,
                                      chatController.text,
                                    );
                                if (result['result_code'] == 200) {
                                  ref.refresh(
                                      getChatRoomDetailProvider(chatRoomId));
                                  ref.refresh(getChatRoomProvider(1));

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatRoomDetailScreen(
                                              chatRoomId: chatRoomId),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFA48AFF),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  '전송',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFA48AFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
