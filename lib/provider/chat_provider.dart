import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatRoomProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getChatRoom();
  return result;
});

class ChatRoomNotifier extends StateNotifier<dynamic> {
  ChatRoomNotifier() : super([]);
}

final chatRoomProvider =
    StateNotifierProvider<ChatRoomNotifier, dynamic>((ref) {
  return ChatRoomNotifier();
});
