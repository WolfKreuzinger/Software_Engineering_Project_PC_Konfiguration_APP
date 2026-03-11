import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import 'configure_screen.dart';

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
    _future.then((data) {
      if (data == null || !mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _navigateToConfigureScreen(data);
      });
    });
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

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  void _navigateToConfigureScreen(Map<String, dynamic> data) {
    final rawParts = (data['selectedParts'] is Map)
        ? Map<String, dynamic>.from(data['selectedParts'] as Map)
        : <String, dynamic>{};
    final build = SavedBuild(
      buildId: widget.buildId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      title: (data['title'] ?? '').toString(),
      status: BuildStatus.draft,
      selectedParts: rawParts,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      estimatedWattage: _toInt(data['estimatedWattage']),
    );
    context.go(
      '/configure',
      extra: ConfigureScreenArgs(build: build, readOnly: true),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Data loaded — navigating to configure screen
          return const Center(child: CircularProgressIndicator());
        },
      ),
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
