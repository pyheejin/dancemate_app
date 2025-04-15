import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:dancemate_app/screens/dancer_course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DancerCourseScreen extends ConsumerWidget {
  const DancerCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseData = ref.watch(getDancerCourseProvider);

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DancerCourseDetailScreen(courseId: courseId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('수업 관리'),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              courseImage,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              courseTitle,
                              style: const TextStyle(
                                color: Color(0xff3F51B5),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                            size: 30,
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
