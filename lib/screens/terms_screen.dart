import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'TODO: Eure Terms of Service.\n\n'
          'Für die Uni reicht erstmal ein Platzhalter. '
          'Später könnt ihr hier euren Text einfügen oder auf eine URL verlinken.',
        ),
      ),
    );
  }
}
