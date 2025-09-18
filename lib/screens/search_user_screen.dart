import 'package:dancemate_app/provider/user_provider.dart';
import 'package:dancemate_app/screens/search_user_list_screen.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUserScreen extends ConsumerWidget {
  const SearchUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();

    void onSearchTap(String email) async {
      final result = await ref.watch(getUsersProvider(email).future);
      if (result['result_code'] == 200) {
        final userList = result['result_data'];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchUserListScreen(users: userList),
          ),
        );
      } else {
        errorAlert(context, result['result_msg']);
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 200,
            horizontal: 20,
          ),
          child: Column(
            children: [
              const Text(
                '비밀번호 찾기',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 70),
              const Row(
                children: [
                  Text(
                    '*이메일',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => onSearchTap(emailController.text),
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
                        '조회하기',
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
