import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림설정'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            NotificationMenu(
              name: '수업 관련 알림',
              isActivate: true,
            ),
            NotificationMenu(
              name: '티켓 관련 알림',
              isActivate: true,
            ),
            NotificationMenu(
              name: '커뮤니티 관련 알림',
              isActivate: false,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationMenu extends StatelessWidget {
  final name;
  final isActivate;

  const NotificationMenu({
    super.key,
    this.name,
    this.isActivate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
            CupertinoSwitch(
              value: isActivate,
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool? value) {
                print(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
