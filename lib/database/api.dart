import 'dart:convert';

import 'package:dancemate_app/contants/api_urls.dart';
import 'package:dancemate_app/database/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiServices {
  final storage = const FlutterSecureStorage();

  dynamic getAccessToken() async {
    String accessToken = '';

    final loginStorage = await storage.read(key: 'login');
    if (loginStorage!.isNotEmpty) {
      accessToken = jsonDecode(loginStorage)['access_token'];
    }
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

    if (response.statusCode == 200) {
      final resultData =
          jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
      final recommendUsers = resultData['recommend_users'];

      return List<RecommendUserModel>.from(
        recommendUsers.map((map) => RecommendUserModel.fromJson(map)),
      );
    } else {
      print('api error ${response.statusCode}');
      throw const FormatException('home api error');
    }
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

    return List<HomeCourseModel>.from(
      reserveCourses.map((map) => HomeCourseModel.fromJson(map)),
    );
  }

  Future<Map<String, dynamic>> postUserLogin(
      String email, String password) async {
    await storage.delete(key: 'login');

    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: {
        'username': email,
        'password': password,
      },
    );

    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    if (resultData['result_code'] == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final accessToken = responseBody['access_token'];

      final payload = jsonEncode({
        'email': email,
        'access_token': accessToken,
      });

      await storage.write(
        key: 'login',
        value: payload,
      );
      return responseBody;
    } else {
      throw Exception('user login api fail');
    }
  }

  Future<Map<String, dynamic>> postUserJoin(UserModel userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/join'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': userData.type,
        'name': userData.name,
        'nickname': userData.nickname,
        'email': userData.email,
        'password': userData.password,
        'phone': userData.phone,
        'introduction': userData.introduction,
      }),
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    if (resultData['result_code'] == 200) {
      // 회원가입 후 바로 로그인
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/user/login'),
        body: {
          'username': userData.email,
          'password': userData.password,
        },
      );

      if (loginResponse.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(loginResponse.bodyBytes));
        final accessToken = responseBody['access_token'];

        final payload = jsonEncode({
          'email': userData.email,
          'access_token': accessToken,
        });

        await storage.write(
          key: 'login',
          value: payload,
        );
      }
      return resultData;
    } else {
      throw Exception('user join api fail');
    }
  }
}
