import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTicketSalesProvider =
    FutureProvider.family<dynamic, List<dynamic>>((ref, args) async {
  final ApiServices api = ApiServices();

  int year = args[0];
  int month = args[1];

  final result = await api.getTicketSalesList(year, month);
  return result;
});
