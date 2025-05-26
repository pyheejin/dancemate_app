import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lessonReviewRateProvider = StateProvider.autoDispose<double>((ref) {
  return 1;
});

class LessonDetailReviewNotifier extends StateNotifier<dynamic> {
  LessonDetailReviewNotifier() : super([]);

  dynamic saveReview(int lessonId, Map<String, dynamic> request) async {
    final ApiServices api = ApiServices();

    final result = await api.postLessonDetailReview(lessonId, request);
    return result;
  }

  dynamic updateReview(int reviewId, Map<String, dynamic> request) async {
    final ApiServices api = ApiServices();

    final result = await api.putReviewDetail(reviewId, request);
    return result;
  }
}

final lessonDetailReviewProvider =
    StateNotifierProvider<LessonDetailReviewNotifier, dynamic>((ref) {
  return LessonDetailReviewNotifier();
});

final getReviewDetailProvider =
    FutureProvider.family<dynamic, dynamic>((ref, reviewId) async {
  final ApiServices api = ApiServices();

  final result = await api.getReviewDetail(reviewId);
  return result;
});
