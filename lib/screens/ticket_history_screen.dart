import 'package:dancemate_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketHistoryScreen extends ConsumerWidget {
  const TicketHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketData = ref.watch(getUserTicketProvider(0));

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ticketData.when(
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
                          itemCount: ticketList.length,
                          itemBuilder: (context, index) {
                            final nickname = ticketList[index]['nickname'];
                            final count = ticketList[index]['count'];
                            final price = ticketList[index]['price'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff6555FF),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        nickname,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    count,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff6555FF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 30,
                                      ),
                                      child: Text(
                                        price,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
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
          ],
        ),
      ),
    );
  }
}
