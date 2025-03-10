import 'package:dancemate_app/screens/like_course_screen.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/screens/notification_screen.dart';
import 'package:dancemate_app/screens/ticket_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingMenu(
              name: '찜한 수업',
              screen: LikeCourseScreen(),
            ),
            const SettingMenu(
              name: '티켓 구매 내역',
              screen: TicketHistoryScreen(),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SettingMenu(
              name: '알림 설정',
              screen: NotificationScreen(),
            ),
            const SettingMenu(
              name: '문의하기',
              screen: SettingScreen(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                '앱 버전 (0.1)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SettingMenu(
              name: '로그아웃',
              screen: SettingScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingMenu extends StatelessWidget {
  final name;
  final screen;

  const SettingMenu({
    super.key,
    this.name,
    this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (name == '로그아웃') {
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'login');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
