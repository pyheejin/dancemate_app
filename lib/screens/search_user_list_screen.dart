import 'package:dancemate_app/screens/change_password_screen.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUserListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> users;

  const SearchUserListScreen({
    super.key,
    required this.users,
  });

  @override
  ConsumerState<SearchUserListScreen> createState() =>
      _SearchUserListScreenState();
}

class _SearchUserListScreenState extends ConsumerState<SearchUserListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void errorAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 64, 184, 245),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 64, 184, 245)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        '돌아가기',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 64, 184, 245),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onUserTap(String method, String email) {
    if (method == '이메일 로그인') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(email: email),
        ),
      );
    } else {
      errorAlert(
        context,
        '소셜 계정으로 로그인 한 계정은 해당 플랫폼에서 비밀번호를 찾아야 합니다.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 20,
        ),
        child: Column(
          children: [
            const Text(
              '계정 선택하기',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.users['users'].length,
                itemBuilder: (context, index) {
                  final userData = widget.users['users'][index];
                  int id = userData['id'];
                  String type = userData['type'];
                  String email = userData['email'];
                  String nickname = userData['nickname'];
                  String method = userData['method'];
                  String imageUrl = userData['image_url'];
                  String lastLoginDate = userData['last_login_date'];

                  ImageProvider finalImageProvider;
                  if (imageUrl != '') {
                    if (imageUrl.split(':')[0] == 'https') {
                      finalImageProvider = NetworkImage(imageUrl);
                    } else {
                      finalImageProvider = AssetImage(imageUrl);
                    }
                  } else {
                    // 기본 이미지 경로 설정
                    imageUrl = 'assets/images/app_logo/chat.png';
                    finalImageProvider = AssetImage(imageUrl);
                  }
                  return GestureDetector(
                    onTap: () => _onUserTap(method, email),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              foregroundImage: finalImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[$type] $nickname',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  lastLoginDate,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFC6B6FF)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              method,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFFB172FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
