import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDancerDetailTicketProvider =
    FutureProvider.family<dynamic, dynamic>((ref, dancerId) async {
  final ApiServices api = ApiServices();

  final result = await api.getDancerDetailTicket(dancerId);
  return result;
});

final getDancerCourseProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getDancerCourse();
  return result;
});

class DancerCourseNotifier extends StateNotifier<dynamic> {
  DancerCourseNotifier() : super([]);

  void addCourseDetail(Map<String, dynamic> detail) {
    state = [...state, detail];
  }

  void updateCourseDetail(int index, Map<String, dynamic> newDetail) {
    state = [
      for (var detail in state)
        if (detail['idx'] == index) newDetail else detail
    ];
  }

  void removeCourseDetail(Map<String, dynamic> removeDetail) {
    state = state.where((detail) => detail != removeDetail).toList();
  }

  dynamic saveCourse(Map<String, dynamic> course) async {
    final ApiServices api = ApiServices();

    final result = await api.postCourse(course);
    return result;
  }

  dynamic updateCourse(int courseId, Map<String, dynamic> course) async {
    final ApiServices api = ApiServices();

    final result = await api.putCourseDetail(courseId, course);
    return result;
  }
}

final dancerCourseProvider =
    StateNotifierProvider<DancerCourseNotifier, dynamic>((ref) {
  return DancerCourseNotifier();
});

class OldDancerCourseNotifier extends StateNotifier<dynamic> {
  OldDancerCourseNotifier() : super([]);

  void addCourseDetailList(int courseId) async {
    final ApiServices api = ApiServices();

    final result = await api.getCourseDetail(courseId);
    state = result['course'];
  }

  void removeCourseDetail(Map<String, dynamic> removeDetail) {
    state = state.where((detail) => detail != removeDetail).toList();
  }
}

final oldDancerCourseProvider =
    StateNotifierProvider<OldDancerCourseNotifier, dynamic>((ref) {
  return OldDancerCourseNotifier();
});

final getDancerTicketProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getTicketList();
  return result;
});

final getDancerTicketDetailProvider =
    FutureProvider.family<dynamic, int>((ref, ticketId) async {
  final ApiServices api = ApiServices();

  final result = await api.getTicketDetail(ticketId);
  return result;
});

final postDancerTicketDetailProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>(
        (ref, ticketData) async {
  final ApiServices api = ApiServices();

  final result = await api.postTicket(ticketData);
  return result;
});

final putDancerTicketDetailProvider =
    FutureProvider.family<dynamic, List<dynamic>>((ref, args) async {
  final ApiServices api = ApiServices();

  final ticketId = args[0];
  final ticketData = args[1];

  final result = await api.putTicketDetail(ticketId, ticketData);
  return result;
});

final postDancerTicketExpireProvider =
    FutureProvider.family<dynamic, int>((ref, day) async {
  final ApiServices api = ApiServices();

  final result = await api.postTicketExpire(day);
  return result;
});

final ticketCountProvider = StateProvider.autoDispose<dynamic>((ref) {
  return 0;
});

final ticketCostProvider = StateProvider.autoDispose<dynamic>((ref) {
  return 0;
});

final ticketDiscountRateProvider = StateProvider.autoDispose<dynamic>((ref) {
  return 0;
});

final ticketPriceProvider = StateProvider.autoDispose<dynamic>((ref) {
  return 0;
});

final selectDateProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final selectDetailDateProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final courseTitleProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final courseDescriptionProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});
