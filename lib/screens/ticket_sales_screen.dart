import 'package:dancemate_app/provider/ticket_provider.dart';
import 'package:dancemate_app/screens/ticket_sales_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketSalesScreen extends ConsumerWidget {
  const TicketSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String args = '0-0';
    final ticketData = ref.watch(getTicketSalesProvider(args));
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
            return ListView.builder(
              shrinkWrap: true,
              itemCount: dataList['tickets'].length,
              itemBuilder: (context, index) {
                final year = dataList['tickets'][index]['year'];
                final monthList = dataList['tickets'][index]['month_list'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(year),
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: monthList.length,
                        itemBuilder: (context, index) {
                          final month = monthList[index]['month'];
                          final price = monthList[index]['total_price'];
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
                                        borderRadius: BorderRadius.circular(15),
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
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
