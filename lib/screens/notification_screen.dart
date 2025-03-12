import 'package:dancemate_app/provider/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool courseNotification = ref.watch(courseNotificationProvider);
    bool ticketNotification = ref.watch(ticketNotificationProvider);
    bool communityNotification = ref.watch(communityNotificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '수업 관련 알림',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CupertinoSwitch(
                    value: courseNotification,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (bool? value) {
                      ref
                          .read(courseNotificationProvider.notifier)
                          .update((state) => value!);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '티켓 관련 알림',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CupertinoSwitch(
                    value: ticketNotification,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (bool? value) {
                      ref
                          .read(ticketNotificationProvider.notifier)
                          .update((state) => value!);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '커뮤니티 관련 알림',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CupertinoSwitch(
                    value: communityNotification,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (bool? value) {
                      ref
                          .read(communityNotificationProvider.notifier)
                          .update((state) => value!);
                    },
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
