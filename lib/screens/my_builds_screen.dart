import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import '../widgets/build_list_card.dart';

enum _BuildFilter { all, completed, inProgress, draft }

class MyBuildsScreen extends StatefulWidget {
  const MyBuildsScreen({super.key});

  @override
  State<MyBuildsScreen> createState() => _MyBuildsScreenState();
}

class _MyBuildsScreenState extends State<MyBuildsScreen> {
  final _searchCtrl = TextEditingController();
  final _repo = BuildsRepository();
  _BuildFilter _filter = _BuildFilter.all;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openFiltersSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All builds'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.all);
              },
            ),
            ListTile(
              title: const Text('Completed'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.completed);
              },
            ),
            ListTile(
              title: const Text('In Progress'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.inProgress);
              },
            ),
            ListTile(
              title: const Text('Importiert'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.draft);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  bool _matchesFilter(SavedBuild build) {
    switch (_filter) {
      case _BuildFilter.completed:
        return build.status == BuildStatus.completed;
      case _BuildFilter.inProgress:
        return build.status == BuildStatus.inProgress;
      case _BuildFilter.draft:
        return build.status == BuildStatus.draft;
      case _BuildFilter.all:
        return true;
    }
  }

  List<SavedBuild> _applyFilters(List<SavedBuild> builds) {
    final q = _searchCtrl.text.trim().toLowerCase();
    return builds.where((b) {
      final titleHit = q.isEmpty || b.title.toLowerCase().contains(q);
      return titleHit && _matchesFilter(b);
    }).toList(growable: false);
  }

  Future<void> _shareBuild(SavedBuild build) async {
    // Show loading while publishing
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    String url;
    try {
      url = await _repo.publishBuild(build);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Fehler beim Erstellen des Links: $e'),
        ),
      );
      return;
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // dismiss loading

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ShareBuildSheet(buildTitle: build.title, shareUrl: url),
    );
  }

  Future<void> _renameBuild(User user, SavedBuild build) async {
    final ctrl = TextEditingController(text: build.title);
    final next = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Build'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Build name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = ctrl.text.trim();
              Navigator.of(
                ctx,
                rootNavigator: true,
              ).pop(trimmed.isEmpty ? null : trimmed);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (next == null || next == build.title) return;

    await _repo.renameBuild(uid: user.uid, buildId: build.buildId, title: next);
  }

  Future<void> _deleteBuild(User user, SavedBuild build) async {
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Build'),
        content: Text('Delete "${build.title}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteBuild(uid: user.uid, buildId: build.buildId);
  }

  Future<void> _openBuildActions(User user, SavedBuild build) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Rename'),
              onTap: () => Navigator.of(ctx).pop('rename'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Delete'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () => Navigator.of(ctx).pop('delete'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    if (action == 'rename') {
      await _renameBuild(user, build);
      return;
    }
    if (action == 'delete') {
      await _deleteBuild(user, build);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      return const Center(child: Text('Sign in to view your builds.'));
    }

    return StreamBuilder<List<SavedBuild>>(
      stream: _repo.watchBuilds(user.uid),
      builder: (context, snap) {
        final builds = _applyFilters(snap.data ?? const []);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  splashRadius: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Text(
                  'My Builds',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search your builds…',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _openFiltersSheet,
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Filters'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All builds'),
                    selected: _filter == _BuildFilter.all,
                    onSelected: (_) => setState(() => _filter = _BuildFilter.all),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Completed'),
                    selected: _filter == _BuildFilter.completed,
                    onSelected: (_) =>
                        setState(() => _filter = _BuildFilter.completed),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('In Progress'),
                    selected: _filter == _BuildFilter.inProgress,
                    onSelected: (_) =>
                        setState(() => _filter = _BuildFilter.inProgress),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Importiert'),
                    selected: _filter == _BuildFilter.draft,
                    onSelected: (_) => setState(() => _filter = _BuildFilter.draft),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!snap.hasData)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (snap.hasData && builds.isEmpty)
              _EmptyBuildState(onStart: () => context.go('/configure')),
            if (builds.isNotEmpty)
              ...builds.asMap().entries.map((e) {
                final i = e.key;
                final build = e.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: i == builds.length - 1 ? 0 : 12),
                  child: BuildListCard(
                    savedBuild: build,
                    isCurrent: i == 0 && build.isResumable,
                    onTap: () => context.go('/configure', extra: build),
                    onResume: () => context.go('/configure', extra: build),
                    onMore: () => _openBuildActions(user, build),
                    onShare: () => _shareBuild(build),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}

// ── Share sheet ───────────────────────────────────────────────────────────────

class _ShareBuildSheet extends StatelessWidget {
  const _ShareBuildSheet({required this.buildTitle, required this.shareUrl});

  final String buildTitle;
  final String shareUrl;

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Konnte nicht geöffnet werden.'),
          ),
        );
      }
    }
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Link kopiert!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final encodedText = Uri.encodeComponent(
      'Schau dir meinen PC-Build "$buildTitle" an: $shareUrl',
    );
    final encodedSubject = Uri.encodeComponent('BuildMyPC – $buildTitle');

    // (label, iconWidget, bgWidget, url, copyFirst)
    // bgWidget fills the 52×52 ClipRRect — use ColoredBox for solid, Stack for Instagram
    // Instagram DM has no URL intent → copy link then open inbox
    final channels = <(String, Widget, Widget, String, bool)>[
      (
        'WhatsApp',
        const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 26),
        const ColoredBox(color: Color(0xFF25D366)),
        'https://wa.me/?text=$encodedText',
        false,
      ),
      (
        'Instagram',
        const FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 26),
        // Two-layer gradient: warm radial from bottom-left + purple overlay top-left
        const Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.6, 1.0),
                  radius: 2.2,
                  colors: [
                    Color(0xFFFFDC80), // yellow
                    Color(0xFFF77737), // orange
                    Color(0xFFF56040), // orange-red
                    Color(0xFFE1306C), // hot pink
                    Color(0xFFCE2085), // magenta (top-right area)
                  ],
                  stops: [0.0, 0.20, 0.35, 0.55, 1.0],
                ),
              ),
              child: SizedBox.expand(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 0.6),
                  colors: [
                    Color(0xCC7B1FA2), // ~80% purple
                    Color(0x007B1FA2), // transparent
                  ],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ],
        ),
        'instagram://direct-inbox',
        true,
      ),
      (
        'X',
        const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white, size: 24),
        const ColoredBox(color: Colors.black),
        'https://twitter.com/intent/tweet?text=$encodedText',
        false,
      ),
      (
        'E-Mail',
        const Icon(Icons.email_rounded, color: Colors.white, size: 26),
        const ColoredBox(color: Color(0xFF78909C)),
        'mailto:?subject=$encodedSubject&body=$encodedText',
        false,
      ),
      (
        'SMS',
        const Icon(Icons.sms_rounded, color: Colors.white, size: 26),
        const ColoredBox(color: Color(0xFF34AADC)),
        'sms:?&body=$encodedText',
        false,
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Build teilen',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            // Link row
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
                      shareUrl,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _copy(context),
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
            const SizedBox(height: 24),
            Text(
              'DIREKT TEILEN',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: channels.map((c) {
                final (label, iconWidget, bgWidget, url, copyFirst) = c;
                return InkWell(
                  onTap: () async {
                    if (copyFirst) {
                      await Clipboard.setData(ClipboardData(text: shareUrl));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Link kopiert – füge ihn in Instagram DM ein.'),
                        ),
                      );
                    }
                    if (context.mounted) _launch(context, url);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                bgWidget,
                                Center(child: iconWidget),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _EmptyBuildState extends StatelessWidget {
  const _EmptyBuildState({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No builds saved yet',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onStart,
            child: const Text('Start new build'),
          ),
        ],
      ),
    );
  }
}
