import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseNotificationProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final ticketNotificationProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final communityNotificationProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
