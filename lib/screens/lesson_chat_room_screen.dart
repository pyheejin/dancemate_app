import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/screens/lesson_chat_room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonChatRoomScreen extends ConsumerStatefulWidget {
  const LessonChatRoomScreen({
    super.key,
  });

  @override
  ConsumerState<LessonChatRoomScreen> createState() =>
      _LessonChatRoomScreenState();
}

class _LessonChatRoomScreenState extends ConsumerState<LessonChatRoomScreen>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // 3. initState에서 리스너를 한 번만 등록
    _scrollController.addListener(_onScroll);
  }

  // 4. 스크롤 이벤트 핸들러 메서드 생성
  void _onScroll() {
    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(getChatRoomProvider(50).notifier).loadMoreItems(50);
    }
  }

  @override
  void dispose() {
    // 5. dispose에서 리스너를 제거하고 컨트롤러를 해제
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onChatRoomTap(int chatRoomId) {
    ref.refresh(getChatRoomDetailProvider(chatRoomId));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            LessonChatRoomDetailScreen(chatRoomId: chatRoomId),
      ),
    );
  }

  // 이 오버라이드를 추가해야 위젯 상태를 유지합니다.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final chatRoomData = ref.watch(getChatRoomProvider(50));

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
                FocusScope.of(context).unfocus(); // <-- 키보드 숨기기
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: chatRoomData.when(
                  data: (room) {
                    if (room == null || room['chat_rooms'].isEmpty) {
                      return const Center(child: Text('채팅방이 없습니다.'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: room['chat_rooms'].length,
                      itemBuilder: (context, index) {
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
                                            lessonTitle,
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
