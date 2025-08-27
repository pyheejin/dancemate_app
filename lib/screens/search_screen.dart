import 'package:dancemate_app/provider/search_provider.dart';
import 'package:dancemate_app/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late String newKeyword;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(getSearchProvider(newKeyword).notifier).loadMoreItems();
    }
  }

  @override
  void dispose() {
    // 위젯이 파괴될 때 컨트롤러를 해제
    _textController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchTap() {
    // 키워드 업데이트 및 provider 리프레시
    ref
        .read(searchKeywordProvider.notifier)
        .update((state) => _textController.text);
    ref.refresh(getSearchPreProvider);
    FocusScope.of(context).unfocus(); // 키보드 숨기기
  }

  void _onKeywordTap(String searchKeyword) {
    _textController.text = searchKeyword;
    ref.read(searchKeywordProvider.notifier).update((state) => searchKeyword);
    ref.refresh(getSearchPreProvider);
    FocusScope.of(context).unfocus();
  }

  void _onCourseTap(int courseId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String keyword = ref.watch(searchKeywordProvider);
    final AsyncValue courses = ref.watch(getSearchProvider(keyword));
    final AsyncValue searchPre = ref.watch(getSearchPreProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (value) => _onSearchTap(),
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
                      onTap: _onSearchTap,
                      child: const Icon(
                        Icons.search_outlined,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // SearchResult 위젯의 내용을 여기에 직접 삽입
              Expanded(
                child: _buildResultBody(keyword, courses, searchPre),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBody(
      String keyword, AsyncValue courses, AsyncValue searchPre) {
    if (keyword.isEmpty) {
      return CustomScrollView(
        slivers: [
          _buildRecentKeywords(searchPre),
          _buildRecommendedKeywords(searchPre),
          _buildRecommendedCourses(searchPre),
        ],
      );
    } else {
      newKeyword = keyword;
      return _buildSearchResults(courses);
    }
  }

  Widget _buildRecentKeywords(AsyncValue searchPre) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('최근 검색어',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            searchPre.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) =>
                  SizedBox(width: 300, child: Text('error: $error')),
              data: (dataList) {
                return SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dataList['latest_keyword'].length,
                    itemBuilder: (context, index) {
                      final keywordData = dataList['latest_keyword'][index];
                      return GestureDetector(
                        onTap: () => _onKeywordTap(keywordData['keyword']),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(child: Text(keywordData['keyword'])),
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
    );
  }

  Widget _buildRecommendedKeywords(AsyncValue searchPre) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('추천 검색어',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            searchPre.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) =>
                  SizedBox(width: 300, child: Text('error: $error')),
              data: (dataList) {
                return SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dataList['recommend_keyword'].length,
                    itemBuilder: (context, index) {
                      final keywordData = dataList['recommend_keyword'][index];
                      return GestureDetector(
                        onTap: () => _onKeywordTap(keywordData['keyword']),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(child: Text(keywordData['keyword'])),
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
    );
  }

  Widget _buildRecommendedCourses(AsyncValue searchPre) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('추천 수업 Top 3',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            searchPre.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) =>
                  SizedBox(width: 300, child: Text('error: $error')),
              data: (dataList) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // CustomScrollView에 종속되므로 스크롤 비활성화
                  itemCount: dataList['recommend_courses'].length,
                  itemBuilder: (context, index) {
                    final courseData = dataList['recommend_courses'][index];
                    return _buildCourseItem(courseData);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue courses) {
    return courses.when(
      data: (courseList) {
        if (courseList.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다.'));
        }

        final resultCount =
            ref.read(getSearchProvider(newKeyword).notifier).getResultCount();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('검색결과 총 $resultCount개'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: courseList.length,
                itemBuilder: (context, index) {
                  final courseData = courseList[index];
                  return _buildCourseItem(courseData);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) =>
          SizedBox(width: 300, child: Text('search error: $error')),
    );
  }

  Widget _buildCourseItem(dynamic courseData) {
    final courseTitle = courseData['title'];
    final courseImage = courseData['image_url'];

    final dancerData = courseData['dancer'];
    final dancerNickname = dancerData['nickname'];
    final dancerEmail = dancerData['email'];
    final dancerImageUrl = dancerData['image_url'];

    final courseDetailData = courseData['course'][0];
    final courseDetailDate = courseDetailData['course_date'];
    final courseDetailTitle = courseDetailData['title'];
    final courseDetailStartTime = courseDetailData['start_time'];
    final courseDetailEndTime = courseDetailData['end_time'];

    return GestureDetector(
      onTap: () => _onCourseTap(courseData['id']),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                        'assets/images/app_logo/2x.png')
                    : Image.network(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        courseImage),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: dancerImageUrl == ''
                            ? const AssetImage(
                                'assets/images/app_logo/chat.png')
                            : NetworkImage(dancerImageUrl) as ImageProvider,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6555FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                dancerNickname,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Text(dancerEmail,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(courseTitle,
                      style: const TextStyle(
                          color: Color(0xff3F51B5), fontSize: 17)),
                  Text('$courseDetailDate $courseDetailTitle',
                      style: const TextStyle(fontSize: 15)),
                  Text('$courseDetailStartTime - $courseDetailEndTime',
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
