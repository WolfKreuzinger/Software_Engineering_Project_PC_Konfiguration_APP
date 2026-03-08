import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';

class SharedBuildScreen extends StatefulWidget {
  const SharedBuildScreen({super.key, required this.buildId});

  final String buildId;

  @override
  State<SharedBuildScreen> createState() => _SharedBuildScreenState();
}

class _SharedBuildScreenState extends State<SharedBuildScreen> {
  late final Future<Map<String, dynamic>?> _future;
  final _repo = BuildsRepository();

  @override
  void initState() {
    super.initState();
    _future = _repo.getPublicBuild(widget.buildId);
  }

  String get _shareUrl =>
      '${BuildsRepository.shareBaseUrl}/build/${widget.buildId}';

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _shareUrl));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Link kopiert!'),
      ),
    );
  }

  // Ordered slot labels for display
  static const _slotLabels = <String, String>{
    'cpu': 'CPU',
    'cpuCooler': 'CPU-Kühler',
    'thermalPaste': 'Wärmeleitpaste',
    'motherboard': 'Mainboard',
    'ram': 'RAM',
    'gpu': 'Grafikkarte',
    'storage': 'Speicher',
    'case': 'Gehäuse',
    'caseFans': 'Gehäuselüfter',
    'fanController': 'Lüftersteuerung',
    'psu': 'Netzteil',
    'wifi': 'WLAN',
    'ethernet': 'LAN',
    'soundCard': 'Soundkarte',
    'os': 'Betriebssystem',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geteilter Build'),
        actions: [
          IconButton(
            icon: const Icon(Icons.link_rounded),
            tooltip: 'Link kopieren',
            onPressed: _copyLink,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.link_off_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Build nicht gefunden',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dieser Link ist ungültig oder wurde noch nicht geteilt.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final data = snap.data!;
          final title = data['title']?.toString() ?? 'Build';
          final totalPrice =
              (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
          final status = buildStatusFromString(
            (data['status'] ?? '').toString(),
          );
          final rawParts =
              (data['selectedParts'] as Map?)?.cast<String, dynamic>() ?? {};

          // Collect parts in slot order
          final parts = <({String label, String name, double? price})>[];
          for (final entry in _slotLabels.entries) {
            final part = rawParts[entry.key];
            if (part is Map) {
              final name = part['name']?.toString().trim() ?? '';
              if (name.isNotEmpty) {
                parts.add((
                  label: entry.value,
                  name: name,
                  price: (part['price'] as num?)?.toDouble(),
                ));
              }
            }
          }

          final statusColor = switch (status) {
            BuildStatus.completed => Colors.green,
            BuildStatus.inProgress => Colors.orange,
            _ => Colors.blueGrey,
          };

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Text(
                        status == BuildStatus.completed
                            ? 'ABGESCHLOSSEN'
                            : 'IN BEARBEITUNG',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '\$${totalPrice.toStringAsFixed(2)} Gesamtpreis',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Share link row
              Container(
                padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _shareUrl,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _copyLink,
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Kopieren'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Parts list
              Text(
                'KOMPONENTEN (${parts.length})',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              ...parts.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.label.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (p.price != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            '\$${p.price!.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
