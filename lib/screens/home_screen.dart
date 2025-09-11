import 'package:dancemate_app/provider/calendar_provider.dart';
import 'package:dancemate_app/provider/chat_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/main_tap_provider.dart';
import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/chat_room_screen.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:dancemate_app/screens/notification_screen.dart';
import 'package:dancemate_app/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(getHomeProvider);

    final dateFormat = DateFormat('yyyy-MM-dd');
    final selectDay = ref.watch(selectDateProvider);

    void onLikeTap(int courseId) async {
      final result = await ref.refresh(postLessonLikeProvider(courseId).future);
      if (result['result_code'] == 200) {
        ref.refresh(getHomeProvider);
        ref.refresh(getSearchPreProvider);
        ref.refresh(getChatRoomProvider(1));
        ref.refresh(getChatRoomProvider(50));
        ref.refresh(getLessonProvider(dateFormat.format(selectDay)));
        ref.refresh(getLessonLikeProvider);
      } else {
        print('like fail');
      }
    }

    void onDancerTap(int userId, int loginUserId) {
      if (userId != loginUserId) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(
              userId: userId,
            ),
          ),
        );
      } else {
        ref.read(mainTapProvider.notifier).update((state) => 4);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    }

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(courseId: courseId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatRoomScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.send_outlined,
              size: 27,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.notifications_outlined,
              size: 27,
            ),
          ),
          const SizedBox(width: 17),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  homeData.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) {
                      ref.refresh(getHomeProvider.future);
                      return SizedBox(
                        width: 300,
                        child: Text('error: $error'),
                      );
                    },
                    data: (homeData) => SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeData['recommend_users'].length,
                        itemBuilder: (context, index) {
                          final userData = homeData['recommend_users'][index];
                          final loginUserId = homeData['login_user_id'];

                          final userId = userData['id'];
                          String imageUrl = userData['image_url'];
                          final nickname = userData['nickname'];

                          ImageProvider finalDancerImageProvider;
                          if (imageUrl != '') {
                            if (imageUrl.split(':')[0] == 'https') {
                              finalDancerImageProvider = NetworkImage(imageUrl);
                            } else {
                              finalDancerImageProvider = AssetImage(imageUrl);
                            }
                          } else {
                            // 기본 이미지 경로 설정
                            imageUrl = 'assets/images/app_logo/chat.png';
                            finalDancerImageProvider = AssetImage(imageUrl);
                          }
                          return GestureDetector(
                            onTap: () {
                              onDancerTap(userId, loginUserId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      foregroundImage: finalDancerImageProvider,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(nickname),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Text(
                    '오늘 들을 수 있는 수업',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  homeData.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) {
                      ref.refresh(getHomeProvider.future);
                      print(error);

                      return SizedBox(
                        width: 300,
                        child: Text('error: $error'),
                      );
                    },
                    data: (homeData) {
                      if (homeData == null) {
                        return Container();
                      }
                      return SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: homeData['today_lessons'].length,
                          itemBuilder: (context, index) {
                            final todayCoursesData =
                                homeData['today_lessons'][index];

                            final dancerData = todayCoursesData['dancer'];
                            final dancerNickname = dancerData['nickname'];
                            String dancerImageUrl = dancerData['image_url'];

                            String lessonImageUrl =
                                todayCoursesData['image_url'] ?? '';
                            final courseDetailData =
                                todayCoursesData['course'][0];
                            final courseStartTime =
                                courseDetailData['start_time'];
                            final courseEndTime = courseDetailData['end_time'];
                            final courseTitle = courseDetailData['title'];
                            // bool isCourseLike = todayCoursesData['is_like'];

                            ImageProvider finalDancerImageProvider;
                            if (dancerImageUrl != '') {
                              if (dancerImageUrl.split(':')[0] == 'https') {
                                finalDancerImageProvider =
                                    NetworkImage(dancerImageUrl);
                              } else {
                                finalDancerImageProvider =
                                    AssetImage(dancerImageUrl);
                              }
                            } else {
                              // 기본 이미지 경로 설정
                              dancerImageUrl =
                                  'assets/images/app_logo/chat.png';
                              finalDancerImageProvider =
                                  AssetImage(dancerImageUrl);
                            }

                            Image finalLessonImageProvider;
                            if (lessonImageUrl != '') {
                              if (lessonImageUrl.split(':')[0] == 'https') {
                                finalLessonImageProvider = Image.network(
                                  width: 170,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  todayCoursesData['image_url'],
                                );
                              } else {
                                finalLessonImageProvider = Image.asset(
                                  width: 170,
                                  height: 200,
                                  fit: BoxFit.fill,
                                  'assets/images/app_logo/2x.png',
                                );
                              }
                            } else {
                              // 기본 이미지 경로 설정
                              lessonImageUrl = 'assets/images/app_logo/2x.png';
                              finalLessonImageProvider = Image.asset(
                                width: 170,
                                height: 200,
                                fit: BoxFit.fill,
                                'assets/images/app_logo/2x.png',
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                onCourseTap(todayCoursesData['id']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: finalLessonImageProvider,
                                        ),
                                        // Positioned(
                                        //   top: 5,
                                        //   left: 5,
                                        //   child: GestureDetector(
                                        //     onTap: () {
                                        //       onLikeTap(courseDetailData['id']);
                                        //     },
                                        //     child: Container(
                                        //       width: 40,
                                        //       height: 40,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(20),
                                        //         color: const Color(0xff9475FF),
                                        //       ),
                                        //       child: Icon(
                                        //         isCourseLike
                                        //             ? Icons.favorite
                                        //             : Icons.favorite_border,
                                        //         color: Colors.white,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          foregroundImage:
                                              finalDancerImageProvider,
                                        ),
                                        const SizedBox(width: 5),
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
                                      ],
                                    ),
                                    Text(
                                      todayCoursesData['title'],
                                      style: const TextStyle(
                                        color: Color(0xff3F51B5),
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '$courseTitle, $courseStartTime - $courseEndTime',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Text(
                    '예약한 수업',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  homeData.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) {
                      ref.refresh(getHomeProvider.future);
                      print(error);
                      return SizedBox(
                        width: 300,
                        child: Text('error: $error'),
                      );
                    },
                    data: (homeData) {
                      if (homeData == null) {
                        return Container();
                      } else if (homeData['reserve_lessons'].length == 0) {
                        return const Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              '예약한 수업이 없네요',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '배우러 가볼까요?',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox(
                        height: 400,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeData['reserve_lessons'].length,
                          itemBuilder: (context, index) {
                            final reserveCourseData =
                                homeData['reserve_lessons'][index];

                            final dancerData =
                                reserveCourseData['lesson']['dancer'];
                            final dancerNickname = dancerData['nickname'];
                            final dancerEmail = dancerData['email'];
                            String dancerImageUrl = dancerData['image_url'];

                            final courseDetailData = reserveCourseData;
                            final courseDetailDate =
                                courseDetailData['course_date'];
                            final courseStartTime =
                                courseDetailData['start_time'];
                            final courseEndTime = courseDetailData['end_time'];
                            final courseDetailTitle = courseDetailData['title'];
                            // bool isCourseLike =
                            //     reserveCourseData['lesson']['is_like'];

                            final courseData = reserveCourseData['lesson'];
                            String courseImage = courseData['image_url'];
                            final courseTitle = courseData['title'];

                            ImageProvider finalDancerImageProvider;
                            if (dancerImageUrl != '') {
                              if (dancerImageUrl.split(':')[0] == 'https') {
                                finalDancerImageProvider =
                                    NetworkImage(dancerImageUrl);
                              } else {
                                finalDancerImageProvider =
                                    AssetImage(dancerImageUrl);
                              }
                            } else {
                              // 기본 이미지 경로 설정
                              dancerImageUrl =
                                  'assets/images/app_logo/chat.png';
                              finalDancerImageProvider =
                                  AssetImage(dancerImageUrl);
                            }

                            Image finalLessonImageProvider;
                            if (courseImage != '') {
                              if (courseImage.split(':')[0] == 'https') {
                                finalLessonImageProvider = Image.network(
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  courseImage,
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
                              // 기본 이미지 경로 설정
                              courseImage = 'assets/images/app_logo/2x.png';
                              finalLessonImageProvider = Image.asset(
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                                'assets/images/app_logo/2x.png',
                              );
                            }

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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: finalLessonImageProvider,
                                        ),
                                        // Positioned(
                                        //   top: 5,
                                        //   left: 5,
                                        //   child: GestureDetector(
                                        //     onTap: () {
                                        //       onLikeTap(
                                        //           reserveCourseData['id']);
                                        //     },
                                        //     child: Container(
                                        //       width: 30,
                                        //       height: 30,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(20),
                                        //         color: const Color(0xff9475FF),
                                        //       ),
                                        //       child: Icon(
                                        //         isCourseLike
                                        //             ? Icons.favorite
                                        //             : Icons.favorite_border,
                                        //         color: Colors.white,
                                        //         size: 20,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              foregroundImage:
                                                  finalDancerImageProvider,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff6555FF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                                        const SizedBox(height: 5),
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
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
