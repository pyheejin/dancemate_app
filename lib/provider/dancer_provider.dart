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
