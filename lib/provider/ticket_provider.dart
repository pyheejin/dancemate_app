import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTicketSalesProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getTicketSalesList();
  return result;
});
