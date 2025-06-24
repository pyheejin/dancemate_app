import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
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
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    DateTime now = DateTime.now();
    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime selectDay = ref.watch(selectDateProvider);
    var courses = ref.watch(getLessonProvider(dateFormat.format(selectDay)));

    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

    int selectMonth = ref.watch(selectMonthProvider);
    dynamic monthCourses = ref.watch(getCalendarLessonProvider(selectMonth));

    Map<dynamic, List<dynamic>> events = {};
    if (monthCourses.value != null) {
      for (var course in monthCourses.value) {
        var date = dateFormat.parse(course['date']);
        events[date] = course['course_list'];
      }
    }

    List<dynamic> getEventsForDay(DateTime day) {
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
              focusedDay: selectDay,
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFFA48AFF),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFFA48AFF),
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(selectDay, day);
              },
              // 사용자가 캘린더에 요일을 클릭했을 때
              onDaySelected: (selectedDay, focusedDay) {
                selectDay = selectedDay;
                now = focusedDay;

                ref
                    .read(selectDateProvider.notifier)
                    .update((state) => selectDay);
                courses = ref.watch(getLessonProvider(selectDay));
              },
              onPageChanged: (focusedDay) {
                now = focusedDay;
                // ref
                //     .read(selectMonthProvider.notifier)
                //     .update((state) => focusedDay.month);
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(days[day.weekday]),
                  );
                },
              ),
              // 마커 표시
              eventLoader: (day) {
                final dateFormat = DateFormat('yyyy-MM-dd');
                final newDay = dateFormat.format(day);
                return getEventsForDay(dateFormat.parse(newDay));
              },
            ),
            const SizedBox(height: 10),
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
                  if (reserveCourseList != null) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: reserveCourseList.length,
                      itemBuilder: (context, index) {
                        final courseData = reserveCourseList[index];
                        final courseDate = courseData['course_date'];
                        final courseTitle = courseData['title'];
                        final courseStartTime = courseData['start_time'];
                        final courseEndTime = courseData['end_time'];
                        final isCourseLike = courseData['is_like'];

                        final lessonData = courseData['lesson'];
                        final lessonImage = lessonData['image_url'];
                        final lessonTitle = lessonData['title'];

                        final dancerData = lessonData['dancer'];
                        final dancerNickname = dancerData['nickname'];
                        final dancerEmail = dancerData['email'];
                        final dancerImageUrl = dancerData['image_url'];

                        return GestureDetector(
                          onTap: () {
                            onCourseTap(lessonData['id']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                lessonImage == null
                                    ? Image.asset(
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        'assets/images/app_logo/2x.png',
                                      )
                                    : Image.network(
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        lessonImage,
                                      ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        dancerImageUrl.split(':')[0] == 'https'
                                            ? CircleAvatar(
                                                foregroundImage: NetworkImage(
                                                    dancerImageUrl),
                                              )
                                            : CircleAvatar(
                                                foregroundImage:
                                                    AssetImage(dancerImageUrl),
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
                                      lessonTitle,
                                      style: const TextStyle(
                                        color: Color(0xff3F51B5),
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '$courseDate, $courseTitle',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '$courseStartTime - $courseEndTime',
                                      style: const TextStyle(
                                        fontSize: 15,
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
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
