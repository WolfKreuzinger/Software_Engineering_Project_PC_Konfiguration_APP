import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BuildMyPCApp());
}

class BuildMyPCApp extends StatelessWidget {
  const BuildMyPCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuildMyPC',
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: const ColorScheme(
          brightness: Brightness.light,

          primary: Color(0xFF6C2BD9),
          onPrimary: Colors.white,

          secondary: Color(0xFF7B3FE4),
          onSecondary: Colors.white,

          error: Colors.red,
          onError: Colors.white,

          surface: Colors.white,
          onSurface: Colors.black,

          primaryContainer: Color(0xFFEDE7FF),
          onPrimaryContainer: Color(0xFF3D0E99),
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F7FB),

        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),

      home: const Dashboard(),
    );
  }
}