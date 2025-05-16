import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCourseProvider =
    FutureProvider.family<dynamic, dynamic>((ref, date) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourses(date);
  return result;
});

final postCourseProvider = FutureProvider.family<dynamic, Map<String, dynamic>>(
    (ref, courseData) async {
  final ApiServices api = ApiServices();

  final result = await api.postCourse(courseData);
  return result;
});

final getCourseDetailProvider =
    FutureProvider.family<dynamic, int>((ref, courseId) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseDetail(courseId);
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

final postCourseDetailCancelProvider =
    FutureProvider.family<dynamic, int>((ref, courseDetailId) async {
  final ApiServices api = ApiServices();

  final result = await api.postCourseDetailCancel(courseDetailId);
  return result;
});

final postCourseDetailExistsProvider =
    FutureProvider.family<dynamic, int>((ref, courseDetailId) async {
  final ApiServices api = ApiServices();

  final result = await api.postCourseDetailExists(courseDetailId);
  return result;
});
