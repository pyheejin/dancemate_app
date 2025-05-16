import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCourseDetailProvider =
    FutureProvider.family<dynamic, dynamic>((ref, courseDetailId) async {
  final ApiServices api = ApiServices();

  final result = await api.getCourseDetailDetail(courseDetailId);
  return result;
});
