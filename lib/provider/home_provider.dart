import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getHomeRecommendUserProvider =
    FutureProvider<List<RecommendUserModel>>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getHomeRecommendUsers();
  return result;
});

final getHomeTodayCourseProvider =
    FutureProvider<List<CourseModel>>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getHomeTodayCourses();
  return result;
});

final getHomeReserveCourseProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getHomeReserveCourses();
  return result;
});
