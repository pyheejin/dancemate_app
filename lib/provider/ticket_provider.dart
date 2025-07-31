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
class TicketListNotifier extends FamilyAsyncNotifier<dynamic, String> {
  final ApiServices api = ApiServices();

  final int _itemsPerPage = 4; // 한 번에 로드할 아이템 수
  int _currentPage = 1;
  bool _noMoreData = false;

  @override
  Future<dynamic> build(String args) async {
    // 초기 데이터 로드
    int year = int.parse(args.split('-')[0]);
    int month = int.parse(args.split('-')[1]);
    return _fetchItems(_currentPage, year, month);
  }

  Future<dynamic> _fetchItems(int page, int year, int month) async {
    final result = await api.getTicketSalesList(page, year, month);

    if (result != null) {
      if (result.length < _itemsPerPage) {
        _noMoreData = true;
      }
      return result;
    }
  }

  Future<void> loadMoreItems(int year, int month) async {
    // 이미 로딩 중이거나 더 이상 데이터가 없으면 중단
    if (state.isLoading || _noMoreData) return;

    state = const AsyncValue.loading(); // 로딩 상태로 변경

    // 기존 데이터 (현재 리스트의 값)를 가져옴
    // state.value는 List<dynamic> 타입이므로 캐스팅하여 사용
    final currentData = state.value is List ? state.value as List : [];

    // 로딩 상태로 변경하되, 기존 데이터를 유지하면서 로딩 인디케이터를 보여줌
    state = const AsyncValue.loading()
        .copyWithPrevious(AsyncValue.data(currentData));

    try {
      _currentPage++;
      final newItems = await _fetchItems(_currentPage, year, month);

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
final ticketListProvider =
    AsyncNotifierProvider.family<TicketListNotifier, dynamic, String>(() {
  return TicketListNotifier();
});
