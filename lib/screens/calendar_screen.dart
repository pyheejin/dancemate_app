import 'dart:collection';

import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Event {
  String title;
  Event(this.title);

  @override
  String toString() => title;
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime sDay = DateTime.now();
    var selectDay = ref.watch(selectDateProvider(sDay));
    var courses = ref.watch(getCourseProvider(selectDay));
    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

    Map<DateTime, List<Event>> events = {
      DateTime.utc(2025, 2, 13): [Event('title'), Event('title2')],
      DateTime.utc(2025, 2, 14): [Event('title3')],
    };
    // final events = LinkedHashMap(
    //   equals: isSameDay,
    // )..addAll(eventSource);

    List<Event> getEventsForDay(DateTime day) {
      return events[day] ?? [];
    }

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(courseId: courseId),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            TableCalendar(
              // 달에 첫 날
              firstDay: DateTime(now.year - 1, now.month, 1),
              // 달에 마지막 날
              lastDay: DateTime(now.year + 10, 12, 31),
              focusedDay: DateTime.parse(selectDay),
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFFA48AFF),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(sDay, day);
              },
              // 사용자가 캘린더에 요일을 클릭했을 때
              onDaySelected: (selectedDay, focusedDay) {
                selectDay = DateFormat('yyyy-MM-dd').format(selectedDay);
                now = focusedDay;
                courses = ref.watch(getCourseProvider(selectDay));

                print(selectDay);
                print(courses);
              },
              onPageChanged: (focusedDay) {
                now = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(days[day.weekday]),
                  );
                },
                // markerBuilder: (context, date, events) {
                //   DateTime date2 = DateTime(date.year, date.month, date.day);
                //   return null;
                // },
              ),

              eventLoader: (day) {
                final dateFormat = DateFormat('yyyy-MM-dd');
                final newDay = dateFormat.format(day);
                return getEventsForDay(day);
              },
            ),
            Expanded(
              child: courses.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  print(error);
                  return SizedBox(
                    width: 200,
                    child: Text('error: $error'),
                  );
                },
                data: (reserveCourseList) {
                  return ListView.builder(
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
                        onTap: () {
                          onCourseTap(courseData['id']);
                        },
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
