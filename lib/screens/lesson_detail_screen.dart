import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/order_screen.dart';
import 'package:dancemate_app/screens/photo_screen.dart';
import 'package:dancemate_app/screens/reserve_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LessonDetailScreen extends ConsumerWidget {
  final int courseId;

  const LessonDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailData = ref.watch(getLessonDetailProvider(courseId));

    dynamic selectCourseDetailId = ref.watch(selectCourseDetailIdProvider);

    if (courseDetailData.value != null) {
      if (selectCourseDetailId == 0) {
        selectCourseDetailId =
            courseDetailData.value['lesson']['course'][0]['id'];
      }
    }

    Future<void> onProfileImageTap(String imagePath) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoScreen(
            imagePathList: [imagePath],
            currentIndex: 0,
          ),
        ),
      );
    }

    void onReserveTap(int courseDetailId, int dancerId, int ticketCount) async {
      if (ticketCount > 0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReserveScreen(courseDetailId: courseDetailId),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderScreen(
              courseDetailId: courseDetailId,
              dancerId: dancerId,
            ),
          ),
        );
      }
    }

    int initialImagePage = ref.watch(initialImagePageProvider);

    final pageController = PageController(
      initialPage: initialImagePage,
      viewportFraction: 0.8,
      keepPage: true,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          automaticallyImplyLeading: true,
        ),
      ),
      body: SingleChildScrollView(
        child: courseDetailData.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            print(error);
            return SizedBox(
              width: 300,
              child: Text('error: $error'),
            );
          },
          data: (courseDetail) {
            final lessonTitle = courseDetail['lesson']['title'];
            final lessonImages = courseDetail['lesson']['lesson_image'];
            final lessonDescription = courseDetail['lesson']['description'];

            final dancerData = courseDetail['lesson']['dancer'];
            final dancerEmail = dancerData['email'];
            final dancerNickname = dancerData['nickname'];
            String dancerImageUrl = dancerData['image_url'];

            final courseDetailList = courseDetail['lesson']['course'];

            ImageProvider finalImageProvider;
            if (dancerImageUrl.isNotEmpty) {
              if (dancerImageUrl.split(':')[0] == 'https') {
                finalImageProvider = NetworkImage(dancerImageUrl);
              } else {
                finalImageProvider = AssetImage(dancerImageUrl);
              }
            } else {
              // 기본 이미지 경로 설정
              dancerImageUrl = 'assets/images/app_logo/chat.png';
              finalImageProvider = AssetImage(dancerImageUrl);
            }
            return Column(
              children: [
                const SizedBox(height: 10),
                lessonImages.isEmpty
                    ? Image.asset(
                        height: 270,
                        'assets/images/app_logo/detail_2x.png',
                      )
                    : SizedBox(
                        height: 220,
                        child: Stack(
                          children: [
                            ListView.builder(
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: lessonImages.length,
                              itemBuilder: (BuildContext context, int index) {
                                final path = lessonImages[index]['image_url'];
                                return Image.network(
                                  width: 430,
                                  height: 220,
                                  fit: BoxFit.fill,
                                  path,
                                );
                              },
                            ),
                            lessonImages.isEmpty
                                ? Container()
                                : Positioned(
                                    left: (MediaQuery.of(context).size.width /
                                            2) -
                                        (lessonImages.length * 10),
                                    bottom: 10,
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SmoothPageIndicator(
                                            controller: pageController,
                                            count: lessonImages.length,
                                            effect: const SwapEffect(
                                              dotHeight: 12,
                                              dotWidth: 12,
                                              dotColor: Color(0xFFA48AFF),
                                              activeDotColor: Color(0xFF74D0FF),
                                            ),
                                            onDotClicked: (index) {
                                              ref
                                                  .read(initialImagePageProvider
                                                      .notifier)
                                                  .update((state) => index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              onProfileImageTap(dancerImageUrl);
                            },
                            child: CircleAvatar(
                              foregroundImage: finalImageProvider,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff6555FF),
                                  borderRadius: BorderRadius.circular(10),
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
                                '@$dancerEmail',
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
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: courseDetailList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 30,
                                            ),
                                            child: Text(
                                              courseDetailList[index]
                                                  ['course_date'],
                                              style: const TextStyle(
                                                color: Color(0xff3F51B5),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff3F51B5),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              courseDetailList[index]['title'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff3F51B5),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              courseDetailList[index]
                                                  ['address'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Color(0xFFA48AFF),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(lessonDescription),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: courseDetailData.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) {
                    print(error);
                    return SizedBox(
                      width: 300,
                      child: Text('error: $error'),
                    );
                  },
                  data: (courseDetail) {
                    final courseDetailList = courseDetail['lesson']['course'];

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFA48AFF),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: DropdownButton(
                          value: selectCourseDetailId,
                          items: courseDetailList.map<DropdownMenuItem<Object>>(
                            (dynamic e) {
                              return DropdownMenuItem<Object>(
                                value: e['id'],
                                child: Text(
                                  '${e['title']}',
                                  style: const TextStyle(
                                    color: Color(0xFFA48AFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            ref
                                .read(selectCourseDetailIdProvider.notifier)
                                .update((state) => value as int);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: courseDetailData.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) {
                    print(error);
                    return SizedBox(
                      width: 300,
                      child: Text('error: $error'),
                    );
                  },
                  data: (data) {
                    return TextButton(
                      onPressed: () {
                        final dancerId = data['lesson']['dancer']['id'];
                        final ticketCount = data['ticket_count'];
                        onReserveTap(
                          selectCourseDetailId,
                          dancerId,
                          ticketCount,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFA48AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '예약하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
