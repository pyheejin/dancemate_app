import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/main_tap_provider.dart';
import 'package:dancemate_app/screens/chat_room_screen.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:dancemate_app/screens/notification_screen.dart';
import 'package:dancemate_app/screens/user_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(getHomeProvider);

    void onDancerTap(int userId, int loginUserId) {
      if (userId != loginUserId) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(userId: userId),
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
                          final imageUrl = userData['image_url'];
                          final nickname = userData['nickname'];
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
                                    child: imageUrl == ''
                                        ? const CircleAvatar(
                                            radius: 50,
                                            foregroundImage: AssetImage(
                                                'assets/images/app_logo/chat.png'),
                                          )
                                        : imageUrl.split(':')[0] == 'https'
                                            ? CircleAvatar(
                                                radius: 50,
                                                foregroundImage:
                                                    NetworkImage(imageUrl),
                                                child: Text(nickname),
                                              )
                                            : CircleAvatar(
                                                foregroundImage: AssetImage(
                                                  imageUrl,
                                                ),
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
                            final dancerImageUrl = dancerData['image_url'];

                            final courseDetailData =
                                todayCoursesData['course'][0];
                            final courseDate = courseDetailData['course_date'];
                            final courseStartTime =
                                courseDetailData['start_time'];
                            final courseEndTime = courseDetailData['end_time'];
                            final courseTitle = courseDetailData['title'];
                            bool isCourseLike = courseDetailData['is_like'];
                            return GestureDetector(
                              onTap: () {
                                onCourseTap(todayCoursesData['id']);
                              },
                              onDoubleTap: () async {
                                final result = await ref.watch(
                                    postCourseLikeProvider(
                                            todayCoursesData['id'])
                                        .future);
                                print(result['result_code']);
                                if (result['result_code'] == 200) {
                                  ref.refresh(getHomeProvider);
                                  print('찜');
                                } else {
                                  print('like fail');
                                }
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
                                        todayCoursesData['image_url'] == null
                                            ? Image.asset(
                                                width: 170,
                                                height: 200,
                                                fit: BoxFit.fill,
                                                'assets/images/app_logo/2x.png',
                                              )
                                            : Image.network(
                                                width: 170,
                                                height: 200,
                                                fit: BoxFit.cover,
                                                todayCoursesData['image_url'],
                                              ),
                                        // Positioned(
                                        //   top: 5,
                                        //   left: 5,
                                        //   child: GestureDetector(
                                        //     onTap: () {
                                        //       print('is click?');
                                        //       ref.watch(postCourseLikeProvider(
                                        //           todayCoursesData['id']));
                                        //       // print(result.value!['result_code']);
                                        //       // if (result['result_code'] == 200) {
                                        //       //   ref.refresh(getHomeProvider);
                                        //       // } else {
                                        //       //   print('like fail');
                                        //       // }
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
                                        dancerImageUrl == ''
                                            ? const CircleAvatar(
                                                foregroundImage: AssetImage(
                                                    'assets/images/app_logo/chat.png'),
                                              )
                                            : dancerImageUrl.split(':')[0] ==
                                                    'https'
                                                ? CircleAvatar(
                                                    foregroundImage:
                                                        NetworkImage(
                                                            dancerImageUrl),
                                                  )
                                                : CircleAvatar(
                                                    foregroundImage: AssetImage(
                                                        dancerImageUrl),
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
                            final dancerImageUrl = dancerData['image_url'];

                            final courseDetailData = reserveCourseData;
                            final courseDetailDate =
                                courseDetailData['course_date'];
                            final courseStartTime =
                                courseDetailData['start_time'];
                            final courseEndTime = courseDetailData['end_time'];
                            final courseDetailTitle = courseDetailData['title'];
                            bool isCourseLike = courseDetailData['is_like'];

                            final courseData = reserveCourseData['lesson'];
                            final courseImage = courseData['image_url'];
                            final courseTitle = courseData['title'];

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
                                        GestureDetector(
                                          onDoubleTap: () async {
                                            final result = await ref.watch(
                                                postCourseLikeProvider(
                                                        courseData['id'])
                                                    .future);
                                            if (result['result_code'] == 200) {
                                              ref.refresh(getHomeProvider);
                                            } else {
                                              print('like fail');
                                            }
                                          },
                                          child: courseImage == null
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
                                        ),
                                        Positioned(
                                          top: 5,
                                          left: 5,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final result = await ref.watch(
                                                  postCourseLikeProvider(
                                                          courseData['id'])
                                                      .future);
                                              if (result['result_code'] ==
                                                  200) {
                                                ref.refresh(getHomeProvider);
                                              } else {
                                                print('like fail');
                                              }
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xff9475FF),
                                              ),
                                              child: Icon(
                                                isCourseLike
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            dancerImageUrl == ''
                                                ? const CircleAvatar(
                                                    foregroundImage: AssetImage(
                                                        'assets/images/app_logo/chat.png'),
                                                  )
                                                : dancerImageUrl
                                                            .split(':')[0] ==
                                                        'https'
                                                    ? CircleAvatar(
                                                        foregroundImage:
                                                            NetworkImage(
                                                                dancerImageUrl),
                                                      )
                                                    : CircleAvatar(
                                                        foregroundImage:
                                                            AssetImage(
                                                                dancerImageUrl),
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
