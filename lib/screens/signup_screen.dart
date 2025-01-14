import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserType { Dancer, Mate }

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController introductionController =
        TextEditingController();

    UserType userType = UserType.Mate;

    void showSnackBar(BuildContext context, Text text) {
      final snackBar = SnackBar(
        content: text,
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void onSignUpTap() async {
      final email = emailController.text;
      final password = passwordController.text;
      final nickname = nicknameController.text;
      final name = nameController.text;
      final phone = phoneController.text;
      final introduction = introductionController.text;

      UserModel userData = UserModel(
        type: userType == UserType.Dancer ? 50 : 1,
        email: email,
        password: password,
        nickname: nickname,
        name: name,
        phone: phone,
        introduction: introduction,
      );

      final result = await ref.watch(postUserJoinProvider(userData).future);
      if (result['result_code'] == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      } else {
        showSnackBar(context, const Text('회원가입 실패'));
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 50,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: UserType.Dancer,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          userType =
                              ref.watch(userTypeProvider(UserType.Dancer));
                        },
                      ),
                      const Text(
                        '댄서',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: UserType.Mate,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          userType = ref.watch(userTypeProvider(UserType.Mate));
                        },
                      ),
                      const Text(
                        '메이트',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '이메일',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: TextField(
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
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '비밀번호',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: TextField(
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
                    suffixIcon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '닉네임',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '이름',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: '',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '본인인증',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: '핸드폰 번호(숫자만 입력)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '인증번호',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: const Icon(Icons.cancel_outlined),
                      ),
                    ),
                  ),
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
                            '인증번호 전송',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    '자기소개',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: introductionController,
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: onSignUpTap,
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
                    '회원가입',
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
        ),
      ),
    );
  }
}
