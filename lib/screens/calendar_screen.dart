import 'package:dancemate_app/provider/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(getCourseProvider('2025-02-03'));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 45,
          left: 20,
          right: 20,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              ),
            ),
            SliverToBoxAdapter(
              child: courses.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  print(error);
                  return SizedBox(
                    width: 200,
                    child: Text('error: $error'),
                  );
                },
                data: (reserveCourseList) => ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: reserveCourseList.length,
                  itemBuilder: (context, index) {
                    final dancerData =
                        reserveCourseList[index]['course']['dancer'];
                    final dancerNickname = dancerData['nickname'];
                    final dancerEmail = dancerData['email'];
                    final dancerImageUrl = dancerData['image_url'];

                    final courseDetailData = reserveCourseList[index];
                    final courseDetailDate = courseDetailData['course_date'];
                    final courseDetailTitle = courseDetailData['title'];

                    final courseData = reserveCourseList[index]['course'];
                    final courseImage = courseData['image_url'];
                    final courseTitle = courseData['title'];
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Row(
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
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff9475FF),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xff6555FF),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
