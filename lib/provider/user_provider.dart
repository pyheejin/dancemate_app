import 'package:dancemate_app/contants/contants.dart';
import 'package:dancemate_app/database/api.dart';
import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUserLoginProvider =
    FutureProvider.family<Map<String, dynamic>, List<dynamic>>(
        (ref, args) async {
  final email = args[0];
  final password = args[1];
  final ApiServices api = ApiServices();

  final result = await api.postUserLogin(email, password);
  return result;
});

final postUserJoinProvider =
    FutureProvider.family<Map<String, dynamic>, UserModel>(
        (ref, userData) async {
  final ApiServices api = ApiServices();

  final result = await api.postUserJoin(userData);
  return result;
});

final userTypeProvider = StateProvider<UserType?>((ref) => UserType.Mate);

final profileImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final getUserProfileProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserProfile();
  return result;
});

final postUserProfileProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, bodyData) async {
  final ApiServices api = ApiServices();

  final result = await api.postUserProfile(bodyData);
  return result;
});

final getUserDetailProvider =
    FutureProvider.family<dynamic, int>((ref, userId) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserDetail(userId);
  return result;
});

final putUserDetailProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, bodyData) async {
  final ApiServices api = ApiServices();

  final result = await api.putUserDetail(bodyData);
  return result;
});

final getUserTicketProvider =
    FutureProvider.family<dynamic, dynamic>((ref, dancerId) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserTicket(dancerId);
  return result;
});

final getUserCourseProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserCourse();
  return result;
});

class UserNotificationListNotifier extends AsyncNotifier<dynamic> {
  final ApiServices api = ApiServices();

  final int _itemsPageSize = 10;
  int _currentPage = 1;
  bool _noMoreData = false;

  @override
  Future<dynamic> build() async {
    // 초기 데이터 로드
    return _fetchItems(_currentPage);
  }

  Future<dynamic> _fetchItems(int page) async {
    final result = await api.getUserNotification(page);

    if (result['notices'] != null) {
      if (result['count'] < _itemsPageSize) {
        _noMoreData = true;
      }
      return result['notices'];
    }
  }

  Future<void> loadMoreItems() async {
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

final userNotificationListProvider =
    AsyncNotifierProvider<UserNotificationListNotifier, dynamic>(() {
  return UserNotificationListNotifier();
});
