import 'dart:convert';

import 'package:dancemate_app/config.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 푸쉬 알림 수신 코드 (백그라운드)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: kakaoNativeKey);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var token = await FirebaseMessaging.instance.getToken();
  print("Device Token: ${token ?? 'No Token'}");

  // Android 알림 아이콘 설정
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS 알림 설정
  const DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 알림 수신 권한 허용
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // 푸쉬 알림 수신 코드 (백그라운드)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 푸쉬 알림 수신 코드 (포그라운드)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('포그라운드 알림 도착!');
    print('메시지 데이터: ${message.data}');
    if (message.notification != null) {
      print('알림 제목: ${message.notification!.title}');
      print('알림 내용: ${message.notification!.body}');
    }
  });

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    // 앱이 시작되자마자 알림 데이터 처리
    print('앱 종료 상태에서 받은 알림: ${initialMessage.data}');
  }

  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  void isloginData() async {
    const storage = FlutterSecureStorage();

    String? data = await storage.read(key: 'login');
    if (data != null) {
      String accessToken = json.decode(data)['access_token'];

      if (accessToken != '') {
        setState(() {
          isLogin = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    isloginData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLogin ? const MainNavigationScreen() : const LoginScreen(),
    );
  }
}
