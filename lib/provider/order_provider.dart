import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTicketPriceProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final selectedEasyPaymentProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final selectedCardPaymentProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final selectedDepositPaymentProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final selectedEasyNaverKakaoPaymentProvider =
    StateProvider.autoDispose<int>((ref) {
  return 0;
});

final postPaymentProvider =
    FutureProvider.family<dynamic, int>((ref, ticketId) async {
  final ApiServices api = ApiServices();

  final result = await api.postPayment(ticketId);
  return result;
});
