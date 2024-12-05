import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                Text('Email'),
              ],
            ),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 161, 147, 147),
                    width: 1.0,
                  ),
                ),
                suffixIcon: Icon(Icons.cancel_outlined),
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text('Password'),
              ],
            ),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 161, 147, 147),
                    width: 1.0,
                  ),
                ),
                suffixIcon: Icon(Icons.cancel_outlined),
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {},
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
