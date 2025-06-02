import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDancerProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
