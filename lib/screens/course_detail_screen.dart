import 'package:dancemate_app/provider/course_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/order_screen.dart';
import 'package:dancemate_app/screens/reserve_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailScreen extends ConsumerWidget {
  final int courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailData = ref.watch(getCourseDetailProvider(courseId));

    dynamic selectCourseDetailId = ref.watch(selectCourseDetailIdProvider);

    if (courseDetailData.value != null) {
      if (selectCourseDetailId == 0) {
        selectCourseDetailId = courseDetailData.value['course_detail'][0]['id'];
      }
    }

    void onReserveTap(int courseDetailId, int dancerId) async {
      dynamic isCourseReserveExists =
          ref.watch(postCourseDetailExistsProvider(selectCourseDetailId));

      if (isCourseReserveExists.value != null) {
        if (isCourseReserveExists.value['result_code'] > 200) {
          errorAlert(context, isCourseReserveExists.value['result_msg']);
        } else {
          final ticketData = ref.watch(getUserTicketProvider(dancerId));

          if (ticketData.hasValue) {
            if (ticketData.value['result_count'] > 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ReserveScreen(courseDetailId: courseDetailId),
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
        }
      }
    }

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
            final courseTitle = courseDetail['title'];
            final courseImageUrl = courseDetail['image_url'];
            final courseDescription = courseDetail['description'];
            final isCourseLike = courseDetail['is_like'];

            final dancerData = courseDetail['dancer'];
            final dancerEmail = dancerData['email'];
            final dancerNickname = dancerData['nickname'];
            final dancerImageUrl = dancerData['image_url'];

            final courseDetailList = courseDetail['course_detail'];
            return Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    courseImageUrl == null
                        ? Image.asset(
                            height: 270,
                            'assets/images/app_logo/detail_2x.png',
                          )
                        : Image.network(
                            width: 430,
                            height: 270,
                            fit: BoxFit.fitWidth,
                            courseImageUrl,
                          ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await ref.watch(
                              postCourseLikeProvider(courseDetail['id'])
                                  .future);
                          print(result['result_code']);
                          if (result['result_code'] == 200) {
                            print('200이래');
                            ref.refresh(getCourseDetailProvider(courseId));
                            print(isCourseLike);
                          } else {
                            print('like fail');
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: const Color(0xff9475FF),
                          ),
                          child: Icon(
                            isCourseLike
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              dancerImageUrl,
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
                        courseTitle,
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
                              padding: EdgeInsets.zero,
                              itemCount: courseDetailList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      Container(
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
                              }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(courseDescription),
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
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              courseDetailData.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  print(error);
                  return SizedBox(
                    width: 300,
                    child: Text('error: $error'),
                  );
                },
                data: (courseDetail) {
                  final courseDetailList = courseDetail['course_detail'];

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFA48AFF),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: DropdownButton(
                        value: selectCourseDetailId,
                        items: courseDetailList
                            .map<DropdownMenuItem<Object>>(
                              (dynamic e) => DropdownMenuItem<Object>(
                                value: e['id'],
                                child: Text(
                                  '${e['course_date']} ${e['title']}',
                                  style: const TextStyle(
                                    color: Color(0xFFA48AFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
              TextButton(
                onPressed: () {
                  if (courseDetailData.value != null) {
                    final dancerId = courseDetailData.value['course_detail'][0]
                        ['course']['dancer']['id'];
                    onReserveTap(selectCourseDetailId, dancerId);
                  }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
