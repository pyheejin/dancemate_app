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
