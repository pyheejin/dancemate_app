import 'dart:convert';

import 'package:dancemate_app/contants/api_urls.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:dancemate_app/widgets/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FlutterSecureStorage를 storage로 저장
  static const storage = FlutterSecureStorage();

  // storage에 있는 유저 정보를 저장
  dynamic userInfo = '';

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    } else {
      print('로그인이 필요합니다');
    }
  }

  void _onLoginTap() async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: {
        'username': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final accessToken = responseBody['access_token'];

      final payload = jsonEncode({emailController.text: accessToken});

      await storage.write(
        key: 'login',
        value: payload,
      );

      emailController.clear();
      passwordController.clear();

      final value = await storage.read(key: 'login');
      print(value);

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text('DanceMate'),
              ),
            ),
            const SizedBox(height: 80),
            const Row(
              children: [
                Text('이메일'),
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                suffixIcon: const Icon(Icons.cancel_outlined),
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text('비밀번호'),
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                suffixIcon: const Icon(Icons.cancel_outlined),
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: _onLoginTap,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFA48AFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text('Forgot your password?'),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text("Don't have an account?"),
                SizedBox(width: 5),
                Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xFFA48AFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'or sign up with',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/images/kakao_logo.png'),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/images/google_logo.png'),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/images/apple_logo.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
