import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCourseDetailProvider =
    FutureProvider.family<dynamic, dynamic>((ref, courseId) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseDetail(courseId);
  return result;
});
