import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationProvider extends StateNotifier<dynamic> {
  NotificationProvider() : super([]);

  dynamic postNotification(Map<String, dynamic> request) async {
    final ApiServices api = ApiServices();

    final result = await api.postNotification(request);
    return result;
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationProvider, dynamic>((ref) {
  return NotificationProvider();
});

final getNotificationProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getNotification();
  return result;
});
