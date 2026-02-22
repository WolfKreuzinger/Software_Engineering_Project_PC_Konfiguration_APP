import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BuildMyPC')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.computer, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Willkommen bei BuildMyPC',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Konfiguration starten'),
            ),
          ],
        ),
      ),
    );
  }
}
