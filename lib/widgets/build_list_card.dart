import 'package:flutter/material.dart';

import '../models/saved_build.dart';

class BuildListCard extends StatelessWidget {
  const BuildListCard({
    super.key,
    required this.savedBuild,
    required this.onTap,
    this.isCurrent = false,
    this.compact = false,
    this.pinCostToBottom = false,
    this.onMore,
    this.onShare,
  });

  final SavedBuild savedBuild;
  final VoidCallback onTap;
  final bool isCurrent;
  final bool compact;
  final bool pinCostToBottom;
  final VoidCallback? onMore;
  final VoidCallback? onShare;

  String _priceLabel(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbWidth = compact ? 120.0 : 132.0;
    final thumbHeight = compact ? 110.0 : 126.0;
    final cardPadding = compact ? 10.0 : 12.0;

    final statusText = isCurrent ? 'CURRENT BUILD' : savedBuild.statusLabel;
    final statusColor = savedBuild.readOnly
        ? Colors.blueGrey
        : switch (savedBuild.status) {
            BuildStatus.completed => Colors.green,
            BuildStatus.archived => Colors.blueGrey,
            BuildStatus.draft => Colors.blueGrey,
            BuildStatus.inProgress => Colors.orange,
          };

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: thumbWidth,
                    height: thumbHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.24),
                          theme.colorScheme.tertiary.withValues(alpha: 0.20),
                          theme.colorScheme.surfaceContainerHighest,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: pinCostToBottom ? thumbHeight : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: pinCostToBottom
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    children: [
                      Text(
                        savedBuild.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        savedBuild.summaryLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (pinCostToBottom)
                        const Spacer()
                      else
                        const SizedBox(height: 10),
                      Text(
                        'ESTIMATED COST',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _priceLabel(savedBuild.totalPrice),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (pinCostToBottom) const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined),
                    tooltip: 'Share',
                  ),
                  IconButton(
                    onPressed: onMore,
                    icon: const Icon(Icons.more_horiz_rounded),
                    tooltip: 'More',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
