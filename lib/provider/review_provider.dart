import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseReviewRateProvider = StateProvider.autoDispose<double>((ref) {
  return 1;
});
