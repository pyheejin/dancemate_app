import 'package:dancemate_app/provider/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketSalesDetailScreen extends ConsumerStatefulWidget {
  final String args;

  const TicketSalesDetailScreen({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<TicketSalesDetailScreen> createState() =>
      _TicketSalesDetailScreenState();
}

// State 클래스 생성
class _TicketSalesDetailScreenState
    extends ConsumerState<TicketSalesDetailScreen>
    with AutomaticKeepAliveClientMixin {
  // 2. ScrollController를 State의 멤버 변수로 이동
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
      ref.read(itemListProvider.notifier).loadMoreItems();
    }
  }

  @override
  void dispose() {
    // 5. dispose에서 리스너를 제거하고 컨트롤러를 해제
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 이 오버라이드를 추가해야 위젯 상태를 유지합니다.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context)를 호출해야 mixin이 작동합니다.
    super.build(context); // 중요!

    int year = int.parse(widget.args.split('-')[0]);
    int month = int.parse(widget.args.split('-')[1]);
    final ticketData = ref.watch(itemListProvider);
    NumberFormat format = NumberFormat('###,###,###,###');

    void onRefundTap() {}

    return Scaffold(
      appBar: AppBar(
        title: Text('$year년 $month월 티켓 판매내역'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: ticketData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            print(error);
            return SizedBox(
              width: 300,
              child: Text('error: $error'),
            );
          },
          data: (dataList) {
            if (dataList.isEmpty && !ticketData.isLoading) {
              return const Center(child: Text('데이터가 없습니다.'));
            }
            return CustomScrollView(
              controller: _scrollController, // 상위 스크롤 컨트롤러 사용
              slivers: [
                // 각 날짜별 섹션을 하나의 SliverList로 처리
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // 마지막 인덱스에 로딩 인디케이터 추가
                      if (index >= dataList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final date = dataList[index]['date'];
                      final ticketList = dataList[index]['ticket_list'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 날짜 표시
                            Text(date),
                            const SizedBox(height: 5),
                            // 날짜 아래의 티켓 항목들
                            // 각 티켓 항목을 직접 build
                            ...ticketList.map<Widget>((ticket) {
                              final mateData = ticket['mate'];
                              final mateEmail = mateData['email'];
                              final mateNickname = mateData['nickname'];
                              final mateImageUrl = mateData['image_url'];

                              final count = ticket['count'];
                              final remainCount = ticket['remain_count'];
                              final price = ticket['price'];
                              // final expiredDate = ticket['expired_date'];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(88, 163, 138, 255),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.black38,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                    ),
                                                    child: mateImageUrl == ''
                                                        ? const CircleAvatar(
                                                            foregroundImage:
                                                                AssetImage(
                                                                    'assets/images/app_logo/chat.png'),
                                                          )
                                                        : mateImageUrl.split(
                                                                    ':')[0] ==
                                                                'https'
                                                            ? CircleAvatar(
                                                                foregroundImage:
                                                                    NetworkImage(
                                                                        mateImageUrl),
                                                              )
                                                            : CircleAvatar(
                                                                foregroundImage:
                                                                    AssetImage(
                                                                        mateImageUrl),
                                                              ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xff6555FF),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Text(
                                                            mateNickname,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '@$mateEmail',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              const Row(
                                                children: [
                                                  Text(
                                                    '결제방법:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '카드',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text(
                                                    '카드사:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '신한카드',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '$count',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 100),
                                                  Text(
                                                    '$price원', // 가격 포맷 적용
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 1),
                                    GestureDetector(
                                      onTap: onRefundTap,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: remainCount > 0
                                              ? const Color.fromARGB(
                                                  81, 64, 195, 255)
                                              : Colors.black12,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                          border: const Border(
                                            left: BorderSide(
                                              color: Colors.black26,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 55,
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            '환불',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
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
                    childCount:
                        dataList.length + (ticketData.isLoading ? 1 : 0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
