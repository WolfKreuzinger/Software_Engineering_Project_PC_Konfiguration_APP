import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../screens/parts_screen.dart';
import '../services/compatibility_checker.dart';
import 'build_cover_picker.dart';

const _mandatorySlotKeys = <String>{
  'cpu',
  'cpuCooler',
  'motherboard',
  'ram',
  'gpu',
  'storage',
  'case',
  'psu',
};

Map<String, PartSelection> _buildPartSelections(Map<String, dynamic> rawParts) {
  final result = <String, PartSelection>{};
  for (final entry in rawParts.entries) {
    final raw = entry.value;
    if (raw is! Map) continue;
    final name = (raw['name'] ?? '').toString().trim();
    if (name.isEmpty) continue;
    final rawData = <String, dynamic>{};
    if (raw['rawPartData'] is Map) {
      rawData.addAll(Map<String, dynamic>.from(raw['rawPartData'] as Map));
    }
    if (raw['specSnippet'] is Map) {
      rawData['spec'] = Map<String, dynamic>.from(raw['specSnippet'] as Map);
    }
    if (raw['wattage'] != null) rawData['wattage'] = raw['wattage'];
    if (raw['tdp'] != null) rawData['tdp'] = raw['tdp'];
    if (raw['chipset'] != null) rawData['chipset'] = raw['chipset'];
    if (raw['modules'] != null) rawData['modules'] = raw['modules'];
    rawData['name'] = name;
    if (raw['socket'] != null) rawData['socket'] = raw['socket'];
    if (raw['form_factor'] != null) rawData['form_factor'] = raw['form_factor'];
    if (raw['speed'] != null) rawData['speed'] = raw['speed'];
    if (raw['case_type'] != null) rawData['type'] = raw['case_type'];
    result[entry.key] = PartSelection(
      partId: (raw['partId'] ?? '').toString(),
      type: (raw['type'] ?? entry.key).toString(),
      title: name,
      subtitle: (raw['subtitle'] ?? '').toString(),
      price: raw['price'] is num ? (raw['price'] as num).toDouble() : null,
      rawData: rawData,
    );
  }
  return result;
}

class BuildListCard extends StatelessWidget {
  const BuildListCard({
    super.key,
    required this.savedBuild,
    required this.onTap,
    this.compact = false,
    this.pinCostToBottom = false,
    this.onMore,
    this.onShare,
  });

  final SavedBuild savedBuild;
  final VoidCallback onTap;
  final bool compact;
  final bool pinCostToBottom;
  final VoidCallback? onMore;
  final VoidCallback? onShare;

  String _priceLabel(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbWidth = compact ? 150.0 : 165.0;
    final thumbHeight = compact ? 145.0 : 160.0;
    final cardPadding = compact ? 10.0 : 12.0;

    final l10n = context.l10n;
    final statusText = savedBuild.readOnly
        ? l10n.buildStatusImported
        : switch (savedBuild.status) {
            BuildStatus.completed => l10n.buildStatusCompleted,
            BuildStatus.draft => l10n.buildStatusDraft,
            BuildStatus.archived => l10n.buildStatusArchived,
            BuildStatus.inProgress => l10n.buildStatusInProgress,
          };

    final compatResult = CompatibilityChecker.check(
      parts: _buildPartSelections(savedBuild.selectedParts),
      estimatedWatts: savedBuild.estimatedWattage,
      l10n: l10n,
    );
    final compatLevel = compatResult.overallLevel;

    final badgeColor = switch (compatLevel) {
      CompatIssueLevel.error => Colors.red,
      CompatIssueLevel.warning => const Color(0xFFE8A020),
      CompatIssueLevel.ok => Colors.green,
    };

    final mandatoryDone =
        _mandatorySlotKeys.where((k) => savedBuild.selectedParts[k] != null).length;
    const mandatoryTotal = 8;
    final optionalDone = savedBuild.selectedCount - mandatoryDone;
    const optionalTotal = 11; // buildSlotKeys.length (19) - mandatoryTotal (8)
    final mandatoryProgress = (mandatoryDone / mandatoryTotal).clamp(0.0, 1.0);
    final optionalProgress =
        optionalTotal == 0 ? 0.0 : (optionalDone / optionalTotal).clamp(0.0, 1.0);

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
                  BuildCoverThumbnail(
                    coverId: savedBuild.heroImageUrl,
                    width: thumbWidth,
                    height: thumbHeight,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...[
                              Icon(
                                savedBuild.readOnly && (savedBuild.importedFrom?.isNotEmpty ?? false)
                                    ? Icons.lock_rounded
                                    : switch (compatLevel) {
                                        CompatIssueLevel.error =>
                                          Icons.close_rounded,
                                        CompatIssueLevel.warning =>
                                          Icons.warning_amber_rounded,
                                        CompatIssueLevel.ok =>
                                          Icons.check_circle_rounded,
                                      },
                                size: 11,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
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
                      _MiniProgressBar(
                        mandatoryProgress: mandatoryProgress,
                        optionalProgress: optionalProgress,
                        partsDone: savedBuild.selectedCount,
                        partsTotal: buildSlotKeys.length,
                      ),
                      if (pinCostToBottom)
                        const Spacer()
                      else
                        const SizedBox(height: 10),
                      Text(
                        l10n.buildCardEstimatedCost,
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
                      if (pinCostToBottom) const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined),
                    tooltip: l10n.buildCardShare,
                  ),
                  IconButton(
                    onPressed: onMore,
                    icon: const Icon(Icons.more_horiz_rounded),
                    tooltip: l10n.buildCardMore,
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

class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar({
    required this.mandatoryProgress,
    required this.optionalProgress,
    required this.partsDone,
    required this.partsTotal,
  });

  final double mandatoryProgress;
  final double optionalProgress;
  final int partsDone;
  final int partsTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const mandatoryTotal = 8;
    const optionalTotal = 11; // buildSlotKeys.length (19) - mandatoryTotal (8)
    final slashColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              l10n.buildCardProgress,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
            const Spacer(),
            Text(
              '$partsDone/$partsTotal',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final junctionX =
                totalWidth * mandatoryTotal / (mandatoryTotal + optionalTotal);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 5,
                  child: Row(
                    children: [
                      Flexible(
                        flex: mandatoryTotal,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(999),
                          ),
                          child: LinearProgressIndicator(
                            value: mandatoryProgress,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: optionalTotal,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(999),
                          ),
                          child: LinearProgressIndicator(
                            value: optionalProgress,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFE8A020),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: junctionX - 4,
                  top: -4,
                  child: SizedBox(
                    width: 8,
                    height: 13,
                    child: CustomPaint(
                      painter: _SlashDividerPainter(color: slashColor),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SlashDividerPainter extends CustomPainter {
  const _SlashDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.3, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SlashDividerPainter old) => old.color != color;
}
