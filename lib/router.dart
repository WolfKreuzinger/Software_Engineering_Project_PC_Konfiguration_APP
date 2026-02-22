import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/terms_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/terms', builder: (_, __) => const TermsScreen()),
  ],
);
