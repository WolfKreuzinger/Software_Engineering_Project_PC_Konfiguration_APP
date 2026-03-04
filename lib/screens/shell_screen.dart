import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  bool _isAuthed(User? u) => u != null && !u.isAnonymous;

  bool _firebaseReady() {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  User? _safeUser() {
    if (!_firebaseReady()) return null;
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }

  int _indexForLocation(String location, bool authed) {
    if (!authed) {
      if (location == '/configure') return 1;
      if (location == '/settings') return 2;
      return 0;
    } else {
      if (location == '/parts') return 1;
      if (location == '/settings') return 2;
      return 0;
    }
  }

  void _goForIndex(BuildContext context, int index, bool authed) {
    if (!authed) {
      switch (index) {
        case 0:
          context.go('/');
          return;
        case 1:
          context.go('/configure');
          return;
        case 2:
          context.go('/settings');
          return;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/dashboard');
          return;
        case 1:
          context.go('/parts');
          return;
        case 2:
          context.go('/settings');
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _safeUser();
    final authed = _isAuthed(user);

    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location, authed);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNav(
        mode: authed ? BottomNavMode.authed : BottomNavMode.public,
        currentIndex: currentIndex,
        onChanged: (i) => _goForIndex(context, i, authed),
      ),
    );
  }
}
