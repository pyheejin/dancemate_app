import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getReserveProvider =
    FutureProvider.family<dynamic, int>((ref, courseDetailId) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseDetailReserve(courseDetailId);
  return result;
});

final selectCourseDetailIdProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
