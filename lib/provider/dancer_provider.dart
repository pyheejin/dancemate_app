import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDancerDetailTicketProvider =
    FutureProvider.family<dynamic, dynamic>((ref, dancerId) async {
  final ApiServices api = ApiServices();

  final result = await api.getDancerDetailTicket(dancerId);
  return result;
});
