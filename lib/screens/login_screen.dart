import 'package:dancemate_app/database/model.dart';
import 'package:dancemate_app/google_sign_in_service.dart';
import 'package:dancemate_app/provider/main_tap_provider.dart';
import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/signup_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

enum UserType { Dancer, Mate }

class LoginScreen extends ConsumerWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void onClearTap(TextEditingController controller) {
      controller.clear();
    }

    void onLoginTap() async {
      List<dynamic> args = [
        emailController.text,
        passwordController.text,
      ];
      final result = await ref.watch(postUserLoginProvider(args).future);

      if (result['result_code'] == 200) {
        ref.read(mainTapProvider.notifier).update((state) => 0);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );

        // // FCM 토큰 발급받기
        // final req = await FirebaseMessaging.instance.requestPermission(
        //   alert: true,
        //   badge: true,
        //   sound: true,
        // );
        // final fcmToken = await FirebaseMessaging.instance.getToken();
        // if (req.authorizationStatus == AuthorizationStatus.authorized &&
        //     fcmToken != null) {
        //   print('FCM Token: $fcmToken');
        // } else {
        //   print('FCM Token: null');
        // }
      }
    }

    void onSocialLoginTap(int method) async {
      if (method == 2) {
        final GoogleSignInService signInService = GoogleSignInService();
        final account = await signInService.signInWithGoogle();
        if (account != null) {
          if (account.additionalUserInfo != null) {
            final isNewUser = account.additionalUserInfo!.isNewUser;
            final credential = '${account.credential!.token}';

            final userData = account.additionalUserInfo!.profile;
            final email = userData!['email'];
            final password = '${account.credential!.token}';
            final nickname = userData['given_name'];
            final name = userData['name'];
            final imageUrl = userData['picture'];
            const phone = '';
            const introduction = '';
            if (isNewUser) {
              // 신규 회원일 경우에만 회원가입 진행
              UserModel user = UserModel(
                type: 1,
                method: method,
                email: email,
                password: password,
                nickname: nickname,
                name: name,
                phone: phone,
                introduction: introduction,
                imageUrl: imageUrl,
              );

              final result = await ref.watch(postUserJoinProvider(user).future);
              if (result['result_code'] == 200) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen(),
                  ),
                );
              } else {
                errorAlert(context, result['result_msg']);
              }
            } else {
              List<dynamic> args = [
                email,
                credential,
              ];
              final result =
                  await ref.watch(postUserLoginProvider(args).future);

              if (result['result_code'] == 200) {
                ref.read(mainTapProvider.notifier).update((state) => 0);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen(),
                  ),
                );
              }
            }
          }
        }
      } else if (method == 3) {
        // 휴대폰에 카카오톡이 깔려있는지 bool 값으로 반환해주는 함수
        bool installed = await isKakaoTalkInstalled();

        // 깔려있다면 UserApi.instance.loginWithKakaoTalk() 으로 카카오톡 오픈 후 동의
        // 깔려있지 않다면 UserApi.instance.loginWithKakaoAccount() 으로 웹을 통한 인증
        OAuthToken token = installed
            ? await UserApi.instance.loginWithKakaoTalk()
            : await UserApi.instance.loginWithKakaoAccount();

        // 위 두가지 방법으로 인증 로그인 성공 후 유저 정보 가져오기
        User user = await UserApi.instance.me();

        final id = user.id.toString();
        final email = user.kakaoAccount!.email.toString();
        final nickname = user.properties!['nickname'].toString();
        final imageUrl = user.properties!['profile_image'].toString();

        // 서버로 유저 정보 전송하여 데이터베이스에 저장하기
        // 신규 회원일 경우에만 회원가입 진행
        UserModel userData = UserModel(
          type: 1,
          method: method,
          email: email,
          password: id,
          nickname: nickname,
          name: nickname,
          phone: '',
          introduction: '',
          imageUrl: imageUrl,
        );

        try {
          final result = await ref.watch(postUserJoinProvider(userData).future);
          if (result['result_code'] == 200) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MainNavigationScreen(),
              ),
            );
          } else {
            print(result['result_msg']);
            errorAlert(context, result['result_msg']);
          }
        } catch (e) {
          final resultCode = e.toString().split(' ')[1];
          if (resultCode == '207') {
            // 이미 가입된 이메일이면 로그인처리
            List<dynamic> args = [
              email,
              id,
            ];
            final loginResult =
                await ref.watch(postUserLoginProvider(args).future);

            if (loginResult['result_code'] == 200) {
              ref.read(mainTapProvider.notifier).update((state) => 0);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MainNavigationScreen(),
                ),
              );
            } else {
              print(loginResult['result_msg']);
              errorAlert(context, loginResult['result_msg']);
            }
          }
        }
      }
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
            SizedBox(
              width: 200,
              height: 120,
              child: Center(
                child: Image.asset(
                  'assets/images/app_logo/detail_2x.png',
                ),
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    onClearTap(emailController);
                  },
                  child: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.black54,
                  ),
                ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
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
                      fontWeight: FontWeight.bold,
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
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
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
                  GestureDetector(
                    onTap: () {
                      onSocialLoginTap(3);
                    },
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/images/kakao_logo.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSocialLoginTap(2);
                    },
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/images/google_logo.png'),
                    ),
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
