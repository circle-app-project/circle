import 'package:circle/core/routes/routes.dart';
import 'package:circle/crashytics_service.dart';
import 'package:circle/databse_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:springster/springster.dart';

import 'core/core.dart';
import 'firebase_options.dart';

late LocalDatabaseService database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize database with Admin
  await LocalDatabaseService.instance.initialize(
    startAdmin: kDebugMode,
    adminPort: 8091,
  );
  database = LocalDatabaseService.instance;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize crashlytics
  CrashlyticsService.initialize();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Circle',
      debugShowCheckedModeBanner: true,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.system,
      themeAnimationStyle: AnimationStyle(
        curve: Spring.defaultIOS.toCurve,
        duration: const Duration(milliseconds: 300),
      ),
      routerConfig: _router.config(),
      // home: const AuthSuccessScreen()
    );
    // child: MaterialApp(
    //   title: 'Circle',
    //   debugShowCheckedModeBanner: true,
    //   theme: AppThemeData.lightTheme,
    //   darkTheme: AppThemeData.darkTheme,
    //   themeMode: ThemeMode.system,
    //   themeAnimationStyle: AnimationStyle(
    //     curve: Spring.defaultIOS.toCurve,
    //     duration: const Duration(milliseconds: 300),
    //   ),
    //   home: const GoogleSignInScreen()
    // ),
  }
}
