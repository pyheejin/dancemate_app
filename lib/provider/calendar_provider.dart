import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectDateProvider = StateProvider.family<String, dynamic>((ref, date) {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final stringDate = dateFormat.format(date);
  return stringDate;
});
