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

  void removeCourseDetail(Map<String, dynamic> removeDetail) {
    state = state.where((detail) => detail != removeDetail).toList();
  }
}

final dancerCourseProvider =
    StateNotifierProvider<DancerCourseNotifier, dynamic>((ref) {
  return DancerCourseNotifier();
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

final ticketActiveProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
