import 'package:dancemate_app/provider/course_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewScreen extends ConsumerWidget {
  final int courseDetailId;

  const ReviewScreen({
    super.key,
    required this.courseDetailId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailData = ref.watch(getCourseDetailProvider(courseDetailId));
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('수강 후기'),
      ),
      body: courseDetailData.when(
        data: (courseDetail) {
          final courseData = courseDetail['course'];
          final courseTitle = courseData['title'];
          final courseImage = courseData['image_url'];

          final courseDetailDate = courseDetail['course_date'];
          final courseStartTime = courseDetail['start_time'];
          final courseEndTime = courseDetail['end_time'];
          final courseDetailTitle = courseDetail['title'];

          final dancerData = courseData['dancer'];
          final dancerNickname = dancerData['nickname'];
          final dancerEmail = dancerData['email'];
          final dancerImageUrl = dancerData['image_url'];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
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
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey.shade400,
                  )),
                  child: const Row(
                    children: [
                      Text('사진추가'),
                      Text('최대 5장'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    controller: descriptionController,
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '리뷰 작성하기',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    '저장하기',
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
