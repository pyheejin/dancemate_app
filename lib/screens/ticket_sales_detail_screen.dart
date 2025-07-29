import 'package:dancemate_app/provider/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketSalesDetailScreen extends ConsumerWidget {
  final String args;

  const TicketSalesDetailScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int year = int.parse(args.split('-')[0]);
    int month = int.parse(args.split('-')[1]);
    final ticketData = ref.watch(getTicketSalesProvider(args));
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
          data: (dataList) => ListView.builder(
            shrinkWrap: true,
            itemCount: dataList['tickets'].length,
            itemBuilder: (context, index) {
              final date = dataList['tickets'][index]['date'];
              final ticketList = dataList['tickets'][index]['ticket_list'];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ticketList.length,
                      itemBuilder: (context, index) {
                        final mateData = ticketList[index]['mate'];
                        final mateEmail = mateData['email'];
                        final mateNickname = mateData['nickname'];
                        final mateImageUrl = mateData['image_url'];

                        final count = ticketList[index]['count'];
                        final remainCount = ticketList[index]['remain_count'];
                        final price = ticketList[index]['price'];
                        final expiredDate = ticketList[index]['expired_date'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(88, 163, 138, 255),
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
                                                  color: Colors.grey.shade400,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: mateImageUrl == ''
                                                  ? const CircleAvatar(
                                                      foregroundImage: AssetImage(
                                                          'assets/images/app_logo/chat.png'),
                                                    )
                                                  : mateImageUrl
                                                              .split(':')[0] ==
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff6555FF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Text(
                                                      mateNickname,
                                                      style: const TextStyle(
                                                        color: Colors.white,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$count',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 100),
                                            Text(
                                              '$price원',
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
                                        ? const Color.fromARGB(81, 64, 195, 255)
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
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
