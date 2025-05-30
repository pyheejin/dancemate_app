import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatRoomProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getChatRoom();
  return result;
});

final getChatRoomDetailProvider =
    FutureProvider.family<dynamic, int>((ref, chatRoomId) async {
  final ApiServices api = ApiServices();

  final result = await api.getChatRoomDetail(chatRoomId);
  return result;
});

class ChatRoomNotifier extends StateNotifier<dynamic> {
  ChatRoomNotifier() : super([]);

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
