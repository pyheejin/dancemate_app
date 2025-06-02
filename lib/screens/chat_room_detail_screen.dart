import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: chatRoomData.when(
          data: (room) {
            return Text(room['lesson']['title']);
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
            ref.refresh(getChatRoomProvider);
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
                      child: chatRoomData.when(
                        data: (room) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: room['chat_room'].length,
                            itemBuilder: (context, index) {
                              final date = room['chat_room'][index]['date'];
                              final chatList =
                                  room['chat_room'][index]['chat_list'];
                              return Column(
                                children: [
                                  Text(date),
                                  ListView.separated(
                                    reverse: true,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    separatorBuilder: (_, __) => const SizedBox(
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
                                      final chatTime =
                                          chatData['created_at'].split(' ')[1];

                                      final loginUserId =
                                          chatData['login_user_id'];

                                      final userData = chatData['user'];
                                      final userId = userData['id'];
                                      final userImage = userData['image_url'];
                                      final userNickname = userData['nickname'];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: chatType == 1
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
                                                                border:
                                                                    Border.all(
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
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            35),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  userImage,
                                                                ),
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
                                                                    userNickname),
                                                                const SizedBox(
                                                                    height: 2),
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
                                                                        BorderRadius
                                                                            .circular(5),
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
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5,
                                                        horizontal: 20,
                                                      ),
                                                      child: Text(
                                                        chatMessage,
                                                        style: const TextStyle(
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
                                ref.refresh(getChatRoomProvider);
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
