import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth_screen.dart';
import 'screens/configure_screen.dart';
import 'screens/dashboard.dart';
import 'screens/home_screen.dart';
import 'screens/parts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/terms_screen.dart';

class AuthListenable extends ChangeNotifier {
  AuthListenable() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final _authListenable = AuthListenable();

bool _isAuthed(User? u) => u != null && !u.isAnonymous;

NoTransitionPage<T> _noAnim<T>(Widget child) => NoTransitionPage<T>(child: child);

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: _authListenable,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final authed = _isAuthed(user);

    final loc = state.matchedLocation;

    final isPrivate = loc == '/dashboard' || loc == '/parts';
    final isAuthPage = loc == '/login';

    if (!authed && isPrivate) return '/';
    if (authed && isAuthPage) return '/dashboard';

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (_, __) => _noAnim(const AuthScreen()),
    ),
    GoRoute(
      path: '/terms',
      pageBuilder: (_, __) => _noAnim(const TermsScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, __) => _noAnim(const HomeScreen()),
        ),
        GoRoute(
          path: '/configure',
          pageBuilder: (_, __) => _noAnim(const ConfigureScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, __) => _noAnim(const SettingsScreen()),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (_, __) => _noAnim(const Dashboard()),
        ),
        GoRoute(
          path: '/parts',
          pageBuilder: (_, __) => _noAnim(const PartsScreen()),
        ),
      ],
    ),
  ],
);