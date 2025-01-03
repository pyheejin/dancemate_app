import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void onLoginTap() async {
      final email = emailController.text;
      final password = passwordController.text;

      final loginResult =
          ref.read(postLoginProvider.notifier).postLogin(email, password);

      if (loginResult == true) {}
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    }

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
              onPressed: onLoginTap,
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
                      '로그인',
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
                Text('비밀번호를 잊으셨나요?'),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: Color(0xFFA48AFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '소셜 로그인',
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
