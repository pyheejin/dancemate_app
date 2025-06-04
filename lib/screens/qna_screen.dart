import 'package:dancemate_app/provider/course_detail_provider.dart';
import 'package:dancemate_app/provider/review_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QnaScreen extends ConsumerWidget {
  const QnaScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    void onSaveTap() async {
      final bodyData = {
        'email': emailController.text,
        'question': descriptionController.text,
      };

      // final result = await ref
      //     .read(lessonDetailReviewProvider.notifier)
      //     .saveReview(bodyData);

      // if (result != null) {
      //   if (result['result_code'] == 200) {
      //     ref.refresh(getUserCourseProvider);
      //     Navigator.pop(context);
      //   } else {
      //     errorAlert(context, result['result_msg']);
      //   }
      // }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('문의하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                controller: descriptionController,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '이메일',
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
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: TextField(
                controller: descriptionController,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '제목',
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
            const SizedBox(height: 10),
            Expanded(
              flex: 10,
              child: TextField(
                controller: descriptionController,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '문의 작성하기',
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
