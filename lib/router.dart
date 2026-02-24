import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth_screen.dart';
import 'screens/configure_screen.dart';
import 'screens/dashboard.dart';
import 'screens/home_screen.dart';
import 'screens/parts_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/support_screen.dart';
import 'screens/terms_screen.dart';

class AuthListenable extends ChangeNotifier {
  StreamSubscription<User?>? _sub;

  AuthListenable() {
    _bindIfPossible();
  }

  void _bindIfPossible() {
    if (_sub != null) return;
    try {
      if (Firebase.apps.isEmpty) return;
      _sub = FirebaseAuth.instance.authStateChanges().listen((_) {
        notifyListeners();
      });
    } catch (_) {}
  }

  void ensureBound() => _bindIfPossible();

  @override
  void dispose() {
    _sub?.cancel();
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
    _authListenable.ensureBound();

    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      user = null;
    }

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
      pageBuilder: (_, _) => _noAnim(const AuthScreen()),
    ),
    GoRoute(
      path: '/terms',
      pageBuilder: (_, _) => _noAnim(const TermsScreen()),
    ),
    GoRoute(
      path: '/privacy',
      pageBuilder: (_, _) => _noAnim(const PrivacyPolicyScreen()),
    ),
    GoRoute(
      path: '/support',
      pageBuilder: (_, _) => _noAnim(const SupportScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, _) => _noAnim(const HomeScreen()),
        ),
        GoRoute(
          path: '/configure',
          pageBuilder: (_, _) => _noAnim(const ConfigureScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, _) => _noAnim(const SettingsScreen()),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (_, _) => _noAnim(const Dashboard()),
        ),
        GoRoute(
          path: '/parts',
          pageBuilder: (_, _) => _noAnim(const PartsScreen()),
        ),
      ],
    ),
  ],
);