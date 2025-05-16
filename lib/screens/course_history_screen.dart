import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
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
          builder: (context) => CourseDetailScreen(courseId: courseId),
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
                  return null;
                }
                final courseData = courseList['courses'][index];
                final courseTitle = courseData['title'];
                final courseImage = courseData['image_url'];

                final courseDetailData = courseData['course_detail'][0];
                final courseDetailDate = courseDetailData['course_date'];
                final courseStartTime = courseDetailData['start_time'];
                final courseEndTime = courseDetailData['end_time'];
                final courseDetailTitle = courseDetailData['title'];

                final dancerData = courseData['dancer'];
                final dancerNickname = dancerData['nickname'];
                final dancerEmail = dancerData['email'];
                final dancerImageUrl = dancerData['image_url'];
                return GestureDetector(
                  onTap: () {
                    onCourseTap(courseData['id']);
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
                      horizontal: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            courseImage == null
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
                                    courseImage,
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
                                const SizedBox(height: 10),
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
                                  '$courseStartTime - $courseEndTime',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(
                                    courseDetailId: courseDetailData['id']),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff9475FF),
                              borderRadius: BorderRadius.circular(10),
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
