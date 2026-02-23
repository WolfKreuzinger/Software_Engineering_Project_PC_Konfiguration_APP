import 'package:go_router/go_router.dart';
import 'package:software_engineering_project_pc_konfiguration_app/screens/dashboard.dart';
import 'package:software_engineering_project_pc_konfiguration_app/screens/home_screen.dart';

import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/dashboard.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/terms', builder: (_, __) => const TermsScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const Dashboard()),
  ],
);
