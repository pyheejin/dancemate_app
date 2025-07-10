import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/chat_room_create_screen.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:dancemate_app/screens/setting_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:dancemate_app/widgets/persistent_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserDetailScreen extends ConsumerWidget {
  final int userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(getUserDetailProvider(userId));
    NumberFormat format = NumberFormat('###,###,###,###');
    DateTime today = DateTime.now();

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(courseId: courseId),
        ),
      );
    }

    void onChatTap(String nickname) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatRoomCreateScreen(
            userId: userId,
            nickname: nickname,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: userDetail.when(
          data: (userData) {
            return Text(userData['user']['nickname']);
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            return SizedBox(
              width: 300,
              child: Text('user detail error: $error'),
            );
          },
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: userDetail.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        print(error);
                        return SizedBox(
                          width: 300,
                          child: Text('error: $error'),
                        );
                      },
                      data: (dataList) {
                        if (dataList['user'] == null) {
                          return Container();
                        } else {
                          final userId = dataList['user']['id'];
                          final nickname = dataList['user']['nickname'];
                          final imageUrl = dataList['user']['image_url'];

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  imageUrl.split(':')[0] == 'https'
                                      ? CircleAvatar(
                                          radius: 50,
                                          foregroundImage:
                                              NetworkImage(imageUrl),
                                          child: Text(
                                              dataList['user']['nickname']),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          foregroundImage: AssetImage(imageUrl),
                                          child: Text(
                                              dataList['user']['nickname']),
                                        ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          dataList['user']['introduction'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            onChatTap(nickname);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA48AFF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 20,
                                              ),
                                              child: Text(
                                                '메시지',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: UserDetailTabBar(),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  userDetail.when(
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
                          itemCount: dataList['user']['dancer_lesson'].length,
                          itemBuilder: (context, index) {
                            final lessonDetailData =
                                dataList['user']['dancer_lesson'][index];

                            if (lessonDetailData != null) {
                              final lessonId = lessonDetailData['id'];
                              final lessonTitle = lessonDetailData['title'];
                              final lessonImageUrl =
                                  lessonDetailData['image_url'];

                              final dancerData = lessonDetailData['dancer'];
                              final dancerNickname = dancerData['nickname'];
                              final dancerEmail = dancerData['email'];
                              final dancerImageUrl = dancerData['image_url'];

                              return GestureDetector(
                                onTap: () {
                                  onCourseTap(lessonId);
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
                                          lessonImageUrl == null
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
                                                  lessonImageUrl,
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
                                                          foregroundImage:
                                                              AssetImage(
                                                                  'assets/images/app_logo/chat.png'),
                                                        )
                                                      : dancerImageUrl.split(
                                                                  ':')[0] ==
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
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
                                                                  horizontal:
                                                                      15),
                                                          child: Text(
                                                            dancerNickname,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                              const SizedBox(height: 15),
                                              Text(
                                                lessonTitle,
                                                style: const TextStyle(
                                                  color: Color(0xff3F51B5),
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        );
                      }
                    },
                  ),
                  userDetail.when(
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
                          itemCount: dataList['user']['dancer_ticket'].length,
                          itemBuilder: (context, index) {
                            final expiredDay = dataList['user']['expired_day'];
                            final ticketData =
                                dataList['user']['dancer_ticket'][index];
                            final count = ticketData['count'];
                            final discountRate = ticketData['discount_rate'];
                            final cost = ticketData['cost'];
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
                              child: Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                child: dancerImageUrl
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
                                          Text('$expiredDay일'),
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
      ),
    );
  }
}
