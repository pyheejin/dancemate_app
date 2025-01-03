import 'package:dancemate_app/screens/login_screen.dart';
import 'package:dancemate_app/screens/main_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
    print(data);
    if (data != null) {
      setState(() {
        isLogin = true;
      });
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
