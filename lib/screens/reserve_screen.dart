import 'package:dancemate_app/provider/reserve_provider.dart';
import 'package:dancemate_app/screens/reserve_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReserveScreen extends ConsumerWidget {
  final int courseDetailId;

  const ReserveScreen({
    super.key,
    required this.courseDetailId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveData = ref.watch(getReserveProvider(courseDetailId));
    int selectUserTicket = ref.watch(selectUserTicketProvider);

    if (reserveData.value != null) {
      if (selectUserTicket == 0) {
        if (reserveData.value['tickets'].length > 0) {
          selectUserTicket = reserveData.value['tickets'][0]['id'];
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: reserveData.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) {
              print(error);
              return SizedBox(
                width: 300,
                child: Text('error: $error'),
              );
            },
            data: (reserveDataList) {
              final courseData = reserveDataList['course'];
              final courseTitle = courseData['title'];
              final courseImage = courseData['image_url'];

              final dancerData = courseData['dancer'];
              final dancerEmail = dancerData['email'];
              final dancerNickname = dancerData['nickname'];
              final dancerImageUrl = dancerData['image_url'];

              final courseDetailData = courseData['course_detail'][0];
              final courseDetailTitle = courseDetailData['title'];
              final courseDetailDate = courseDetailData['course_date'];

              final ticketData = reserveDataList['tickets'];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              courseImage,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    dancerImageUrl,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff6555FF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                      dancerEmail,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              courseTitle,
                              style: const TextStyle(
                                color: Color(0xff3F51B5),
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '$courseDetailDate $courseDetailTitle',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ticketData.length,
                      itemBuilder: (context, index) {
                        final ticketDetail = ticketData[index];

                        final ticketId = ticketDetail['id'];
                        final ticketCount = ticketDetail['count'];
                        final ticketRemainCount = ticketDetail['remain_count'];
                        final expiredDate = ticketDetail['expired_date'];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: ticketId,
                                  groupValue: selectUserTicket,
                                  onChanged: (value) {
                                    ref
                                        .read(selectUserTicketProvider.notifier)
                                        .update((state) => value as int);
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff6555FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      dancerNickname,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$ticketRemainCount회권 / $ticketCount회권',
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(expiredDate),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Text('예약할 때 주의사항이나 동의사항 등등'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () async {
              List<int> args = [
                courseDetailId,
                selectUserTicket,
              ];
              final result =
                  await ref.watch(postCourseDetailReserveProvider(args).future);
              if (result['result_code'] == 200) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReserveCompleteScreen(
                      reserveData: reserveData.value,
                    ),
                  ),
                );
              }
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
                    '예약하기',
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
