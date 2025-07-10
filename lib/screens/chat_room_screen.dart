import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/chat_room_detail_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomData = ref.watch(getChatRoomProvider(1));

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
        automaticallyImplyLeading: true,
        title: const Text('DM'),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MainNavigationScreen(),
              ),
            );
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

                        final friendData = roomData['friend'];
                        final friendNickname = friendData['nickname'];
                        final friendImageUrl = friendData['image_url'];

                        int isCheck = 0;
                        if (roomNotificationData.isNotEmpty) {
                          isCheck = roomNotificationData[0]['status'];
                        }

                        return GestureDetector(
                          onTap: () {
                            print(roomData['id']);
                            onChatRoomTap(roomData['id']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child:
                                                friendImageUrl.split(':')[0] ==
                                                        'https'
                                                    ? Image.network(
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        friendImageUrl,
                                                      )
                                                    : Image.asset(
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        'assets/images/app_logo/chat.png',
                                                      ),
                                          ),
                                          isCheck == 0
                                              ? Positioned(
                                                  top: 10,
                                                  left: 5,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
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
                                            friendNickname,
                                            style: const TextStyle(
                                              color: Color(0xff3F51B5),
                                              fontSize: 17,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            lastChat,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
