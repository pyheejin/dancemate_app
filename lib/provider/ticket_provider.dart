import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTicketSalesProvider =
    FutureProvider.family<dynamic, String>((ref, args) async {
  final ApiServices api = ApiServices();

  int year = int.parse(args.split('-')[0]);
  int month = int.parse(args.split('-')[1]);

  final result = await api.getTicketSalesList(year, month);
  return result;
});
