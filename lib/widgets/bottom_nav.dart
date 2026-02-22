import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onChanged,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'DASH'),
        NavigationDestination(icon: Icon(Icons.build_outlined), label: 'PICKER'),
        NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: 'SOCIAL'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'CONFIG'),
      ],
    );
  }
}