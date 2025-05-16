import 'dart:convert';

import 'package:dancemate_app/contants/api_urls.dart';
import 'package:dancemate_app/database/model.dart';
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

  Future<dynamic> getHome() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/home'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
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
      final userId = responseBody['user_id'];
      final accessToken = responseBody['access_token'];

      final payload = jsonEncode({
        'userId': userId,
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

  Future<dynamic> getSearch(String keyword) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/search?keyword=$keyword'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getSearchPre() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/search/pre'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getUserProfile() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data']['user'];

    return resultData;
  }

  Future<dynamic> getUserTicket(int dancerId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/ticket?dancer_id=$dancerId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getUserCourse() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/course'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getCourses(String date) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/course?date=$date'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final reserveCourses = resultData['courses'];

    return reserveCourses;
  }

  Future<dynamic> postCourse(Map<String, dynamic> courseData) async {
    final accessToken = await getAccessToken();

    final body = jsonEncode(courseData);

    final response = await http.post(
      Uri.parse('$baseUrl/course'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> putCourseDetail(
    int courseId,
    Map<String, dynamic> courseData,
  ) async {
    final accessToken = await getAccessToken();

    final body = jsonEncode(courseData);

    final response = await http.put(
      Uri.parse('$baseUrl/course/$courseId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> getCourseDetail(int courseId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/course/$courseId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final reserveCourses = resultData['course'];

    return reserveCourses;
  }

  Future<dynamic> getCourseDetailDetail(int courseDetailId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/course-detail/$courseDetailId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];
    final reserveCourses = resultData['course_detail'];

    return reserveCourses;
  }

  Future<dynamic> getCourseDetailReserve(int courseDetailId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/course/$courseDetailId/reserve'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> postCourseDetailReserve(
    int courseDetailId,
    int userTicketId,
  ) async {
    final accessToken = await getAccessToken();

    dynamic body = {
      'user_ticket_id': userTicketId,
    };
    body = jsonEncode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/course/$courseDetailId/reserve'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> postCourseDetailCancel(int courseDetailId) async {
    final accessToken = await getAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl/course/$courseDetailId/cancel'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> postCourseDetailExists(int courseDetailId) async {
    final accessToken = await getAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl/course/$courseDetailId/exists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> getCourseLike() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/course/like'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> postCourseDetailLike(int courseId) async {
    final accessToken = await getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/course/$courseId/like'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> postPayment(int ticketId) async {
    final accessToken = await getAccessToken();

    dynamic body = {
      'ticket_id': ticketId,
    };
    body = jsonEncode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/payment'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> getDancerDetailTicket(int dancerId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/dancer/$dancerId/ticket'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getDancerCourse() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/dancer/course'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getTicketList() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/ticket'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data'];

    return resultData;
  }

  Future<dynamic> getTicketDetail(int ticketId) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/ticket/$ticketId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final resultData =
        jsonDecode(utf8.decode(response.bodyBytes))['result_data']['ticket'];

    return resultData;
  }

  Future<dynamic> postTicket(Map<String, dynamic> ticketData) async {
    final accessToken = await getAccessToken();

    dynamic body = {
      'status': ticketData['status'],
      'count': ticketData['count'],
      'cost': ticketData['cost'],
      'discount_rate': ticketData['discount_rate'],
    };
    body = jsonEncode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/ticket'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> putTicketDetail(
      int ticketId, Map<String, dynamic> ticketData) async {
    final accessToken = await getAccessToken();

    dynamic body = {
      'status': ticketData['status'],
      'count': ticketData['count'],
      'cost': ticketData['cost'],
      'discount_rate': ticketData['discount_rate'],
    };
    body = jsonEncode(body);

    final response = await http.put(
      Uri.parse('$baseUrl/ticket/$ticketId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }

  Future<dynamic> postTicketExpire(int day) async {
    final accessToken = await getAccessToken();

    dynamic body = {
      'day': day,
    };
    body = jsonEncode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/ticket/expire'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final resultData = jsonDecode(utf8.decode(response.bodyBytes));

    return resultData;
  }
}
