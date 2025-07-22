import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:dancemate_app/screens/dancer_course_detail_create_screen.dart';
import 'package:dancemate_app/screens/dancer_course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DancerCourseScreen extends ConsumerWidget {
  const DancerCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonData = ref.watch(getDancerLessonProvider);

    void onLessonTap(int lessonId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DancerCourseDetailScreen(lessonId: lessonId),
        ),
      );
      ref.read(oldDancerCourseProvider.notifier).addCourseDetailList(lessonId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('수업 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          // vertical: 10,
          horizontal: 10,
        ),
        child: lessonData.when(
          data: (lessonList) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: lessonList['lessons'].length,
              itemBuilder: (context, index) {
                if (lessonList['lessons'].isEmpty) {
                  return Container();
                }
                final lessonData = lessonList['lessons'][index];
                final courseTitle = lessonData['title'];
                final courseImage = lessonData['image_url'];
                return GestureDetector(
                  onTap: () {
                    onLessonTap(lessonData['id']);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA48AFF),
        elevation: 0.5,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DancerCourseDetailCreateScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white24,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 30),
      //     child: TextButton(
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (context) => const DancerCourseDetailCreateScreen(),
      //           ),
      //         );
      //       },
      //       style: TextButton.styleFrom(
      //         backgroundColor: const Color(0xFFA48AFF),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(5),
      //         ),
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.symmetric(
      //           vertical: 3,
      //           horizontal: 15,
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               '추가하기',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
