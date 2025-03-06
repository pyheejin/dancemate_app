import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainTapProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});
