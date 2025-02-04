import 'package:dancemate_app/provider/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailScreen extends ConsumerWidget {
  final int courseDetailId;

  const CourseDetailScreen({
    super.key,
    required this.courseDetailId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailData = ref.watch(getCourseDetailProvider(courseDetailId));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 0,
        ),
        child: SingleChildScrollView(
          child: courseDetailData.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) {
              print(error);
              return SizedBox(
                width: 300,
                child: Text('error: $error'),
              );
            },
            data: (courseDetail) {
              final courseData = courseDetail['course'];
              final courseTitle = courseData['title'];

              final dancerData = courseData['dancer'];
              final dancerEmail = dancerData['email'];
              final dancerNickname = dancerData['nickname'];
              final dancerImageUrl = dancerData['image_url'];
              return Column(
                children: [
                  const SizedBox(height: 40),
                  Image.network(
                    width: 430,
                    height: 270,
                    fit: BoxFit.fitWidth,
                    courseDetail['course']['image_url'],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
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
                                  '@$dancerEmail',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          courseTitle,
                          style: const TextStyle(
                            color: Color(0xff3F51B5),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFA48AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
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
