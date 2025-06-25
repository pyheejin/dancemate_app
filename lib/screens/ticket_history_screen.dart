import 'package:dancemate_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketHistoryScreen extends ConsumerWidget {
  const TicketHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketData = ref.watch(getUserTicketProvider(0));
    NumberFormat format = NumberFormat('###,###,###,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('티켓 구매내역'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.sort_rounded,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: ticketData.when(
          loading: () => const CircularProgressIndicator(),
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
                        final dancerData = ticketList[index]['dancer'];
                        final dancerEmail = dancerData['email'];
                        final dancerNickname = dancerData['nickname'];
                        final dancerImageUrl = dancerData['image_url'];

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
                              Container(
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
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
                                            child: dancerImageUrl == ''
                                                ? const CircleAvatar(
                                                    foregroundImage: AssetImage(
                                                        'assets/images/app_logo/chat.png'),
                                                  )
                                                : dancerImageUrl
                                                            .split(':')[0] ==
                                                        'https'
                                                    ? CircleAvatar(
                                                        foregroundImage:
                                                            NetworkImage(
                                                                dancerImageUrl),
                                                      )
                                                    : CircleAvatar(
                                                        foregroundImage:
                                                            AssetImage(
                                                                dancerImageUrl),
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
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  child: Text(
                                                    dancerNickname,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '@$dancerEmail',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
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
                              Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 30,
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        '남은 횟수:\n $remainCount회',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        textAlign: TextAlign.right,
                                        '$expiredDate',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
