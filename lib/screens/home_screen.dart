import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n_ext.dart';
import '../theme/theme_global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuildMyPC'),
        actions: [
          IconButton(
            icon: Icon(
              themeController.mode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => themeController.toggleLightDark(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.computer, size: 80),
            const SizedBox(height: 16),
            Text(
              l10n.homeWelcome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/configure'),
              child: Text(l10n.homeConfigureButton),
            ),
          ],
        ),
      ),
    );
  }
}
