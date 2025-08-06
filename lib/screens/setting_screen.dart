import 'dart:async';
import 'dart:convert';

import 'package:dancemate_app/provider/setting_provider.dart';
import 'package:dancemate_app/screens/course_history_screen.dart';
import 'package:dancemate_app/screens/dancer_course_screen.dart';
import 'package:dancemate_app/screens/dancer_ticket_screen.dart';
import 'package:dancemate_app/screens/like_course_screen.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/screens/my_page_screen.dart';
import 'package:dancemate_app/screens/notification_screen.dart';
import 'package:dancemate_app/screens/qna_screen.dart';
import 'package:dancemate_app/screens/ticket_history_screen.dart';
import 'package:dancemate_app/screens/ticket_sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  // 위젯이 생성될 때 한 번만 호출되도록 initState 사용
  @override
  void initState() {
    super.initState();
    isloginData();
  }

  Future<void> isloginData() async {
    const storage = FlutterSecureStorage();
    String? data = await storage.read(key: 'login');
    if (data != null) {
      int type = json.decode(data)['userType'];
      ref
          .read(accessTokenProvider.notifier)
          .update((state) => json.decode(data)['access_token']);

      if (type == 50) {
        ref.read(isDancerProvider.notifier).update((state) => true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDancer = ref.watch(isDancerProvider);
    String accessToken = ref.watch(accessTokenProvider);

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
              name: '마이페이지',
              screen: MyPageScreen(),
            ),
            const SettingMenu(
              name: '수업 수강 내역',
              screen: CourseHistoryScreen(),
            ),
            const SettingMenu(
              name: '티켓 구매 내역',
              screen: TicketHistoryScreen(),
            ),
            if (isDancer) ...[
              // isDancer가 true일 때만 위젯들을 표시
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SettingMenu(
                name: '수업 관리',
                screen: DancerCourseScreen(),
              ),
              const SettingMenu(
                name: '티켓 관리',
                screen: DancerTicketScreen(),
              ),
              const SettingMenu(
                name: '티켓 판매 내역',
                screen: TicketSalesScreen(),
              ),
            ],
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
              screen: QnaScreen(),
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
            ),
          ],
        ),
      ),
    );
  }
}

class SettingMenu extends StatelessWidget {
  final String name;
  final Widget? screen; // screen을 nullable로 변경

  const SettingMenu({
    super.key,
    required this.name, // name은 필수 값으로 변경
    this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (name == '로그아웃') {
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'login');

          // Navigator를 사용하여 모든 이전 화면을 제거하고 LoginScreen으로 이동
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );

          // 로그아웃 api 호출
        } else if (screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => screen!,
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
