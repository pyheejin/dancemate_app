import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonChatRoomDetailScreen extends ConsumerWidget {
  final int chatRoomId;

  const LessonChatRoomDetailScreen({
    super.key,
    required this.chatRoomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('chatRoomId: $chatRoomId');
    final scrollController = ScrollController();
    final TextEditingController chatController = TextEditingController();
    final chatRoomData = ref.watch(getChatRoomDetailProvider(chatRoomId));
    int roomNotice = ref.watch(chatRoomNoticeProvider);

    Future<void> onProfileImageTap(String imagePath) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoScreen(
            imagePathList: [imagePath],
            currentIndex: 0,
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: chatRoomData.when(
          data: (room) {
            print(room);
            String roomTitle = room['lesson']['title'];
            return Text(roomTitle);
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            return SizedBox(
              width: 300,
              child: Text('chat room detail error: $error'),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
            ref.refresh(getChatRoomProvider(50));
          },
        ),
      ),
      endDrawer: Drawer(
        child: chatRoomData.when(
          data: (room) {
            print(room);
            final lessonData = room['lesson'];
            String roomTitle = lessonData['title'];
            String roomImageUrl = lessonData['image_url'];

            final dancerData = room['dancer'];
            String dancerImageUrl = dancerData['image_url'];
            final dancerNickname = dancerData['nickname'];

            ImageProvider finalImageProvider;
            if (dancerImageUrl != '') {
              if (dancerImageUrl.split(':')[0] == 'https') {
                finalImageProvider = NetworkImage(dancerImageUrl);
              } else {
                finalImageProvider = AssetImage(dancerImageUrl);
              }
            } else {
              // 기본 이미지 경로 설정
              dancerImageUrl = 'assets/images/app_logo/chat.png';
              finalImageProvider = AssetImage(dancerImageUrl);
            }

            ImageProvider finalLessonImageProvider;
            if (roomImageUrl != '') {
              if (roomImageUrl.split(':')[0] == 'https') {
                finalLessonImageProvider = NetworkImage(roomImageUrl);
              } else {
                finalLessonImageProvider = AssetImage(roomImageUrl);
              }
            } else {
              // 기본 이미지 경로 설정
              roomImageUrl = 'assets/images/app_logo/chat.png';
              finalLessonImageProvider = AssetImage(roomImageUrl);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          roomNotice == 1
                              ? Icons.notifications_none_rounded
                              : Icons.notifications_off_outlined,
                          size: 25,
                        ),
                        onPressed: () async {
                          final result = await ref.refresh(
                              postChatRoomDetailNoticeProvider(chatRoomId)
                                  .future);
                          if (result['result_code'] == 200) {
                            ref.read(chatRoomNoticeProvider.notifier).update(
                                (state) => result['result_data']['is_notice']);
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: GestureDetector(
                          onTap: () {
                            onProfileImageTap(roomImageUrl);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            foregroundImage: finalLessonImageProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        roomTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: const Color(0xFFA48AFF),
                          ),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onProfileImageTap(dancerImageUrl);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            foregroundImage: finalImageProvider,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dancerNickname,
                        style: const TextStyle(
                          color: Color(0xFFA48AFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: room['reserve_users'].length,
                      itemBuilder: (context, index) {
                        final loginUserId = room['login_user_id'];
                        final userData = room['reserve_users'][index]['user'];
                        final userId = userData['id'];
                        String userImageUrl = userData['image_url'];
                        final userNickname = userData['nickname'];

                        ImageProvider finalImageProvider;
                        if (userImageUrl != '') {
                          if (userImageUrl.split(':')[0] == 'https') {
                            finalImageProvider = NetworkImage(userImageUrl);
                          } else {
                            finalImageProvider = AssetImage(userImageUrl);
                          }
                        } else {
                          // 기본 이미지 경로 설정
                          userImageUrl = 'assets/images/app_logo/chat.png';
                          finalImageProvider = AssetImage(userImageUrl);
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onProfileImageTap(userImageUrl);
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    foregroundImage: finalImageProvider,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                userNickname,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: userId == loginUserId
                                      ? const Color(0xFF74D0FF)
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            return SizedBox(
              width: 300,
              child: Text('chat room detail error: $error'),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // <-- 키보드 숨기기
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: chatRoomData.when(
                        data: (room) {
                          final roomData = room['chat_room'];
                          final lessonData = roomData['lesson'];
                          final dancerData = lessonData['dancer'];
                          final dancerId = dancerData['id'];
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: room['chats'].length,
                              itemBuilder: (context, index) {
                                final chatData = room['chats'][index];
                                final date = chatData['date'];
                                final chatList = chatData['chat_list'];
                                return Column(
                                  children: [
                                    Text(date),
                                    ListView.separated(
                                      reverse: true,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                                      scrollDirection: Axis.vertical,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(
                                        height: 12,
                                      ),
                                      itemCount: chatList.length,
                                      itemBuilder: (context, index) {
                                        if (chatList.isEmpty) {
                                          return Container();
                                        }

                                        final chatData = chatList[index];
                                        final chatType = chatData['type'];
                                        final chatMessage = chatData['message'];
                                        final chatTime = chatData['created_at']
                                            .split(' ')[1];

                                        final loginUserId =
                                            chatData['login_user_id'];

                                        final userData = chatData['user'];
                                        final userId = userData['id'];
                                        final imageUrl = userData['image_url'];
                                        final userNickname =
                                            userData['nickname'];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: chatType ==
                                                  1 // 채팅 메시지이면 1, 공지나 날짜이면 99(가운데 정렬)
                                              ? Row(
                                                  mainAxisAlignment: userId ==
                                                          loginUserId
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    userId == loginUserId
                                                        ? Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                chatTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0xFFA48AFF),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                  child: Text(
                                                                    chatMessage,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: userId ==
                                                                            dancerId
                                                                        ? 2
                                                                        : 1,
                                                                    color: userId ==
                                                                            dancerId
                                                                        ? const Color(
                                                                            0xFFA48AFF)
                                                                        : Colors
                                                                            .grey
                                                                            .shade400,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              35),
                                                                ),
                                                                child: imageUrl ==
                                                                        ''
                                                                    ? const CircleAvatar(
                                                                        foregroundImage:
                                                                            AssetImage('assets/images/app_logo/chat.png'),
                                                                      )
                                                                    : imageUrl.split(':')[0] ==
                                                                            'https'
                                                                        ? CircleAvatar(
                                                                            radius:
                                                                                50,
                                                                            foregroundImage:
                                                                                NetworkImage(imageUrl),
                                                                            // child:
                                                                            //     Text(userNickname),
                                                                          )
                                                                        : CircleAvatar(
                                                                            radius:
                                                                                50,
                                                                            foregroundImage:
                                                                                AssetImage(imageUrl),
                                                                            child:
                                                                                Text(userNickname),
                                                                          ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    userNickname,
                                                                    style:
                                                                        TextStyle(
                                                                      color: userId ==
                                                                              dancerId
                                                                          ? const Color(
                                                                              0xFFA48AFF)
                                                                          : Colors
                                                                              .black,
                                                                      fontWeight: userId ==
                                                                              dancerId
                                                                          ? FontWeight
                                                                              .bold
                                                                          : FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color(
                                                                            0xFF74D0FF),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        chatMessage,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                chatTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 5,
                                                          horizontal: 20,
                                                        ),
                                                        child: Text(
                                                          chatMessage,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) {
                          return SizedBox(
                            width: 300,
                            child: Text('chat room detail error: $error'),
                          );
                        },
                      ),
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
                              final result = await ref
                                  .read(chatRoomProvider.notifier)
                                  .postChatRoomDetailChat(
                                    chatRoomId,
                                    chatController.text,
                                  );
                              if (result['result_code'] == 200) {
                                ref.refresh(
                                    getChatRoomDetailProvider(chatRoomId));
                                ref.refresh(getChatRoomProvider(50));
                              }

                              // 스크롤 위치를 맨 아래로 이동 시킴
                              scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
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
