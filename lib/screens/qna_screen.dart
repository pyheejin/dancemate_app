import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dancemate_app/provider/qna_provider.dart';

class QnaScreen extends ConsumerWidget {
  const QnaScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qnaData = ref.watch(getQnaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('문의하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: qnaData.when(
          data: (qnaList) {
            return ListView.builder(
              shrinkWrap: true,
              itemExtent: 60,
              itemCount: qnaList['count'],
              itemBuilder: (context, index) {
                final qnas = qnaList['qnas'];

                if (qnas.isNotEmpty) {
                  final qnaDetail = qnas[index];

                  final title = qnaDetail['title'];
                  final question = qnaDetail['question'];
                  final isReply = qnaDetail['is_reply'];

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isReply == 0
                                ? Colors.black26
                                : const Color(0xFFA48AFF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            isReply == 1 ? const Text('답변완료') : const Text(''),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            print(error);
            return SizedBox(
              width: 300,
              child: Text('error: $error'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA48AFF),
        elevation: 0.5,
        shape: const CircleBorder(),
        onPressed: () {},
        child: Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: const Color(0xFFA48AFF)),
          //   borderRadius: BorderRadius.circular(25),
          // ),
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
