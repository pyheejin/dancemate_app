import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectDateProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final selectMonthProvider = StateProvider.autoDispose<int>((ref) {
  return DateTime.now().month;
});

final getCalendarLessonProvider =
    FutureProvider.family<dynamic, int>((ref, month) async {
  final ApiServices api = ApiServices();

  final result = await api.getCalendarLessons(month);
  return result;
});
