import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final getLessonProvider =
    FutureProvider.family<dynamic, dynamic>((ref, date) async {
  final ApiServices api = ApiServices();

  final result = await api.getLessons(date);
  return result;
});

final postLessonProvider = FutureProvider.family<dynamic, Map<String, dynamic>>(
    (ref, lessonData) async {
  final ApiServices api = ApiServices();

  final result = await api.postLesson(lessonData);
  return result;
});

final getLessonDetailProvider =
    FutureProvider.family<dynamic, int>((ref, lessonId) async {
  final ApiServices api = ApiServices();

  final result = await api.getLessonDetail(lessonId);
  return result;
});

final selectCourseDetailIdProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final getLessonLikeProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getLessonLike();
  return result;
});

final postLessonLikeProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, courseId) async {
  final ApiServices api = ApiServices();

  final result = await api.postLessonDetailLike(courseId);
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

final initialImagePageProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final selectLessonImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final selectLessonImagesPathProvider =
    StateProvider.autoDispose<List<XFile>>((ref) {
  return [];
});
