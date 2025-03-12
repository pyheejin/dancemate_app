import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCourseProvider =
    FutureProvider.family<dynamic, dynamic>((ref, date) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourses(date);
  return result;
});

final getCourseDetailProvider =
    FutureProvider.family<dynamic, int>((ref, courseDetailId) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseDetail(courseDetailId);
  return result;
});

final selectCourseDetailIdProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final getCourseLikeProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseLike();
  return result;
});

final postCourseLikeProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, courseId) async {
  final ApiServices api = ApiServices();

  final result = await api.postCourseDetailLike(courseId);
  return result;
});
