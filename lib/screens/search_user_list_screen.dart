import 'package:dancemate_app/screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUserListScreen extends ConsumerStatefulWidget {
  Map<String, dynamic> users;

  SearchUserListScreen({
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

  void _onUserTap(String email) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangePasswordScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 100),
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
                      onTap: () => _onUserTap(email),
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
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFC6B6FF)),
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
      ),
    );
  }
}
