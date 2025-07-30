import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'data_provider.g.dart';

final getTicketSalesProvider =
    FutureProvider.family<dynamic, String>((ref, args) async {
  final ApiServices api = ApiServices();

  int year = int.parse(args.split('-')[0]);
  int month = int.parse(args.split('-')[1]);
  int page = int.parse(args.split('-')[2]);

  final result = await api.getTicketSalesList(year, month, page);
  return result;
});

// 상태를 관리할 AsyncNotifier
class ItemListNotifier extends AsyncNotifier<dynamic> {
  final ApiServices api = ApiServices();

  final int _itemsPerPage = 4; // 한 번에 로드할 아이템 수
  int _currentPage = 1;
  bool _noMoreData = false;

  @override
  Future<dynamic> build() async {
    // 초기 데이터 로드
    return _fetchItems(_currentPage);
  }

  Future<dynamic> _fetchItems(int page) async {
    // 실제 API 호출 로직 (예시)
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션
    final int startIndex = page * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;

    final result = await api.getTicketSalesList(2025, 5, page);
    print('result: ${result.length}');
    if (result != null) {
      if (result.length < _itemsPerPage) {
        _noMoreData = true;
      }
      return result;
    }
  }

  Future<void> loadMoreItems() async {
    if (state.isLoading || _noMoreData) return; // 이미 로딩 중이거나 더 이상 데이터가 없으면 중단

    state = const AsyncValue.loading(); // 로딩 상태로 변경

    // 기존 데이터 (현재 리스트의 값)를 가져옴
    // state.value는 List<dynamic> 타입이므로 캐스팅하여 사용
    final currentData = state.value is List ? state.value as List : [];

    // 로딩 상태로 변경하되, 기존 데이터를 유지하면서 로딩 인디케이터를 보여줌
    state = const AsyncValue.loading()
        .copyWithPrevious(AsyncValue.data(currentData));

    try {
      _currentPage++;
      final newItems = await _fetchItems(_currentPage);

      state = AsyncValue.data([
        ...currentData, // 기존 데이터 유지
        ...newItems, // 새 데이터 추가
      ]);
    } catch (e, st) {
      state = AsyncValue.error(e, st); // 에러 발생 시
    }
  }
}

// Provider 선언
final itemListProvider = AsyncNotifierProvider<ItemListNotifier, dynamic>(() {
  return ItemListNotifier();
});
