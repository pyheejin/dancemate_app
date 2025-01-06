import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const storage = FlutterSecureStorage();

    final recommendUsers = ref.watch(getHomeRecommendUserProvider);
    final todayCourses = ref.watch(getHomeTodayCourseProvider);
    final reserveCourses = ref.watch(getHomeReserveCourseProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () async {
              await storage.delete(key: 'login');

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('로그아웃'),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.send_outlined,
            size: 27,
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.notifications_outlined,
            size: 27,
          ),
          const SizedBox(width: 17),
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
                      recommendUsers.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) {
                          ref.refresh(getHomeRecommendUserProvider.future);
                          return SizedBox(
                            width: 300,
                            child: Text('error: $error'),
                          );
                        },
                        data: (recommendUserList) => SizedBox(
                          width: 390,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendUserList.length,
                            itemBuilder: (context, index) {
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
                                          recommendUserList[index].imageUrl,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(recommendUserList[index].nickname),
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
              child: todayCourses.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  ref.refresh(getHomeTodayCourseProvider.future);
                  print(error);

                  return SizedBox(
                    width: 300,
                    child: Text('error: $error'),
                  );
                },
                data: (todayCourseList) => SizedBox(
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: todayCourseList.length,
                    itemBuilder: (context, index) {
                      final dancerData = todayCourseList[index].dancer;
                      final dancerNickname = dancerData['nickname'];
                      final dancerEmail = dancerData['email'];
                      final dancerImageUrl = dancerData['image_url'];

                      final courseDetailData =
                          todayCourseList[index].courseDetail[0];
                      final courseDate = courseDetailData['course_date'];
                      final courseTitle = courseDetailData['title'];
                      return GestureDetector(
                        onTap: () {},
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
                                    todayCourseList[index].imageUrl,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff9475FF),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
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
                                todayCourseList[index].title,
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
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: reserveCourses.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  ref.refresh(getHomeReserveCourseProvider.future);
                  print(error);
                  return SizedBox(
                    width: 300,
                    child: Text('error: $error'),
                  );
                },
                data: (reserveCourseList) => SizedBox(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: reserveCourseList.length,
                    itemBuilder: (context, index) {
                      final dancerData = reserveCourseList[index].dancer;
                      final dancerNickname = dancerData['nickname'];
                      final dancerEmail = dancerData['email'];
                      final dancerImageUrl = dancerData['image_url'];

                      final courseDetailData =
                          reserveCourseList[index].courseDetail[0];
                      final courseDate = courseDetailData['course_date'];
                      final courseTitle = courseDetailData['title'];
                      return GestureDetector(
                        onTap: () {},
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
                                  Image.network(
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    reserveCourseList[index].imageUrl,
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 10,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff9475FF),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
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
                                    reserveCourseList[index].title,
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
