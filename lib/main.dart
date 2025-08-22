import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:dancemate_app/config.dart';
import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';

// 백그라운드에서 FCM 메시지를 처리하는 핸들러.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 메시지 처리를 위해 Firebase 초기화가 필요할 수 있습니다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('✅ 백그라운드 메시지 수신: ${message.messageId}');
  // TODO: 여기에 백그라운드 알림 데이터 처리 로직
}

// 포그라운드 알림을 표시하고, 로컬 알림 시스템을 초기화합니다.
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 로컬 알림 시스템을 초기화합니다.
  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      print('🔔 알림 응답 수신: ${response.payload}');
      // TODO: 사용자가 알림을 탭했을 때의 동작
    });
  }

  // FCM 포그라운드 메시지를 수신하고 로컬 알림으로 표시합니다.
  void setupFCMForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('✨✨✨ 포그라운드 알림 도착! (${message.messageId})');
      print('메시지 데이터: ${message.data}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android; // Android 알림
      AppleNotification? apple = notification?.apple; // IOS 알림
      print('android: $android');
      print('apple: $apple');

      // Android 및 iOS 알림 표시
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode, // 알림 ID (고유해야 함)
        notification!.title,
        notification.body,
        NotificationDetails(
          android: android != null
              ? AndroidNotificationDetails(
                  'high_importance_channel', // Android 채널 ID (고유해야 하며, 앱 설치 시 한번만 생성)
                  'High Importance Notifications', // 채널 이름
                  channelDescription:
                      'This channel is used for important notifications.', // 채널 설명
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: android.smallIcon, // Android 알림 아이콘
                  // sound: RawResourceAndroidNotificationSound('your_custom_sound'), // 커스텀 사운드 (선택 사항)
                )
              : null,
          iOS: apple != null
              ? const DarwinNotificationDetails(
                  // sound: 'your_custom_sound.aiff', // iOS 커스텀 사운드 (선택 사항)
                  presentAlert: false,
                  presentBadge: true,
                  presentSound: true,
                )
              : null,
        ),
        payload: jsonEncode(message.data), // 알림 클릭 시 전달할 데이터
      );
      print('📣 알림 제목: ${notification.title}, 내용: ${notification.body}');
    });
  }

  // 앱이 종료된 상태에서 알림을 클릭했을 때의 초기 메시지를 처리합니다.
  Future<void> handleInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('🚀 앱 종료 상태에서 받은 알림: ${initialMessage.data}');
      // TODO: 사용자가 알림을 탭했을 때의 동작
    }
  }
}

void main() async {
  // Flutter 위젯 바인딩 초기화: Flutter 엔진과 플러그인의 상호작용을 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Kakao SDK 초기화
  KakaoSdk.init(nativeAppKey: kakaoNativeKey);

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 알림 서비스 인스턴스 생성
  final notificationService = NotificationService();

  // 로컬 알림 초기화
  await notificationService.initializeLocalNotifications();

  // iOS foreground notification 권한
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: true,
    sound: false,
  );

  // FCM 알림 권한 요청
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('✅ 사용자 알림 권한 허용 상태: ${settings.authorizationStatus}');

  // 백그라운드 FCM 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 포그라운드 FCM 메시지 처리 설정
  notificationService.setupFCMForegroundNotifications();

  // 앱이 종료된 상태에서 받은 초기 메시지 처리
  await notificationService.handleInitialMessage();

  initializeDateFormatting().then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });

  // FCM 토큰 가져오기 및 출력
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

    print('FCM Token: $fcmToken');
    print('APNS Token: $apnsToken');
  } catch (e) {
    print('🔑 토큰 가져오기 오류 발생: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 위젯이 생성될 때 로그인 상태 확인
  }

  void _checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    try {
      String? data = await storage.read(key: 'login');
      if (data != null) {
        String accessToken = json.decode(data)['access_token'];
        if (accessToken.isNotEmpty) {
          setState(() {
            _isLoggedIn = true;
          });
        }
      }
    } catch (e) {
      print('❌ 로그인 상태 확인 중 오류 발생: $e');
      setState(() {
        _isLoggedIn = false;
      });
    } finally {
      // 로그인 상태 확인이 완료되면 로딩 상태 해제
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때는 로딩 스피너를 보여줍니다.
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'DanceMate App', // 앱의 제목
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isLoggedIn ? const MainNavigationScreen() : const LoginScreen(),
    );
  }
}
