import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/chat_room_detail_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({
    super.key,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(getChatRoomProvider(1).notifier).loadMoreItems(1);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onChatRoomTap(int chatRoomId) {
    ref.refresh(getChatRoomDetailProvider(chatRoomId));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatRoomDetailScreen(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  // 이 오버라이드를 추가해야 위젯 상태를 유지
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final chatRoomData = ref.watch(getChatRoomProvider(1));
    final loginUserId =
        ref.read(getChatRoomProvider(1).notifier).getLoginUserId();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                FocusScope.of(context).unfocus(); // <-- 키보드 숨기기
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: chatRoomData.when(
                  data: (room) {
                    if (room.isEmpty) {
                      return const Center(child: Text('채팅방이 없습니다.'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: room.length,
                      itemBuilder: (context, index) {
                        final roomData = room[index];
                        final chatUserId = roomData['user_id'];
                        final lastChat = roomData['last_chat'] ?? '';
                        final lastChatTime = roomData['last_chat_time'] ?? '';

                        final roomNotificationData =
                            roomData['room_notification'];

                        int isCheck = 0;
                        if (roomNotificationData.isNotEmpty) {
                          isCheck = roomNotificationData[0]['status'];
                        }

                        final userData = roomData['user'];
                        final friendData = roomData['friend'];
                        String friendNickname = '';
                        String friendImageUrl = '';

                        if (friendData != null) {
                          if (loginUserId == chatUserId) {
                            friendNickname = friendData['nickname'];
                            friendImageUrl = friendData['image_url'];
                          } else {
                            friendNickname = userData['nickname'];
                            friendImageUrl = userData['image_url'];
                          }
                        }
                        return GestureDetector(
                          onTap: () {
                            _onChatRoomTap(roomData['id']);
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
                                            child: Image.network(
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              friendImageUrl,
                                            ),
                                          ),
                                          if (isCheck == 0)
                                            Positioned(
                                              top: 10,
                                              left: 5,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
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
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  lastChatTime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
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
