import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/chat_room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomData = ref.watch(getChatRoomProvider);

    void onChatRoomTap(int chatRoomId) {
      ref.refresh(getChatRoomDetailProvider(chatRoomId));

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatRoomDetailScreen(chatRoomId: chatRoomId),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('수업톡'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // <-- 가상 키보드 숨기기
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: chatRoomData.when(
                  data: (room) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: room['chat_rooms'].length,
                      itemBuilder: (context, index) {
                        if (room['chat_rooms'].isEmpty) {
                          return Container();
                        }

                        final roomData = room['chat_rooms'][index];
                        final lastChat = roomData['last_chat'];
                        final lastChatTime = roomData['last_chat_time'];

                        final roomNotificationData =
                            roomData['room_notification'];

                        int isCheck = 0;
                        if (roomNotificationData.isNotEmpty) {
                          isCheck = roomNotificationData[0]['status'];
                        }

                        final lessonData = roomData['lesson'];
                        final lessonImage = lessonData['image_url'];
                        final lessonTitle = lessonData['title'];

                        final dancerData = lessonData['dancer'];
                        final dancerEmail = dancerData['email'];
                        final dancerNickname = dancerData['nickname'];
                        final dancerImage = dancerData['image_url'];
                        return GestureDetector(
                          onTap: () {
                            onChatRoomTap(roomData['id']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: lessonImage == null
                                              ? Image.asset(
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  'assets/images/app_logo/chat.png',
                                                )
                                              : Image.network(
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  lessonImage,
                                                ),
                                        ),
                                        isCheck == 0
                                            ? Positioned(
                                                left: 5,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          lessonTitle,
                                          style: const TextStyle(
                                            color: Color(0xff3F51B5),
                                            fontSize: 17,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(lastChat),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(lastChatTime),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) {
                    return SizedBox(
                      width: 300,
                      child: Text('search error: $error'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
