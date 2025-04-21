import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:dancemate_app/screens/dancer_course_detail_create_screen.dart';
import 'package:dancemate_app/screens/dancer_ticket_detail_create_screen.dart';
import 'package:dancemate_app/screens/dancer_ticket_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DancerTicketScreen extends ConsumerWidget {
  const DancerTicketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticektData = ref.watch(getDancerTicketProvider);
    NumberFormat format = NumberFormat('###,###,###,###');

    void onTicketTap(int ticketId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DancerTicketDetailScreen(ticketId: ticketId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('티켓 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            ticektData.when(
              data: (ticketList) {
                final expiredDay = ticketList['expired_day'];
                final TextEditingController expiredDayController =
                    TextEditingController(text: expiredDay.toString());
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA48AFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 70,
                        ),
                        child: Text(
                          '유효기간',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: expiredDayController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '일',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFA48AFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Text(
                            '적용',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black38),
                  ),
                ),
              ),
            ),
            ticektData.when(
              data: (ticketList) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: ticketList['tickets'].length,
                  itemBuilder: (context, index) {
                    if (ticketList['tickets'].isEmpty) {
                      return null;
                    }

                    final ticketDetail = ticketList['tickets'][index];
                    final ticketId = ticketDetail['id'];
                    final count = ticketDetail['count'];
                    final price = ticketDetail['price'];
                    return GestureDetector(
                      onTap: () {
                        onTicketTap(ticketId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '$count회권',
                              style: const TextStyle(
                                // color: Color(0xff3F51B5),
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${format.format(price)}원',
                              style: const TextStyle(
                                // color: Color(0xff3F51B5),
                                fontSize: 20,
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DancerTicketDetailCreateScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFA48AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '추가하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
