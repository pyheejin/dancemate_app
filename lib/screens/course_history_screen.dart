import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:dancemate_app/screens/review_detail_screen.dart';
import 'package:dancemate_app/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseHistoryScreen extends ConsumerWidget {
  const CourseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseData = ref.watch(getUserCourseProvider);

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(courseId: courseId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('수업 수강 내역'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: courseData.when(
          data: (courseList) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: courseList['courses'].length,
              itemBuilder: (context, index) {
                if (courseList['courses'].isEmpty) {
                  return Container();
                }
                final courseData = courseList['courses'][index];
                final courseDate = courseData['course_date'];
                final courseStartTime = courseData['start_time'];
                final courseEndTime = courseData['end_time'];
                final courseTitle = courseData['title'];

                final userCourseData = courseData['user_course'][0];
                final userCourseId = userCourseData['id'];
                final reviewData = userCourseData['review'];

                final lessonData = courseData['lesson'];
                final lessonTitle = lessonData['title'];
                String lessonImage = lessonData['image_url'];

                final dancerData = lessonData['dancer'];
                final dancerNickname = dancerData['nickname'];
                final dancerEmail = dancerData['email'];
                final dancerImageUrl = dancerData['image_url'];

                Image finalLessonImageProvider;
                if (lessonImage != '') {
                  if (lessonImage.split(':')[0] == 'https') {
                    finalLessonImageProvider = Image.network(
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      lessonImage,
                    );
                  } else {
                    finalLessonImageProvider = Image.asset(
                      width: 110,
                      height: 110,
                      fit: BoxFit.fill,
                      'assets/images/app_logo/2x.png',
                    );
                  }
                } else {
                  // 기본 이미지 경로 설정
                  lessonImage = 'assets/images/app_logo/2x.png';
                  finalLessonImageProvider = Image.asset(
                    width: 110,
                    height: 110,
                    fit: BoxFit.fill,
                    'assets/images/app_logo/2x.png',
                  );
                }
                return GestureDetector(
                  onTap: () {
                    onCourseTap(lessonData['id']);
                  },
                  onLongPress: () async {
                    final result = await ref
                        .watch(postCourseLikeProvider(courseData['id']).future);
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
                      // horizontal: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                        : dancerImageUrl.split(':')[0] ==
                                                'https'
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
                                        // Text(
                                        //   dancerEmail,
                                        //   style: const TextStyle(
                                        //     fontSize: 16,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 5),
                                Text(
                                  lessonTitle,
                                  style: const TextStyle(
                                    color: Color(0xff3F51B5),
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  '$courseDate $courseTitle',
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              reviewData.length == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ReviewScreen(
                                              courseId: courseData['id'],
                                              userCourseId: userCourseId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff9475FF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            '수강 후기',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReviewDetailScreen(
                                              reviewId: reviewData[0]['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff9475FF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            '후기 수정',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
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
      ),
    );
  }
}
