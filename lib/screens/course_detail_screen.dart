import 'package:dancemate_app/provider/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailScreen extends ConsumerWidget {
  final int courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailData = ref.watch(getCourseDetailProvider(courseId));

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
              final courseTitle = courseDetail['title'];
              final courseImageUrl = courseDetail['image_url'];
              final courseDescription = courseDetail['description'];

              final dancerData = courseDetail['dancer'];
              final dancerEmail = dancerData['email'];
              final dancerNickname = dancerData['nickname'];
              final dancerImageUrl = dancerData['image_url'];

              final courseDetailList = courseDetail['course_detail'];
              return Column(
                children: [
                  const SizedBox(height: 40),
                  Image.network(
                    width: 430,
                    height: 270,
                    fit: BoxFit.fitWidth,
                    courseImageUrl,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
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
                        const SizedBox(height: 10),
                        Text(
                          courseTitle,
                          style: const TextStyle(
                            color: Color(0xff3F51B5),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: courseDetailList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 30,
                                            ),
                                            child: Text(
                                              courseDetailList[index]
                                                  ['course_date'],
                                              style: const TextStyle(
                                                color: Color(0xff3F51B5),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff3F51B5),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              courseDetailList[index]['title'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff3F51B5),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  courseDetailList[index]
                                                      ['address'],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  color: Color(0xFFA48AFF),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(courseDescription),
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
