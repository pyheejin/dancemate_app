import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LikeCourseScreen extends ConsumerStatefulWidget {
  const LikeCourseScreen({super.key});

  @override
  ConsumerState<LikeCourseScreen> createState() => _LikeCourseScreenState();
}

class _LikeCourseScreenState extends ConsumerState<LikeCourseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonData = ref.watch(getLessonLikeProvider);

    void onLessonTap(int lessonId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(lessonId: lessonId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('찜한 수업'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: lessonData.when(
          data: (lessonList) {
            if (lessonList['lessons'].isEmpty) {
              return const Center(child: Text('찜한 수업이 없습니다.'));
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: lessonList['lessons'].length,
              itemBuilder: (context, index) {
                final lessonData = lessonList['lessons'][index];
                final lessonTitle = lessonData['title'];
                String lessonImage = lessonData['image_url'] ?? '';

                final dancerData = lessonData['dancer'];
                final dancerNickname = dancerData['nickname'];
                final dancerEmail = dancerData['email'];
                final dancerImageUrl = dancerData['image_url'];

                Image finalLessonImageProvider;
                if (lessonImage != '') {
                  if (lessonImage.split(':')[0] == 'https') {
                    finalLessonImageProvider = Image.network(
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      lessonImage,
                    );
                  } else {
                    finalLessonImageProvider = Image.asset(
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                      'assets/images/app_logo/2x.png',
                    );
                  }
                } else {
                  lessonImage = 'assets/images/app_logo/2x.png';
                  finalLessonImageProvider = Image.asset(
                    width: 120,
                    height: 120,
                    fit: BoxFit.fill,
                    'assets/images/app_logo/2x.png',
                  );
                }
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    final result = await ref
                        .watch(postLessonLikeProvider(lessonData['id']).future);
                    if (result['result_code'] == 200) {
                      final dateFormat = DateFormat('yyyy-MM-dd');
                      final selectDay = ref.watch(selectDateProvider);
                      final selectMonth = ref.watch(selectMonthProvider);

                      ref.refresh(getHomeProvider);
                      ref.refresh(getSearchPreProvider);
                      ref.refresh(getChatRoomProvider(1));
                      ref.refresh(getChatRoomProvider(50));
                      ref.refresh(
                          getLessonProvider(dateFormat.format(selectDay)));
                      ref.refresh(getLessonLikeProvider);
                      ref.watch(getCalendarLessonProvider(selectMonth));
                    } else {
                      print('delete fail');
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '삭제',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      onLessonTap(lessonData['id']);
                    },
                    onLongPress: () async {
                      final result = await ref.watch(
                          postLessonLikeProvider(lessonData['id']).future);
                      print(result['result_code']);
                      if (result['result_code'] == 200) {
                        ref.refresh(getLessonLikeProvider);
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
                                      : dancerImageUrl.split(':')[0] == 'https'
                                          ? CircleAvatar(
                                              foregroundImage:
                                                  NetworkImage(dancerImageUrl),
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
                              // Text(
                              //   '$lessonDate $lessonTitle',
                              //   style: const TextStyle(
                              //     fontSize: 15,
                              //   ),
                              // ),
                              // Text(
                              //   '$lessonStartTime - $lessonEndTime',
                              //   style: const TextStyle(
                              //     fontSize: 15,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
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
