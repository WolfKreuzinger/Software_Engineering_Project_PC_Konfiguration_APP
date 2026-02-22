import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/top_profile_app_bar.dart';

import 'home_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _tab = 0;

  final _screens = const [
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopProfileAppBar(
        title: 'BuildMyPC',
        subtitle: 'PRO BUILDER',
      ),
      body: _screens[_tab],
      bottomNavigationBar: BottomNav(
        currentIndex: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}