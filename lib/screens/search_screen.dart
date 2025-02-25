import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textController = TextEditingController();

    String keyword = textController.text;
    dynamic courses = ref.watch(getSearchProvider(keyword));
    dynamic searchPre = ref.watch(getSearchPreProvider);

    void onTap(String searchKeyword) {
      courses = ref.watch(getSearchProvider(searchKeyword));
      searchPre = ref.watch(getSearchPreProvider);
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      print('???? ${textController.text}');
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
    required this.searchPre,
    required this.courses,
    required this.text,
  });

  final AsyncValue searchPre, courses;
  final String text;

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      children: [
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
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.grey.shade400),
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
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
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
                    Row(
                      children: [
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
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.grey.shade400),
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
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
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

                          final courseDetailData =
                              courseData['course_detail'][0];
                          final courseDate = courseDetailData['course_date'];
                          final courseTitle = courseDetailData['title'];
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
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('검색결과 총 N개'),
            ],
          ),
          const SizedBox(height: 20),
          courses.when(
            data: (courseList) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: courseList.length,
                itemBuilder: (context, index) {
                  final courseData = courseList['courses'][index];
                  final courseDate = courseData['course_date'];
                  final courseTitle = courseData['title'];
                  final courseImage = courseData['course']['image_url'];

                  final dancerData = courseData['course']['dancer'];
                  final dancerNickname = dancerData['nickname'];
                  final dancerEmail = dancerData['email'];
                  final dancerImageUrl = dancerData['image_url'];
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
                                courseImage,
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
                              const SizedBox(height: 5),
                              Text(
                                courseTitle,
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
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) {
              return SizedBox(
                width: 300,
                child: Text('search error: $error'),
              );
            },
          ),
        ],
      );
    }
  }
}
