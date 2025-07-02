import 'package:dancemate_app/database/api.dart';
import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/screens/signup_screen.dart';
import 'package:dio/dio.dart';
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

final profileImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final getUserProfileProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserProfile();
  return result;
});

final postUserProfileProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, bodyData) async {
  final ApiServices api = ApiServices();

  final result = await api.postUserProfile(bodyData);
  return result;
});

final postUserProfileImageProvider =
    FutureProvider.family<dynamic, FormData>((ref, bodyData) async {
  final ApiServices api = ApiServices();

  final result = await api.postUserProfileImage(bodyData);
  return result;
});

final getUserDetailProvider =
    FutureProvider.family<dynamic, int>((ref, userId) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserDetail(userId);
  return result;
});

final getUserTicketProvider =
    FutureProvider.family<dynamic, dynamic>((ref, dancerId) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserTicket(dancerId);
  return result;
});

final getUserCourseProvider = FutureProvider<dynamic>((ref) async {
  final ApiServices api = ApiServices();

  final result = await api.getUserCourse();
  return result;
});
