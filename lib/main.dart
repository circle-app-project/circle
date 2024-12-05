import 'package:circle/core/routes.dart';
import 'package:circle/databse_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/core.dart';
import 'firebase_options.dart';

late LocalDatabaseService database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize database with Admin
  await LocalDatabaseService.instance.initialize(startAdmin: kDebugMode, adminPort: 8091);
  database = LocalDatabaseService.instance;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GoRouter? router;
  @override
  void initState() {
    router = ref.read(routerProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          isDarkMode
              ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              )
              : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              ),
      child: MaterialApp.router(
        title: 'Circle',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: ThemeMode.system,
        themeAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        ),
        routerConfig: router,
         //home: const OnboardingBaseScreen(),
      ),
    );
  }
}
