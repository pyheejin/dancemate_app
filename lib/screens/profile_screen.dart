import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/home_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:dancemate_app/screens/photo_screen.dart';
import 'package:dancemate_app/screens/setting_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:dancemate_app/widgets/persistent_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(getUserProfileProvider);
    String imagePath = ref.watch(profileImagePathProvider);

    NumberFormat format = NumberFormat('###,###,###,###');
    DateTime today = DateTime.now();

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(courseId: courseId),
        ),
      );
    }

    Future<void> onProfileImageTap() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoScreen(
            imagePathList: [imagePath],
            currentIndex: 0,
          ),
        ),
      );
    }

    void profileEditTap() {
      final TextEditingController nicknameController = TextEditingController();
      final TextEditingController introductionController =
          TextEditingController();

      void onSaveTap() async {
        Map<String, dynamic> bodyData = {
          'nickname': nicknameController.text,
          'introduction': introductionController.text,
        };

        final result =
            await ref.watch(postUserProfileProvider(bodyData).future);
        if (result['result_code'] == 200) {
          ref.refresh(getUserProfileProvider);
          Navigator.pop(context);
        } else {
          errorAlert(context, result['result_msg']);
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15), // 모달 전체 라운딩 처리
                  ),
                ),
                child: userProfile.when(
                  data: (userData) {
                    String nickname = userData['nickname'];
                    String introduction = userData['introduction'];

                    nicknameController.text = nickname;
                    introductionController.text = introduction;

                    return Column(
                      children: [
                        const Text(
                          '프로필 변경',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '닉네임',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: nicknameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              '자기소개',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.top,
                            controller: introductionController,
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: '자기소개',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black38,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFA48AFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: onSaveTap,
                              child: const Text(
                                '저장',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: userProfile.when(
                        data: (dataList) {
                          final imageUrl = dataList['image_url'];
                          final nickname = dataList['nickname'];
                          final introduction = dataList['introduction'];

                          ImageProvider finalImageProvider;
                          if (imagePath.isNotEmpty) {
                            finalImageProvider = AssetImage(imagePath);
                          } else if (imageUrl != null && imageUrl.isNotEmpty) {
                            imagePath = imageUrl;
                            if (imageUrl.split(':')[0] == 'https') {
                              finalImageProvider = NetworkImage(imagePath);
                            } else {
                              finalImageProvider = AssetImage(imagePath);
                            }
                          } else {
                            // 기본 이미지 경로 설정
                            imagePath = 'assets/images/app_logo/chat.png';
                            finalImageProvider = AssetImage(imagePath);
                          }

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: onProfileImageTap,
                                        child: CircleAvatar(
                                          radius: 50,
                                          foregroundImage: finalImageProvider,
                                          child: Text(nickname),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '$nickname',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: profileEditTap,
                                                child: const Icon(
                                                  Icons
                                                      .mode_edit_outline_outlined,
                                                  size: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            introduction,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        visualDensity: const VisualDensity(
                                          vertical: -4,
                                          horizontal: -4,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SettingScreen(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.settings,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // const Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('팔로잉'),
                              //     Text('팔로워'),
                              //   ],
                              // ),
                            ],
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
                  ),
                  SliverPersistentHeader(
                    delegate: ProfileTabBar(),
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
                            final courseDetailData =
                                dataList['reserve_course'][index]['course'];

                            if (courseDetailData != null) {
                              final courseDetailId = courseDetailData['id'];
                              final courseDetailTitle =
                                  courseDetailData['title'];
                              final courseDetailDate =
                                  courseDetailData['course_date'];
                              final courseDetailStartTime =
                                  courseDetailData['start_time'];
                              final courseDetailEndTime =
                                  courseDetailData['end_time'];

                              DateTime specificDay = DateFormat("yyyy-MM-dd")
                                  .parse(courseDetailDate);

                              final courseData = courseDetailData['lesson'];
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
                                          courseImage == null
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
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      dancerImageUrl,
                                                    ),
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
                                                '$courseDetailStartTime - $courseDetailEndTime',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // 당일엔 취소 못하도록 버튼 없애기
                                      specificDay.isBefore(today)
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 20,
                                                          horizontal: 30,
                                                        ),
                                                        child: Container(
                                                          height: 160,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  15), // 모달 전체 라운딩 처리
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 15),
                                                              const Text(
                                                                '예약 취소 후 초대된 톡방도 나갈까요?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 40),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.redAccent),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        '톡방 나가기',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.redAccent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      final result =
                                                                          await ref
                                                                              .watch(postCourseDetailCancelProvider(courseDetailId).future);
                                                                      if (result[
                                                                              'result_code'] ==
                                                                          200) {
                                                                        ref.refresh(
                                                                            getUserProfileProvider);
                                                                        ref.refresh(
                                                                            getHomeProvider);
                                                                      } else {
                                                                        print(
                                                                            '[${result['result_code']}] ${result['result_msg']}');
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                const Color(0xFFA48AFF)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child:
                                                                            Text(
                                                                          '예약 취소만 하기',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                110,
                                                                                87,
                                                                                192),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            return Container();
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
                            final userTicketData =
                                dataList['mate_ticket'][index];
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
                                vertical: 1,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(88, 163, 138, 255),
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
                                          horizontal: 10,
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
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35),
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      dancerImageUrl,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
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
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                  ),
                                  Expanded(
                                    child: Container(
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
      ),
    );
  }
}
