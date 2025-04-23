import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:dancemate_app/screens/setting_screen.dart';
import 'package:dancemate_app/widgets/persistent_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(getUserProfileProvider);
    NumberFormat format = NumberFormat('###,###,###,###');

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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingScreen(),
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
                          data: (dataList) {
                            if (dataList == null) {
                              return Container();
                            } else {
                              return CircleAvatar(
                                radius: 50,
                                foregroundImage:
                                    NetworkImage(dataList['image_url']),
                                child: Text(dataList['nickname']),
                              );
                            }
                          },
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
                          data: (dataList) {
                            if (dataList == null) {
                              return Container();
                            } else {
                              return Column(
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
                              );
                            }
                          },
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
                  data: (dataList) {
                    if (dataList == null) {
                      return Container();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList['reserve_course'].length,
                        itemBuilder: (context, index) {
                          final courseDetailData = dataList['reserve_course']
                              [index]['course_detail'];

                          if (courseDetailData != null) {
                            final courseDetailId = courseDetailData['id'];
                            final courseDetailTitle = courseDetailData['title'];
                            final courseDetailDate =
                                courseDetailData['course_date'];

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          courseImage,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        color: const Color(
                                                            0xff6555FF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        child: Text(
                                                          dancerNickname,
                                                          style:
                                                              const TextStyle(
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
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await ref.watch(
                                            postCourseDetailCancelProvider(
                                                    courseDetailId)
                                                .future);
                                        print(result['result_code']);
                                        if (result['result_code'] == 200) {
                                          ref.refresh(getUserProfileProvider);
                                          ref.refresh(getHomeProvider);
                                        } else {
                                          print('reserve course cancel fail');
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            '예약취소',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      );
                    }
                  },
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
                  data: (dataList) {
                    if (dataList == null) {
                      return Container();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList['mate_ticket'].length,
                        itemBuilder: (context, index) {
                          final userTicketData = dataList['mate_ticket'][index];
                          final count = userTicketData['count'];
                          final remainCount = userTicketData['remain_count'];
                          final expiredDate = userTicketData['expired_date'];

                          final ticketData = userTicketData['ticket'];
                          final price = ticketData['price'];

                          final dancerData = ticketData['dancer'];
                          final dancerEmail = dancerData['email'];
                          final dancerNickname = dancerData['nickname'];
                          final dancerImageUrl = dancerData['image_url'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(88, 163, 138, 255),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.black38,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  dancerImageUrl,
                                                ),
                                              ),
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
                                                  '@$dancerEmail',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$count회권',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 100),
                                            Text(
                                              '${format.format(price)}원',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(81, 64, 195, 255),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.black26,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30,
                                      horizontal: 12,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          '남은 횟수:\n $remainCount회',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          textAlign: TextAlign.right,
                                          '$expiredDate',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
