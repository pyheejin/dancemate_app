import 'dart:collection';
import 'package:dancemate_app/database/api.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;
  Event(this.title);

  @override
  String toString() => title;
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime now = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime? selectDay;

  Map<DateTime, dynamic> eventSource = {
    DateTime.parse('2025-02-03'): [
      Event('교회 가서 인증샷 찍기'),
      Event('QT하기'),
      Event('셀 모임하기'),
    ],
    DateTime.parse('2025-02-06'): [
      Event('치킨 먹기'),
      Event('QT하기'),
      Event('셀 모임하기'),
    ],
    DateTime.parse('2025-02-08'): [
      Event('자기 셀카 올리기'),
      Event('QT하기'),
      Event('셀 모임하기'),
    ],
  };

  final events = LinkedHashMap(
    equals: isSameDay,
  )..addAll({
      DateTime.parse('2025-02-03'): [
        Event('교회 가서 인증샷 찍기'),
        Event('QT하기'),
        Event('셀 모임하기'),
      ],
      DateTime.parse('2025-02-06'): [
        Event('치킨 먹기'),
        Event('QT하기'),
        Event('셀 모임하기'),
      ],
      DateTime.parse('2025-02-08'): [
        Event('자기 셀카 올리기'),
        Event('QT하기'),
        Event('셀 모임하기'),
      ],
    });

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  dynamic getCourseList(DateTime date) async {
    final ApiServices api = ApiServices();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final stringDate = dateFormat.format(date);
    final result = await api.getCourses(stringDate);
    return result;
  }

  void onCourseTap(int courseId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectDay == null) {
      selectDay = now;
    } else {
      selectDay = selectDay;
    }
    final courseList = getCourseList(selectDay!);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TableCalendar(
              // 달에 첫 날
              firstDay: DateTime(now.year, now.month, 1),
              // 달에 마지막 날
              lastDay: DateTime(now.year + 10, 12, 31),
              focusedDay: now,
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFFA48AFF),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(selectDay, day);
              },
              // 사용자가 캘린더에 요일을 클릭했을 때
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(selectDay, selectedDay)) {
                  setState(() {
                    selectDay = selectedDay;
                    now = focusedDay;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                now = focusedDay;
              },
              eventLoader: (day) {
                final dateFormat = DateFormat('yyyy-MM-dd');
                final newDay = dateFormat.format(day);
                print(events);
                print(events['2025-02-03 00:00:00.000']);

                if (day.weekday == DateTime.monday) {
                  return [Event('Cyclic event')];
                }

                return [];
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: courseList.length,
                itemBuilder: (context, index) {
                  final dancerData = courseList[index]['course']['dancer'];
                  final dancerNickname = dancerData['nickname'];
                  final dancerEmail = dancerData['email'];
                  final dancerImageUrl = dancerData['image_url'];

                  final courseDetailData = courseList[index];
                  final courseDetailDate = courseDetailData['course_date'];
                  final courseDetailTitle = courseDetailData['title'];

                  final courseData = courseList[index]['course'];
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
          ],
        ),
      ),
    );
  }
}
