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

final selectUserTicketProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final postCourseDetailReserveProvider =
    FutureProvider.family<dynamic, List<int>>((ref, args) async {
  final ApiServices api = ApiServices();

  final courseDetailId = args[0];
  final userTicketId = args[1];

  final result = await api.postCourseDetailReserve(
    courseDetailId,
    userTicketId,
  );
  return result;
});
