import 'dart:convert';

import 'package:dancemate_app/contants/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogintNotifier extends StateNotifier<int> {
  LogintNotifier(this.ref) : super(0);

  final Ref ref;
  final storage = const FlutterSecureStorage();

  Future<bool> postLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
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
      return true;
    } else {
      return false;
    }
  }

  void postLogout() async {
    await storage.delete(key: 'login');
  }
}

final postLoginProvider = StateNotifierProvider<LogintNotifier, int>(
  (ref) => LogintNotifier(ref),
);
