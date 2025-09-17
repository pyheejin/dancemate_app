import 'dart:convert';
import 'package:dancemate_app/provider/main_tap_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/search_user_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordScreen extends ConsumerWidget {
  final email;

  const ChangePasswordScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordAgainController =
        TextEditingController();

    void onClearTap(TextEditingController controller) {
      controller.clear();
    }

    void onChangePasswordTap() async {
      // 비밀번호 재설정
      Map<String, dynamic> body = {
        'email': email,
        'password': passwordController.text,
        'password_again': passwordAgainController.text,
      };
      final changePasswordResult =
          await ref.watch(putUserChangePasswordProvider(body).future);
      print('========$changePasswordResult');
      if (changePasswordResult['result_code'] == 200) {
        // 재 로그인
        List<dynamic> args = [
          email,
          passwordController.text,
        ];
        final result = await ref.watch(postUserLoginProvider(args).future);

        if (result['result_code'] == 200) {
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'login');

          final userId = result['user_id'];
          final userType = result['type'];
          final accessToken = result['access_token'];

          final payload = jsonEncode({
            'userId': userId,
            'userType': userType,
            'email': email,
            'access_token': accessToken,
          });

          await storage.write(
            key: 'login',
            value: payload,
          );

          ref.read(mainTapProvider.notifier).update((state) => 0);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        } else {
          errorAlert(context, result['result_msg']);
        }
      } else {
        errorAlert(context, changePasswordResult['result_msg']);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 250,
            horizontal: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text('비밀번호'),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      onClearTap(passwordController);
                    },
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text('비밀번호 재입력'),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordAgainController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password again',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      onClearTap(passwordController);
                    },
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: onChangePasswordTap,
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
                        '비밀번호 재설정',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
