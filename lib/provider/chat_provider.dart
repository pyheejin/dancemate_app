import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketListNotifier extends FamilyAsyncNotifier<dynamic, int> {
  final ApiServices api = ApiServices();

  final int _itemsPerPage = 10; // 한 번에 로드할 아이템 수
  int _currentPage = 1;
  bool _noMoreData = false;
  int loginUserId = 0;

  @override
  Future<dynamic> build(int type) async {
    return _fetchItems(_currentPage, type);
  }

  Future<dynamic> _fetchItems(int page, int type) async {
    final result = await api.getChatRoom(page, _itemsPerPage, type);

    if (result != null) {
      if (result['chat_rooms'].length < _itemsPerPage) {
        _noMoreData = true;
      }
      loginUserId = result['login_user_id'];
      return result['chat_rooms'];
    }
  }

  Future<void> loadMoreItems(int type) async {
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
      final newItems = await _fetchItems(_currentPage, type);

      state = AsyncValue.data([
        ...currentData, // 기존 데이터 유지
        ...newItems, // 새 데이터 추가
      ]);
    } catch (e, st) {
      state = AsyncValue.error(e, st); // 에러 발생 시
    }
  }

  int getLoginUserId() {
    return loginUserId;
  }
}

final getChatRoomProvider =
    AsyncNotifierProvider.family<TicketListNotifier, dynamic, int>(() {
  return TicketListNotifier();
});

final getChatRoomDetailProvider =
    FutureProvider.family<dynamic, int>((ref, chatRoomId) async {
  final ApiServices api = ApiServices();

  final result = await api.getChatRoomDetail(chatRoomId);
  return result;
});

class ChatRoomNotifier extends StateNotifier<dynamic> {
  ChatRoomNotifier() : super([]);

  dynamic postChatRoom(int userId) async {
    final ApiServices api = ApiServices();

    final result = await api.postChatRoom(userId);
    return result;
  }

  dynamic putChatRoomDetail(int chatRoomId) async {
    final ApiServices api = ApiServices();

    final result = await api.putChatRoomDetail(chatRoomId);
    return result;
  }

  dynamic deleteChatRoomDetail(int chatRoomId) async {
    final ApiServices api = ApiServices();

    final result = await api.deleteChatRoomDetail(chatRoomId);
    return result;
  }

  dynamic postChatRoomDetailChat(int chatRoomId, String message) async {
    final ApiServices api = ApiServices();

    final result = await api.postChatRoomDetailChat(chatRoomId, message);
    return result;
  }
}

final chatRoomProvider =
    StateNotifierProvider<ChatRoomNotifier, dynamic>((ref) {
  return ChatRoomNotifier();
});

final postChatRoomExistsProvider =
    FutureProvider.family<dynamic, int>((ref, userId) async {
  final ApiServices api = ApiServices();

  final result = await api.postChatRoomExists(userId);
  return result;
});

final chatRoomNoticeProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final postChatRoomDetailNoticeProvider =
    FutureProvider.family<dynamic, int>((ref, chatRoomId) async {
  final ApiServices api = ApiServices();

  final result = await api.postChatRoomDetailNotice(chatRoomId);
  return result;
});
