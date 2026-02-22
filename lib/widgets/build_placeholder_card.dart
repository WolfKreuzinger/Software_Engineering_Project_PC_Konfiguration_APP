import 'package:flutter/material.dart';

class BuildPlaceholderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final double progress;
  final bool compatible;

  const BuildPlaceholderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.progress,
    required this.compatible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 260,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: Text("300x300")),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              compatible ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          compatible
                              ? "COMPATIBLE"
                              : "IN PROGRESS",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(subtitle,
                  style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "PROGRESS ${(progress * 100).round()}%",
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}