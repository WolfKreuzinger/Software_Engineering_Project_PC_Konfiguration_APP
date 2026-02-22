import 'package:flutter/material.dart';

class GuidedConfiguratorCard extends StatelessWidget {
  const GuidedConfiguratorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.78),
              ],
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 170),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 18,
                              color: theme.colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "GUIDED CONFIGURATOR",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Smart Mode – Build based on your budget & specific needs.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary.withOpacity(0.92),
                            height: 1.25,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.onPrimary,
                            foregroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Start Smart Build",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.colorScheme.onPrimary.withOpacity(0.14),
                      border: Border.all(
                        color: theme.colorScheme.onPrimary.withOpacity(0.20),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: theme.colorScheme.onPrimary.withOpacity(0.18),
                        ),
                        child: Icon(
                          Icons.dashboard_customize,
                          size: 30,
                          color: theme.colorScheme.onPrimary.withOpacity(0.96),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}