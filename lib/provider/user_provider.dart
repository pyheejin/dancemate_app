import 'package:dancemate_app/database/api.dart';
import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUserLoginProvider =
    FutureProvider.family<Map<String, dynamic>, List<dynamic>>(
        (ref, args) async {
  final email = args[0];
  final password = args[1];
  final ApiServices api = ApiServices();

  final result = await api.postUserLogin(email, password);
  return result;
});

final postUserJoinProvider =
    FutureProvider.family<Map<String, dynamic>, UserModel>(
        (ref, userData) async {
  final ApiServices api = ApiServices();

  final result = await api.postUserJoin(userData);
  return result;
});

final userTypeProvider = StateProvider.family<UserType, UserType>((ref, type) {
  return type;
});
