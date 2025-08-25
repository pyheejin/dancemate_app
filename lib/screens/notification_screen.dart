import 'package:dancemate_app/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

// AutomaticKeepAliveClientMixin을 선언해야 super.build(context)를 호출할 수 있음
class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // initState에서 리스너를 한 번만 등록
    _scrollController.addListener(_onScroll);
  }

  // 스크롤 이벤트 핸들러 메서드 생성
  void _onScroll() {
    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('스크롤 맨 끝');
      ref.read(userNotificationListProvider.notifier).loadMoreItems();
    }
  }

  @override
  void dispose() {
    // dispose에서 리스너를 제거하고 컨트롤러를 해제
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 이 오버라이드를 추가해야 위젯 상태를 유지
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context)를 호출해야 mixin이 작동
    super.build(context);

    final notificationData = ref.watch(userNotificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: notificationData.when(
        data: (notifications) {
          return CustomScrollView(
            controller: _scrollController, // 상위 스크롤 컨트롤러 사용
            slivers: [
              // 각 날짜별 섹션을 하나의 SliverList로 처리
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // 마지막 인덱스에 로딩 인디케이터 추가
                    if (index >= notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final noticeData = notifications[index];
                    final date = noticeData['date'];
                    final notificationList = noticeData['notification_list'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 날짜 표시
                          Text(date),
                          const SizedBox(height: 5),
                          // 날짜 아래의 항목들
                          // 각 항목을 직접 build
                          ...notificationList.map<Widget>((monthData) {
                            final title = monthData['title'];
                            final description = monthData['description'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xAAEFEEEE),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(title),
                                            Text(description),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(), // List<Widget>으로 변환
                        ],
                      ),
                    );
                  },
                  childCount: notifications.length +
                      (notificationData.isLoading ? 1 : 0),
                ),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) {
          print(error);

          return SizedBox(
            width: 300,
            child: Text('error: $error'),
          );
        },
      ),
    );
  }
}
