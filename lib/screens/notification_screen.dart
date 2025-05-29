import 'package:dancemate_app/provider/notification_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationData = ref.watch(getNotificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림설정'),
      ),
      body: notificationData.when(
        data: (notification) {
          bool lessonNotice = notification['lesson'];
          bool ticketNotice = notification['ticket'];
          bool communityNotice = notification['community'];

          return Padding(
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
                        value: lessonNotice,
                        activeColor: const Color(0xFFA48AFF),
                        onChanged: (bool? value) async {
                          final result = await ref
                              .read(notificationProvider.notifier)
                              .postNotification({
                            'lesson': value!,
                            'ticket': ticketNotice,
                            'community': communityNotice,
                          });
                          if (result['result_code'] == 200) {
                            ref.refresh(getNotificationProvider);
                          }
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
                        value: ticketNotice,
                        activeColor: const Color(0xFFA48AFF),
                        onChanged: (bool? value) async {
                          final result = await ref
                              .read(notificationProvider.notifier)
                              .postNotification({
                            'lesson': lessonNotice,
                            'ticket': value!,
                            'community': communityNotice,
                          });
                          if (result['result_code'] == 200) {
                            ref.refresh(getNotificationProvider);
                          }
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
                        value: communityNotice,
                        activeColor: const Color(0xFFA48AFF),
                        onChanged: (bool? value) async {
                          final result = await ref
                              .read(notificationProvider.notifier)
                              .postNotification({
                            'lesson': lessonNotice,
                            'ticket': ticketNotice,
                            'community': value!,
                          });
                          if (result['result_code'] == 200) {
                            ref.refresh(getNotificationProvider);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) {
          print(error);

          return SizedBox(
            width: 300,
            child: Text('error: $error'),
          );
        },
      ),
    );
  }
}
