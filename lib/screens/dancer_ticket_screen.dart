import 'package:dancemate_app/provider/dancer_provider.dart';
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
    final TextEditingController expiredDayController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ticektData.when(
                data: (ticketList) {
                  final expiredDay = ticketList['expired_day'];
                  expiredDayController.text = expiredDay.toString();
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
                        onTap: () async {
                          int day = int.parse(expiredDayController.text);
                          final result = await ref.watch(
                              postDancerTicketExpireProvider(day).future);
                          if (result['result_code'] == 200) {
                            ref.refresh(getDancerTicketProvider);
                          }
                        },
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

                      final dancerData = ticketDetail['dancer'];
                      final dancerEmail = dancerData['email'];
                      final dancerNickname = dancerData['nickname'];
                      final dancerImageUrl = dancerData['image_url'];
                      return GestureDetector(
                        onTap: () {
                          onTicketTap(ticketId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 30,
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
                                                        BorderRadius.circular(
                                                            10),
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
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '$count회권',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${format.format(price)}원',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA48AFF),
        elevation: 0.5,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DancerTicketDetailCreateScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white24,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 30),
      //     child: TextButton(
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (context) => const DancerTicketDetailCreateScreen(),
      //           ),
      //         );
      //       },
      //       style: TextButton.styleFrom(
      //         backgroundColor: const Color(0xFFA48AFF),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(5),
      //         ),
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.symmetric(
      //           vertical: 3,
      //           horizontal: 15,
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               '추가하기',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
