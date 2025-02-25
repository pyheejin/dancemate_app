import 'package:dancemate_app/database/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSearchProvider =
    FutureProvider.family<dynamic, dynamic>((ref, keyword) async {
  final ApiServices api = ApiServices();

  final result = await api.getSearch(keyword);
  return result;
});

final getSearchPreProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getSearchPre();
  return result;
});

final searchKeywordProvider =
    StateProvider.family<String, String>((ref, keyword) {
  return keyword;
});
