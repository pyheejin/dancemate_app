import 'package:dancemate_app/provider/ticket_provider.dart';
import 'package:dancemate_app/screens/ticket_sales_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketSalesScreen extends ConsumerStatefulWidget {
  const TicketSalesScreen({super.key});

  @override
  ConsumerState<TicketSalesScreen> createState() => _TicketSalesScreenState();
}

// State 클래스 생성
class _TicketSalesScreenState extends ConsumerState<TicketSalesScreen>
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
    int year = 0;
    int month = 0;

    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(ticketListProvider('0-0').notifier).loadMoreItems(year, month);
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

    final ticketData = ref.watch(ticketListProvider('0-0'));
    NumberFormat format = NumberFormat('###,###,###,###');

    void onMonthTap(String date) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TicketSalesDetailScreen(args: date),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('티켓 판매내역'),
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

                      final year = dataList[index]['year'];
                      final monthList = dataList[index]['month_list'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 날짜 표시
                            Text(year),
                            const SizedBox(height: 5),
                            // 날짜 아래의 티켓 항목들
                            // 각 티켓 항목을 직접 build
                            ...monthList.map<Widget>((monthData) {
                              final month = monthData['month'];
                              final price = monthData['total_price'];

                              return GestureDetector(
                                onTap: () {
                                  onMonthTap('$year-$month');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                88, 163, 138, 255),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: const Border(
                                              right: BorderSide(
                                                color: Colors.black38,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '$month월',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 100),
                                                    Text(
                                                      '${format.format(price)}원',
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
                                    ],
                                  ),
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
