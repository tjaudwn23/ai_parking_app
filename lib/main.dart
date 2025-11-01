/// 앱의 진입점(main.dart)
/// - Flutter 앱의 시작점으로, 앱 전체 구조를 설정합니다.
/// - UserProvider를 전역적으로 제공하여 앱 전체에서 사용자 상태를 관리합니다.
/// - AuthWrapper를 통해 로그인 상태에 따라 LoginScreen 또는 MainScreen을 표시합니다.
library;

import 'package:ai_parking/presentation/login/login_screen.dart';
import 'package:ai_parking/presentation/main/main_screen.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

/// 앱의 루트 위젯(MyApp)
/// - MaterialApp을 설정하고 기본 테마를 정의합니다.
/// - AuthWrapper를 홈 화면으로 설정하여 인증 상태에 따라 화면을 전환합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Parking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

/// 인증 상태 래퍼 위젯(AuthWrapper)
/// - UserProvider의 isLoggedIn 상태를 감시합니다.
/// - 로그인되어 있으면 MainScreen을, 아니면 LoginScreen을 표시합니다.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return userProvider.isLoggedIn
            ? const MainScreen()
            : const LoginScreen();
      },
    );
  }
}
