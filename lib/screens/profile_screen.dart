import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/widgets/persistent_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const storage = FlutterSecureStorage();
    final userProfile = ref.watch(getUserProvider);

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(courseId: courseId),
        ),
      );
    }

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await storage.delete(key: 'login');

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 20,
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        userProfile.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) {
                            print(error);
                            return SizedBox(
                              width: 300,
                              child: Text('error: $error'),
                            );
                          },
                          data: (dataList) => CircleAvatar(
                            radius: 50,
                            foregroundImage:
                                NetworkImage(dataList['image_url']),
                            child: Text(dataList['nickname']),
                          ),
                        ),
                        const SizedBox(width: 10),
                        userProfile.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) {
                            print(error);
                            return SizedBox(
                              width: 300,
                              child: Text('error: $error'),
                            );
                          },
                          data: (dataList) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '@${dataList['email']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.mode_edit_outline_outlined,
                                    size: 17,
                                  ),
                                ],
                              ),
                              Text(
                                dataList['introduction'],
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                userProfile.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) {
                    print(error);
                    return SizedBox(
                      width: 300,
                      child: Text('error: $error'),
                    );
                  },
                  data: (dataList) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList['reserve_course'].length,
                    itemBuilder: (context, index) {
                      final courseDetailData =
                          dataList['reserve_course'][index]['course_detail'];
                      final courseDetailTitle = courseDetailData['title'];
                      final courseDetailDate = courseDetailData['course_date'];

                      final courseData = courseDetailData['course'];
                      final courseTitle = courseData['title'];
                      final courseImage = courseData['image_url'];

                      final dancerData = courseData['dancer'];
                      final dancerNickname = dancerData['nickname'];
                      final dancerEmail = dancerData['email'];
                      final dancerImageUrl = dancerData['image_url'];
                      return GestureDetector(
                        onTap: () {
                          onCourseTap(courseData['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
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
                                    courseImage,
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 5,
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
                ),
                userProfile.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) {
                    print(error);
                    return SizedBox(
                      width: 300,
                      child: Text('error: $error'),
                    );
                  },
                  data: (dataList) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList['mate_ticket'].length,
                    itemBuilder: (context, index) {
                      final ticketCount =
                          dataList['mate_ticket'][index]['count'];
                      final ticketRemainCount =
                          dataList['mate_ticket'][index]['remain_count'];
                      final expiredDate =
                          dataList['mate_ticket'][index]['expired_date'];

                      final ticketData =
                          dataList['mate_ticket'][index]['ticket'];

                      final dancerData = ticketData['dancer'];
                      final dancerNickname = dancerData['nickname'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6555FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  dancerNickname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text('$ticketRemainCount회권 / $ticketCount회권'),
                            Text(expiredDate),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
