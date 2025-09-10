import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LikeCourseScreen extends ConsumerStatefulWidget {
  const LikeCourseScreen({super.key});

  @override
  ConsumerState<LikeCourseScreen> createState() => _LikeCourseScreenState();
}

class _LikeCourseScreenState extends ConsumerState<LikeCourseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseData = ref.watch(getCourseLikeProvider);

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(courseId: courseId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('찜한 수업'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: courseData.when(
          data: (courseList) {
            if (courseList['courses'].isEmpty) {
              return const Center(child: Text('찜한 수업이 없습니다.'));
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: courseList['courses'].length,
              itemBuilder: (context, index) {
                final courseDetailData = courseList['courses'][index];
                final courseDetailTitle = courseDetailData['title'];
                final courseDetailDate = courseDetailData['course_date'];
                final courseDetailStartTime = courseDetailData['start_time'];
                final courseDetailEndTime = courseDetailData['end_time'];

                final courseData = courseDetailData['lesson'];
                final courseTitle = courseData['title'];
                String courseImage = courseData['image_url'] ?? '';

                final dancerData = courseData['dancer'];
                final dancerNickname = dancerData['nickname'];
                final dancerEmail = dancerData['email'];
                final dancerImageUrl = dancerData['image_url'];

                Image finalLessonImageProvider;
                if (courseImage != '') {
                  if (courseImage.split(':')[0] == 'https') {
                    finalLessonImageProvider = Image.network(
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      courseImage,
                    );
                  } else {
                    finalLessonImageProvider = Image.asset(
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                      'assets/images/app_logo/2x.png',
                    );
                  }
                } else {
                  courseImage = 'assets/images/app_logo/2x.png';
                  finalLessonImageProvider = Image.asset(
                    width: 120,
                    height: 120,
                    fit: BoxFit.fill,
                    'assets/images/app_logo/2x.png',
                  );
                }
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    final result = await ref.watch(
                        postCourseLikeProvider(courseDetailData['id']).future);
                    if (result['result_code'] == 200) {
                      final dateFormat = DateFormat('yyyy-MM-dd');
                      final selectDay = ref.watch(selectDateProvider);
                      final selectMonth = ref.watch(selectMonthProvider);

                      ref.refresh(getHomeProvider);
                      ref.refresh(getSearchPreProvider);
                      ref.refresh(getChatRoomProvider(1));
                      ref.refresh(getChatRoomProvider(50));
                      ref.refresh(
                          getLessonProvider(dateFormat.format(selectDay)));
                      ref.refresh(getCourseLikeProvider);
                      ref.watch(getCalendarLessonProvider(selectMonth));
                    } else {
                      print('delete fail');
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '삭제',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      onCourseTap(courseData['id']);
                    },
                    onLongPress: () async {
                      final result = await ref.watch(
                          postCourseLikeProvider(courseData['id']).future);
                      print(result['result_code']);
                      if (result['result_code'] == 200) {
                        ref.refresh(getCourseLikeProvider);
                      } else {
                        print('delete fail');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: finalLessonImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  dancerImageUrl == ''
                                      ? const CircleAvatar(
                                          foregroundImage: AssetImage(
                                              'assets/images/app_logo/chat.png'),
                                        )
                                      : dancerImageUrl.split(':')[0] == 'https'
                                          ? CircleAvatar(
                                              foregroundImage:
                                                  NetworkImage(dancerImageUrl),
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
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                '$courseDetailDate $courseDetailTitle',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '$courseDetailStartTime - $courseDetailEndTime',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            return SizedBox(
              width: 300,
              child: Text('search error: $error'),
            );
          },
        ),
      ),
    );
  }
}
