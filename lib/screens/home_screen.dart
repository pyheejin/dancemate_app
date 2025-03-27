import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(getHomeProvider);

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(courseId: courseId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          Icon(
            Icons.send_outlined,
            size: 27,
          ),
          SizedBox(width: 5),
          Icon(
            Icons.notifications_outlined,
            size: 27,
          ),
          SizedBox(width: 17),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
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
                          width: 390,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeData['recommend_users'].length,
                            itemBuilder: (context, index) {
                              final userData =
                                  homeData['recommend_users'][index];

                              final imageUrl = userData['image_url'];
                              final nickname = userData['nickname'];
                              return Padding(
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
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          imageUrl,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(nickname),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: homeData.when(
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
                      itemCount: homeData['today_courses'].length,
                      itemBuilder: (context, index) {
                        final todayCoursesData =
                            homeData['today_courses'][index];

                        final dancerData = todayCoursesData['dancer'];
                        final dancerNickname = dancerData['nickname'];
                        final dancerEmail = dancerData['email'];
                        final dancerImageUrl = dancerData['image_url'];

                        final courseDetailData =
                            todayCoursesData['course_detail'][0];
                        final courseDate = courseDetailData['course_date'];
                        final courseTitle = courseDetailData['title'];
                        bool isCourseLike = todayCoursesData['is_like'];
                        return GestureDetector(
                          onTap: () {
                            onCourseTap(todayCoursesData['id']);
                          },
                          onDoubleTap: () async {
                            final result = await ref.watch(
                                postCourseLikeProvider(todayCoursesData['id'])
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      width: 170,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      todayCoursesData['image_url'],
                                    ),
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          print('is click?');
                                          ref.watch(postCourseLikeProvider(
                                              todayCoursesData['id']));
                                          // print(result.value!['result_code']);
                                          // if (result['result_code'] == 200) {
                                          //   ref.refresh(getHomeProvider);
                                          // } else {
                                          //   print('like fail');
                                          // }
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
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        dancerImageUrl,
                                      ),
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
                                Text(
                                  todayCoursesData['title'],
                                  style: const TextStyle(
                                    color: Color(0xff3F51B5),
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '$courseDate $courseTitle',
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
            ),
            SliverToBoxAdapter(
              child: homeData.when(
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
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: homeData['reserve_courses'].length,
                      itemBuilder: (context, index) {
                        final reserveCourseData =
                            homeData['reserve_courses'][index];

                        final dancerData =
                            reserveCourseData['course']['dancer'];
                        final dancerNickname = dancerData['nickname'];
                        final dancerEmail = dancerData['email'];
                        final dancerImageUrl = dancerData['image_url'];

                        final courseDetailData = reserveCourseData;
                        final courseDetailDate =
                            courseDetailData['course_date'];
                        final courseDetailTitle = courseDetailData['title'];

                        final courseData = reserveCourseData['course'];
                        final courseImage = courseData['image_url'];
                        final courseTitle = courseData['title'];
                        bool isCourseLike = courseData['is_like'];
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
                                      child: Image.network(
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
                                          if (result['result_code'] == 200) {
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '$courseDetailDate $courseDetailTitle',
                                      style: const TextStyle(
                                        fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }
}
