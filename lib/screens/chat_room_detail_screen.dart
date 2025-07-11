import 'dart:convert';

import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/chat_room_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatRoomDetailScreen extends ConsumerWidget {
  final int chatRoomId;

  const ChatRoomDetailScreen({
    super.key,
    required this.chatRoomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final TextEditingController chatController = TextEditingController();
    final chatRoomData = ref.watch(getChatRoomDetailProvider(chatRoomId));

    void onNoticeTap() async {
      final result = await ref
          .read(chatRoomProvider.notifier)
          .putChatRoomDetail(chatRoomId);
      if (result['result_code'] == 200) {
        ref.refresh(getChatRoomDetailProvider(chatRoomId));
      } else {
        errorAlert(context, result['result_msg']);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: chatRoomData.when(
          data: (room) {
            final loginUserId = room['login_user_id'];

            final userData = room['chat_room']['user'];
            final userId = userData['id'];

            final friendData = room['chat_room']['friend'];

            String nickname = userData['nickname'];
            if (loginUserId == userId) {
              nickname = friendData['nickname'];
            }
            return Text(nickname);
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChatRoomScreen(),
              ),
            );
            ref.refresh(getChatRoomProvider(1));
          },
        ),
        actions: [
          GestureDetector(
            onTap: onNoticeTap,
            child: chatRoomData.when(
              data: (room) {
                final isNotice = room['is_notice'];
                return Icon(
                  isNotice == 1
                      ? Icons.notifications_outlined
                      : Icons.notifications_off_outlined,
                  size: 27,
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) {
                return SizedBox(
                  width: 300,
                  child: Text('chat room detail actions error: $error'),
                );
              },
            ),
          ),
          const SizedBox(width: 5),
        ],
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
                      child: chatRoomData.when(
                        data: (room) {
                          final loginUserId = room['login_user_id'];
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: room['chats'].length,
                              itemBuilder: (context, index) {
                                final userData = room['chat_room']['user'];
                                final userId = userData['id'];
                                final userNickname = userData['nickname'];
                                final userImageUrl = userData['image_url'];

                                final friendData = room['chat_room']['friend'];
                                final friendId = friendData['id'];
                                String friendNickname = friendData['nickname'];
                                String friendImageUrl = friendData['image_url'];

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

                                        final chatUserId =
                                            chatData['user']['id'];

                                        if (chatUserId == loginUserId) {
                                          friendNickname =
                                              friendData['nickname'];
                                          friendImageUrl =
                                              friendData['image_url'];
                                        } else {
                                          friendNickname =
                                              chatData['user']['nickname'];
                                          friendImageUrl =
                                              chatData['user']['image_url'];
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: chatType ==
                                                  1 // 채팅 메시지이면 1, 공지나 날짜이면 99(가운데 정렬)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      chatUserId == loginUserId
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                  children: [
                                                    chatUserId == loginUserId
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
                                                              SizedBox(
                                                                width: 50,
                                                                height: 50,
                                                                child: friendImageUrl ==
                                                                        ''
                                                                    ? const CircleAvatar(
                                                                        foregroundImage:
                                                                            AssetImage('assets/images/app_logo/chat.png'),
                                                                      )
                                                                    : friendImageUrl.split(':')[0] ==
                                                                            'https'
                                                                        ? CircleAvatar(
                                                                            radius:
                                                                                50,
                                                                            foregroundImage:
                                                                                NetworkImage(friendImageUrl),
                                                                            // child:
                                                                            //     Text(friendNickname),
                                                                          )
                                                                        : CircleAvatar(
                                                                            radius:
                                                                                50,
                                                                            foregroundImage:
                                                                                AssetImage(friendImageUrl),
                                                                            child:
                                                                                Text(friendNickname),
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
                                                                    friendNickname,
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
                                ref.refresh(getChatRoomProvider(1));
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
