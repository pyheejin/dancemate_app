import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSearchPreProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getSearchPre();
  return result;
});

final searchKeywordProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final searchResultCountProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class SearchNotifier extends FamilyAsyncNotifier<List<dynamic>, String> {
  final ApiServices api = ApiServices();

  final int _itemsPerPage = 4;
  int resultCount = 0;

  @override
  Future<List<dynamic>> build(String keyword) async {
    // 초기 데이터 로드
    return _fetchItems(1, keyword);
  }

  Future<List<dynamic>> _fetchItems(int page, String keyword) async {
    final result = await api.getSearch(page, keyword);
    if (result != null) {
      resultCount = result['result_count'];
      return result['courses'] as List<dynamic>;
    }
    return [];
  }

  Future<void> loadMoreItems() async {
    // 이미 로딩 중이거나 데이터가 비어있을 때 중단
    if (state.isLoading || state.value == null) return;

    final currentData = state.value!;

    // 로딩 상태를 설정하면서 기존 데이터를 유지
    state = AsyncValue.data(currentData)
        .copyWithPrevious(const AsyncValue.loading());

    final int currentPage = (currentData.length / _itemsPerPage).ceil() + 1;

    try {
      final newItems = await _fetchItems(currentPage, arg);

      if (newItems.isEmpty) {
        state = AsyncValue.data(currentData); // 기존 데이터 유지
        return;
      }

      state = AsyncValue.data([
        ...currentData,
        ...newItems,
      ]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  int getResultCount() {
    return resultCount;
  }
}

final getSearchProvider =
    AsyncNotifierProvider.family<SearchNotifier, List<dynamic>, String>(() {
  return SearchNotifier();
});
