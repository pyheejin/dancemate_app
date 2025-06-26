import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textController = TextEditingController();

    String keyword = ref.watch(searchKeywordProvider);
    dynamic courses = ref.watch(getSearchProvider(keyword));
    dynamic searchPre = ref.watch(getSearchPreProvider);

    void onTap(String searchKeyword) {
      ref.read(searchKeywordProvider.notifier).update((state) => searchKeyword);

      courses = ref.watch(getSearchProvider(searchKeyword));
      searchPre = ref.watch(getSearchPreProvider);

      ref.refresh(getSearchPreProvider);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      onTap(textController.text);
                    },
                    child: const Icon(
                      Icons.search_outlined,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SearchResult(
              ref: ref,
              courses: courses,
              searchPre: searchPre,
              text: keyword,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
    required this.ref,
    required this.searchPre,
    required this.courses,
    required this.text,
  });

  final WidgetRef ref;
  final AsyncValue searchPre, courses;
  final String text;

  @override
  Widget build(BuildContext context) {
    void onKeywordTap(String searchKeyword) {
      ref.read(searchKeywordProvider.notifier).update((state) => searchKeyword);

      ref.refresh(getSearchPreProvider);
    }

    void onCourseTap(int courseId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(courseId: courseId),
        ),
      );
    }

    if (text.isEmpty) {
      return Expanded(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '최근 검색어',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    searchPre.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        return SizedBox(
                          width: 300,
                          child: Text('error: $error'),
                        );
                      },
                      data: (dataList) {
                        return SizedBox(
                          width: 390,
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dataList['latest_keyword'].length,
                            itemBuilder: (context, index) {
                              final keywordData =
                                  dataList['latest_keyword'][index];
                              return GestureDetector(
                                onTap: () {
                                  onKeywordTap(keywordData['keyword']);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Center(
                                      child: Text(
                                        keywordData['keyword'],
                                      ),
                                    ),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '추천 검색어',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    searchPre.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        return SizedBox(
                          width: 300,
                          child: Text('error: $error'),
                        );
                      },
                      data: (dataList) {
                        return SizedBox(
                          width: 390,
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dataList['recommend_keyword'].length,
                            itemBuilder: (context, index) {
                              final keywordData =
                                  dataList['recommend_keyword'][index];
                              return GestureDetector(
                                onTap: () {
                                  onKeywordTap(keywordData['keyword']);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Center(
                                      child: Text(
                                        keywordData['keyword'],
                                      ),
                                    ),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '추천 수업 Top 3',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    searchPre.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        print(error);
                        return SizedBox(
                          width: 300,
                          child: Text('error: $error'),
                        );
                      },
                      data: (dataList) => ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: dataList['recommend_courses'].length,
                        itemBuilder: (context, index) {
                          final courseData =
                              dataList['recommend_courses'][index];
                          final title = courseData['title'];
                          final courseImage = courseData['image_url'];

                          final dancerData = courseData['dancer'];
                          final dancerNickname = dancerData['nickname'];
                          final dancerEmail = dancerData['email'];
                          final dancerImageUrl = dancerData['image_url'];

                          final courseDetailData = courseData['course'][0];
                          final courseDate = courseDetailData['course_date'];
                          final courseTitle = courseDetailData['title'];
                          final courseStartTime =
                              courseDetailData['start_time'];
                          final courseEndTime = courseDetailData['end_time'];
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
                                      Positioned(
                                        top: 5,
                                        left: 5,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                              : dancerImageUrl.split(':')[0] ==
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
                                                      BorderRadius.circular(10),
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
                                        title,
                                        style: const TextStyle(
                                          color: Color(0xff3F51B5),
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        '$courseDate $courseTitle',
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return courses.when(
        data: (courseList) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('검색결과 총 ${courseList['courses'].length}개'),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: courseList['courses'].length,
                itemBuilder: (context, index) {
                  if (courseList['courses'].isEmpty) {
                    return null;
                  }
                  final courseData = courseList['courses'][index];
                  final courseTitle = courseData['title'];
                  final courseImage = courseData['image_url'];

                  final courseDetailData = courseData['course'][0];
                  final courseDetailDate = courseDetailData['course_date'];
                  final courseDetailTitle = courseDetailData['title'];
                  final courseDetailStartTime = courseDetailData['start_time'];
                  final courseDetailEndTime = courseDetailData['end_time'];

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
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
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
                                  dancerImageUrl == ''
                                      ? const CircleAvatar(
                                          foregroundImage: AssetImage(
                                              'assets/images/app_logo/chat.png'),
                                        )
                                      : dancerImageUrl.split(':')[0] == 'https'
                                          ? CircleAvatar(
                                              foregroundImage:
                                                  NetworkImage(dancerImageUrl),
                                            )
                                          : CircleAvatar(
                                              foregroundImage:
                                                  AssetImage(dancerImageUrl),
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
                              const SizedBox(height: 10),
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
                    ),
                  );
                },
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) {
          return SizedBox(
            width: 300,
            child: Text('search error: $error'),
          );
        },
      );
    }
  }
}
