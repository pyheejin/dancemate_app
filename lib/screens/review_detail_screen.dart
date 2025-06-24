import 'package:dancemate_app/provider/course_detail_provider.dart';
import 'package:dancemate_app/provider/review_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDetailScreen extends ConsumerWidget {
  final int reviewId;

  const ReviewDetailScreen({
    super.key,
    required this.reviewId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewData = ref.watch(getReviewDetailProvider(reviewId));
    final TextEditingController descriptionController = TextEditingController();
    double lessonRate = ref.watch(lessonReviewRateProvider);

    void onSaveTap() async {
      final bodyData = {
        'rate': lessonRate,
        'description': descriptionController.text,
      };

      final result = await ref
          .read(lessonDetailReviewProvider.notifier)
          .updateReview(reviewId, bodyData);

      if (result != null) {
        if (result['result_code'] == 200) {
          ref.refresh(getReviewDetailProvider(reviewId));
          Navigator.pop(context);
        } else {
          errorAlert(context, result['result_msg']);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('수강 후기'),
      ),
      body: reviewData.when(
        data: (reviewDetail) {
          final satisfaction = reviewDetail['satisfaction'];
          final description = reviewDetail['description'];

          descriptionController.text = description;

          final lessonData = reviewDetail['lesson'];
          final lessonTitle = lessonData['title'];
          final lessonImage = lessonData['image_url'];

          final courseData = reviewDetail['user_course']['course'];
          final courseDate = courseData['course_date'];
          final courseStartTime = courseData['start_time'];
          final courseEndTime = courseData['end_time'];
          final courseTitle = courseData['title'];

          final dancerData = lessonData['dancer'];
          final dancerNickname = dancerData['nickname'];
          final dancerEmail = dancerData['email'];
          final dancerImageUrl = dancerData['image_url'];
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              children: [
                Row(
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
                                    foregroundImage:
                                        NetworkImage(dancerImageUrl),
                                  )
                                : CircleAvatar(
                                    foregroundImage: AssetImage(dancerImageUrl),
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
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                RatingBar.builder(
                  initialRating: satisfaction,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  unratedColor: Colors.black26,
                  itemSize: 50,
                  itemCount: 5,
                  itemBuilder: (context, _) {
                    return const Icon(
                      Icons.star,
                      color: Color(0xFFA48AFF),
                    );
                  },
                  onRatingUpdate: (rating) {
                    // save 동작 필요함
                    lessonRate = rating;
                  },
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFA48AFF),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '사진추가',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff3F51B5),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '최대 5장',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
            onPressed: onSaveTap,
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
                    '수정하기',
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
