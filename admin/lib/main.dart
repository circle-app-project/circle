import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'core/theme.dart';
import 'firebase_options.dart';
import 'screens/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: web);
  runApp(const ProviderScope(child: HlaAdminApp()));
}

class HlaAdminApp extends StatelessWidget {
  const HlaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle · HLA Admin',
      debugShowCheckedModeBanner: false,
      theme: buildAdminTheme(),
      home: const AppRoot(),
    );
  }
}
