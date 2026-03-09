import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import '../services/compatibility_checker.dart';
import 'parts_screen.dart';

class SharedBuildScreen extends StatefulWidget {
  const SharedBuildScreen({super.key, required this.buildId});

  final String buildId;

  @override
  State<SharedBuildScreen> createState() => _SharedBuildScreenState();
}

class _SharedBuildScreenState extends State<SharedBuildScreen> {
  late final Future<Map<String, dynamic>?> _future;
  final _repo = BuildsRepository();
  bool _importing = false;

  // ── Slot metadata (order matters) ─────────────────────────────────────────
  static const List<_SlotMeta> _slotMeta = [
    _SlotMeta('cpu',            Icons.computer_rounded,            'CPU',                'cpu'),
    _SlotMeta('cpuCooler',      Icons.air_rounded,                 'CPU-Kühler',         'cpu-cooler'),
    _SlotMeta('thermalPaste',   Icons.grain_rounded,               'Wärmeleitpaste',     'thermal-paste'),
    _SlotMeta('motherboard',    Icons.developer_board_rounded,     'Mainboard',          'motherboard'),
    _SlotMeta('ram',            Icons.memory_rounded,              'RAM',                'memory'),
    _SlotMeta('gpu',            Icons.videogame_asset_rounded,     'Grafikkarte',        'video-card'),
    _SlotMeta('storage',        Icons.storage_rounded,             'Speicher',           'internal-hard-drive'),
    _SlotMeta('case',           Icons.desktop_windows_rounded,     'Gehäuse',            'case'),
    _SlotMeta('caseFans',       Icons.blur_circular_rounded,       'Gehäuselüfter',      'case-fan'),
    _SlotMeta('fanController',  Icons.tune_rounded,                'Lüftersteuerung',    'fan-controller'),
    _SlotMeta('caseAccessories',Icons.grid_view_rounded,           'Gehäusezubehör',     'case-accessory'),
    _SlotMeta('psu',            Icons.power_rounded,               'Netzteil',           'power-supply'),
    _SlotMeta('wifi',           Icons.network_wifi_rounded,        'WLAN',               'wireless-network-card'),
    _SlotMeta('ethernet',       Icons.settings_ethernet_rounded,   'LAN',                'wired-network-card'),
    _SlotMeta('soundCard',      Icons.volume_up_rounded,           'Soundkarte',         'sound-card'),
    _SlotMeta('opticalDrive',   Icons.disc_full_rounded,           'Optisches Laufwerk', 'optical-drive'),
    _SlotMeta('externalHdd',    Icons.usb_rounded,                 'Externe HDD',        'external-hard-drive'),
    _SlotMeta('ups',            Icons.battery_charging_full_rounded,'USV',               'ups'),
    _SlotMeta('os',             Icons.window_rounded,              'Betriebssystem',     'os'),
  ];

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

  /// Reconstruct PartSelection map from raw Firestore data (same logic as
  /// ConfigureScreen._loadInitialBuild).
  Map<String, PartSelection> _parseParts(Map<String, dynamic> rawParts) {
    final result = <String, PartSelection>{};
    for (final meta in _slotMeta) {
      final raw = rawParts[meta.key];
      if (raw is! Map) continue;
      final name = (raw['name'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      final rawData = <String, dynamic>{'name': name};
      if (raw['specSnippet'] is Map) {
        rawData['spec'] = Map<String, dynamic>.from(raw['specSnippet'] as Map);
      }
      for (final f in ['wattage', 'tdp', 'chipset', 'modules', 'socket',
                        'form_factor', 'speed']) {
        if (raw[f] != null) rawData[f] = raw[f];
      }
      if (raw['case_type'] != null) rawData['type'] = raw['case_type'];
      result[meta.key] = PartSelection(
        partId: (raw['partId'] ?? '').toString(),
        type: (raw['type'] ?? meta.type).toString(),
        title: name,
        subtitle: (raw['subtitle'] ?? '').toString(),
        price: raw['price'] is num ? (raw['price'] as num).toDouble() : null,
        rawData: rawData,
      );
    }
    return result;
  }

  Future<void> _importBuild(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      context.go('/login');
      return;
    }
    final title = await _promptName(
      initial: (data['title'] ?? '').toString().trim(),
    );
    if (title == null || !mounted) return;

    setState(() => _importing = true);
    try {
      final parts = Map<String, dynamic>.from(
        (data['selectedParts'] is Map ? data['selectedParts'] : {}) as Map,
      );
      final totalPrice = (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
      final estWattage = (data['estimatedWattage'] as num?)?.toInt() ?? 0;
      await _repo.saveBuild(
        uid: user.uid,
        selectedParts: parts,
        totalPrice: totalPrice,
        estimatedWattage: estWattage,
        status: BuildStatus.draft, // imported builds always land in "Importiert"
        title: title,
      );
      if (!mounted) return;
      context.go('/my-builds');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Fehler beim Importieren: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<String?> _promptName({required String initial}) async {
    final ctrl = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Build-Name'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Name eingeben',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              final t = ctrl.text.trim();
              Navigator.of(ctx, rootNavigator: true).pop(t.isEmpty ? null : t);
            },
            child: const Text('Importieren'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return result;
  }

  void _viewPart(PartSelection part) {
    PartsScreen.showDetailSheet(
      context,
      <String, dynamic>{...part.rawData, 'name': part.title, 'price': part.price},
      part.type,
      part.title,
    );
  }

  void _showCompatDetails(
    BuildContext context,
    CompatibilityResult result,
    int estimatedWatts,
    int psuWatts,
  ) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _CompatReportScreen(
          result: result,
          estimatedWatts: estimatedWatts,
          psuWatts: psuWatts,
        ),
      ),
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return _ErrorState(onCopy: _copyLink);
          }
          return _buildContent(context, theme, snap.data!);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> data,
  ) {
    final title = (data['title'] ?? 'Build').toString();
    final totalPrice = (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
    final estWattage = _toInt(data['estimatedWattage']);
    final rawParts = (data['selectedParts'] is Map)
        ? Map<String, dynamic>.from(data['selectedParts'] as Map)
        : <String, dynamic>{};

    final parts = _parseParts(rawParts);
    final psuWatts = _toInt(parts['psu']?.rawData['wattage']);
    final compatResult = CompatibilityChecker.check(
      parts: parts,
      estimatedWatts: estWattage,
    );

    final selectedCount = parts.length;
    final totalSlots = _slotMeta.length;
    final progress = totalSlots == 0
        ? 0.0
        : (selectedCount / totalSlots).clamp(0.0, 1.0);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── App bar ───────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor:
                  theme.colorScheme.surface.withValues(alpha: 0.92),
              surfaceTintColor: Colors.transparent,
              leading: BackButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    context.go('/dashboard');
                  }
                },
              ),
              title: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.link_rounded),
                  tooltip: 'Link kopieren',
                  onPressed: _copyLink,
                ),
              ],
              toolbarHeight: 64,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(46),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'FORTSCHRITT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$selectedCount / $totalSlots Teile',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Part cards ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 148),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final meta = _slotMeta[index];
                    final part = parts[meta.key];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == _slotMeta.length - 1 ? 0 : 12,
                      ),
                      child: _ViewPartCard(
                        icon: meta.icon,
                        label: meta.label,
                        part: part,
                        onView: part != null
                            ? () => _viewPart(part)
                            : null,
                      ),
                    );
                  },
                  childCount: _slotMeta.length,
                ),
              ),
            ),
          ],
        ),

        // ── Bottom action bar ─────────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.96),
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (parts.isNotEmpty)
                    _CompatBar(
                      result: compatResult,
                      onViewDetails: () => _showCompatDetails(
                        context,
                        compatResult,
                        estWattage,
                        psuWatts,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _BottomMetric(
                            label: 'GESAMTPREIS',
                            value: '\$${totalPrice.toStringAsFixed(2)}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BottomMetric(
                            label: 'GESCHÄTZTE LEISTUNG',
                            value: '${estWattage}W',
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 132,
                          height: 44,
                          child: FilledButton(
                            onPressed: _importing
                                ? null
                                : () => _importBuild(data),
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                fontSize: 12,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _importing
                                    ? 'SPEICHERN...'
                                    : 'IMPORTIEREN',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Slot metadata ──────────────────────────────────────────────────────────────

class _SlotMeta {
  const _SlotMeta(this.key, this.icon, this.label, this.type);

  final String key;
  final IconData icon;
  final String label;
  final String type;
}

// ── Read-only part card ────────────────────────────────────────────────────────

class _ViewPartCard extends StatelessWidget {
  const _ViewPartCard({
    required this.icon,
    required this.label,
    required this.part,
    required this.onView,
  });

  final IconData icon;
  final String label;
  final PartSelection? part;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = part == null;
    final priceText = part?.price != null
        ? '\$${part!.price!.toStringAsFixed(2)}'
        : '-';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!isEmpty)
                  TextButton(
                    onPressed: onView,
                    child: Text(
                      'ANSEHEN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEmpty ? 'Nicht ausgewählt' : part!.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                      color: isEmpty
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEmpty ? '-' : priceText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isEmpty
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom metric ──────────────────────────────────────────────────────────────

class _BottomMetric extends StatelessWidget {
  const _BottomMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
      ),
    );
  }
}

// ── Compatibility bar ──────────────────────────────────────────────────────────

class _CompatBar extends StatelessWidget {
  const _CompatBar({required this.result, required this.onViewDetails});

  final CompatibilityResult result;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final Color bgColor;
    final Color fgColor;
    final IconData icon;
    final String label;

    switch (result.overallLevel) {
      case CompatIssueLevel.error:
        bgColor = const Color(0xFFEF9A9A);
        fgColor = const Color(0xFFB71C1C);
        icon = Icons.cancel_rounded;
        label = l10n.compatibilityError;
      case CompatIssueLevel.warning:
        bgColor = const Color(0xFFFFE082);
        fgColor = const Color(0xFFE65100);
        icon = Icons.warning_amber_rounded;
        label = l10n.compatibilityWarning;
      case CompatIssueLevel.ok:
        bgColor = const Color(0xFFA5D6A7);
        fgColor = const Color(0xFF1B5E20);
        icon = Icons.check_circle_rounded;
        label = l10n.compatibilityOk;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onViewDetails,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: fgColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: fgColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Text(
                  l10n.compatibilityViewDetails,
                  style: TextStyle(
                    color: fgColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                    decorationColor: fgColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Compatibility report screen ────────────────────────────────────────────────

class _CompatReportScreen extends StatelessWidget {
  const _CompatReportScreen({
    required this.result,
    required this.estimatedWatts,
    required this.psuWatts,
  });

  final CompatibilityResult result;
  final int estimatedWatts;
  final int psuWatts;

  static Color _fg(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error   => const Color(0xFFB71C1C),
    CompatIssueLevel.warning => const Color(0xFFE65100),
    CompatIssueLevel.ok      => const Color(0xFF1B5E20),
  };

  static Color _bg(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error   => const Color(0xFFEF9A9A),
    CompatIssueLevel.warning => const Color(0xFFFFE082),
    CompatIssueLevel.ok      => const Color(0xFFA5D6A7),
  };

  static IconData _icon(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error   => Icons.cancel_rounded,
    CompatIssueLevel.warning => Icons.warning_amber_rounded,
    CompatIssueLevel.ok      => Icons.check_circle_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = result.overallLevel;
    final errors   = result.issues.where((i) => i.level == CompatIssueLevel.error).toList();
    final warnings = result.issues.where((i) => i.level == CompatIssueLevel.warning).toList();
    final oks      = result.issues.where((i) => i.level == CompatIssueLevel.ok).toList();

    final String statusLabel;
    final String statusSub;
    if (errors.isNotEmpty) {
      statusLabel = 'Inkompatibel';
      statusSub   = errors.length == 1 ? '1 kritischer Fehler' : '${errors.length} kritische Fehler';
    } else if (warnings.isNotEmpty) {
      statusLabel = 'Warnung';
      statusSub   = warnings.length == 1 ? '1 Warnung erkannt' : '${warnings.length} Warnungen erkannt';
    } else {
      statusLabel = 'Kompatibel';
      statusSub   = 'Alle Komponenten sind kompatibel';
    }

    final showPower  = estimatedWatts > 0 && psuWatts > 0;
    final loadPct    = showPower ? (estimatedWatts / psuWatts).clamp(0.0, 1.0) : 0.0;
    final headroom   = psuWatts - estimatedWatts;
    final Color powerBarColor = loadPct >= 0.9
        ? const Color(0xFFB71C1C)
        : loadPct >= 0.75
            ? const Color(0xFFE65100)
            : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Kompatibilitätsbericht'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _bg(level),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(_icon(level), color: _fg(level), size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: _fg(level),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        statusSub,
                        style: TextStyle(
                          color: _fg(level),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showPower) ...[
            const SizedBox(height: 20),
            Text(
              'STROMVERSORGUNG',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Geschätzt: ${estimatedWatts}W',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('Netzteil: ${psuWatts}W',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: loadPct,
                      minHeight: 10,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(powerBarColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    headroom >= 0
                        ? '${headroom}W Puffer verfügbar (${(loadPct * 100).round()}% Auslastung)'
                        : '⚠ ${(-headroom)}W über Kapazität',
                    style: TextStyle(
                      color: powerBarColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (errors.isNotEmpty) ...[
            const SizedBox(height: 20),
            _IssueSection(issues: errors, level: CompatIssueLevel.error),
          ],
          if (warnings.isNotEmpty) ...[
            const SizedBox(height: 20),
            _IssueSection(issues: warnings, level: CompatIssueLevel.warning),
          ],
          if (oks.isNotEmpty) ...[
            const SizedBox(height: 20),
            _IssueSection(issues: oks, level: CompatIssueLevel.ok),
          ],
        ],
      ),
    );
  }
}

class _IssueSection extends StatelessWidget {
  const _IssueSection({required this.issues, required this.level});

  final List<CompatIssue> issues;
  final CompatIssueLevel level;

  static Color _fg(CompatIssueLevel l) => switch (l) {
    CompatIssueLevel.error   => const Color(0xFFB71C1C),
    CompatIssueLevel.warning => const Color(0xFFE65100),
    CompatIssueLevel.ok      => const Color(0xFF1B5E20),
  };

  static String _title(CompatIssueLevel l) => switch (l) {
    CompatIssueLevel.error   => 'FEHLER',
    CompatIssueLevel.warning => 'WARNUNGEN',
    CompatIssueLevel.ok      => 'OK',
  };

  static IconData _icon(CompatIssueLevel l) => switch (l) {
    CompatIssueLevel.error   => Icons.cancel_rounded,
    CompatIssueLevel.warning => Icons.warning_amber_rounded,
    CompatIssueLevel.ok      => Icons.check_circle_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _title(level),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...issues.map(
          (issue) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_icon(level), color: _fg(level), size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    issue.message,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
