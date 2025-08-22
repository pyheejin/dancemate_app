import 'package:dancemate_app/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationData = ref.watch(getUserNotificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: notificationData.when(
        data: (notifications) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: ListView.builder(
              itemCount: notifications['notices'].length,
              itemBuilder: (context, index) {
                final noticeData = notifications['notices'][index];
                final date = noticeData['date'];
                final notificationList = noticeData['notification_list'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        final title = notificationList[index]['title'];
                        final description =
                            notificationList[index]['description'];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xAAEFEEEE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title),
                                Text(description),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
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
