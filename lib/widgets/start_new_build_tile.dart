import 'package:flutter/material.dart';

class StartNewBuildTile extends StatelessWidget {
  const StartNewBuildTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.add,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          title: const Text(
            "Start New Build",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: const Text("Manual / Part Selection"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
      ),
    );
  }
}