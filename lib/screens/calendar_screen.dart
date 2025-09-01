import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    final selectDay = ref.watch(selectDateProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final selectMonth = ref.watch(selectMonthProvider);

    final coursesForSelectedDay =
        ref.watch(getLessonProvider(dateFormat.format(selectDay)));
    final coursesForMonth = ref.watch(getCalendarLessonProvider(selectMonth));

    void navigateToLessonDetail(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(courseId: courseId),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                TableCalendar(
                  firstDay: DateTime(DateTime.now().year - 1),
                  lastDay: DateTime(DateTime.now().year + 10, 12, 31),
                  focusedDay: focusedDay,
                  calendarFormat: CalendarFormat.month,
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
                  selectedDayPredicate: (day) => isSameDay(selectDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(selectDay, selectedDay)) {
                      // 날짜 선택 시 selectDateProvider와 focusedDayProvider를 모두 업데이트
                      ref
                          .read(selectDateProvider.notifier)
                          .update((state) => selectedDay);
                      ref
                          .read(focusedDayProvider.notifier)
                          .update((state) => focusedDay);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // 월 변경 시 focusedDayProvider만 업데이트
                    ref
                        .read(focusedDayProvider.notifier)
                        .update((state) => focusedDay);
                  },
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      const days = ['월', '화', '수', '목', '금', '토', '일'];
                      return Center(
                        child: Text(days[day.weekday - 1]),
                      );
                    },
                  ),
                  eventLoader: (day) {
                    if (coursesForMonth.value != null) {
                      for (final course in coursesForMonth.value) {
                        final courseDate = dateFormat.parse(course['date']);
                        if (isSameDay(courseDate, day)) {
                          return course['course_list'];
                        }
                      }
                    }
                    return [];
                  },
                ),
                Positioned(
                  top: 5,
                  right: 65,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(selectDateProvider.notifier)
                          .update((state) => DateTime.now());
                      ref
                          .read(focusedDayProvider.notifier)
                          .update((state) => DateTime.now());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    child: const Text(
                      '오늘',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: coursesForSelectedDay.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  print('Error: $error');
                  return const Center(
                    child: Text('수업을 불러오는 중 오류가 발생했습니다.'),
                  );
                },
                data: (reserveCourseList) {
                  if (reserveCourseList == null || reserveCourseList.isEmpty) {
                    return const Center(
                      child: Text('선택한 날짜에 수업이 없습니다.'),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: reserveCourseList.length,
                    itemBuilder: (context, index) {
                      final courseData = reserveCourseList[index];
                      final lessonData = courseData['lesson'];
                      final dancerData = lessonData['dancer'];

                      return CourseListItem(
                        courseData: courseData,
                        lessonData: lessonData,
                        dancerData: dancerData,
                        onTap: () => navigateToLessonDetail(lessonData['id']),
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

class CourseListItem extends StatelessWidget {
  const CourseListItem({
    super.key,
    required this.courseData,
    required this.lessonData,
    required this.dancerData,
    required this.onTap,
  });

  final Map<String, dynamic> courseData;
  final Map<String, dynamic> lessonData;
  final Map<String, dynamic> dancerData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final courseDate = courseData['course_date'];
    final courseTitle = courseData['title'];
    final courseStartTime = courseData['start_time'];
    final courseEndTime = courseData['end_time'];

    final lessonImage = lessonData['image_url'];
    final lessonTitle = lessonData['title'];

    final dancerNickname = dancerData['nickname'];
    final dancerEmail = dancerData['email'];
    final dancerImageUrl = dancerData['image_url'];

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                lessonImage ?? 'assets/images/app_logo/2x.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/app_logo/2x.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: (dancerImageUrl.isNotEmpty &&
                                dancerImageUrl.startsWith('https'))
                            ? NetworkImage(dancerImageUrl)
                            : const AssetImage(
                                    'assets/images/app_logo/chat.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6555FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  dancerNickname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              dancerEmail,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$courseDate, $courseTitle',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$courseStartTime - $courseEndTime',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
