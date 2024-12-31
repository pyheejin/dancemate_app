import 'dart:convert';

import 'package:dancemate_app/contants/api_urls.dart';
import 'package:dancemate_app/database/model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiServices {
  final storage = const FlutterSecureStorage();

  dynamic getAccessToken() async {
    final loginStorage = await storage.read(key: 'login');
    final accessToken = jsonDecode(loginStorage!)['access_token'];
    return accessToken;
  }

  Future<List<RecommendUserModel>> getHomeRecommendUsers() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/home'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final recommendUsers = resultData['recommend_users'];

    return List<RecommendUserModel>.from(
      recommendUsers.map((map) => RecommendUserModel.fromJson(map)),
    );
  }

  Future<List<HomeCourseModel>> getHomeTodayCourses() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/home'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final todayCourses = resultData['today_courses'];
    print(todayCourses);

    return List<HomeCourseModel>.from(
      todayCourses.map((map) => HomeCourseModel.fromJson(map)),
    );
  }

  Future<List<HomeCourseModel>> getHomeReserveCourses() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/home'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final reserveCourses = resultData['reserve_courses'];
    print(reserveCourses);

    return List<HomeCourseModel>.from(
      reserveCourses.map((map) => HomeCourseModel.fromJson(map)),
    );
  }
}
