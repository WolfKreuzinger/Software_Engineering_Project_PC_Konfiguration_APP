import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import '../widgets/build_cover_picker.dart';
import '../widgets/build_list_card.dart';
import '../widgets/share_build_sheet.dart';
import 'configure_screen.dart';

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
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.myBuildsFilterAll),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.all);
              },
            ),
            ListTile(
              title: Text(l10n.myBuildsFilterCompleted),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.completed);
              },
            ),
            ListTile(
              title: Text(l10n.myBuildsFilterInProgress),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _filter = _BuildFilter.inProgress);
              },
            ),
            ListTile(
              title: Text(l10n.myBuildsFilterImported),
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
        return build.readOnly || build.importedFrom != null;
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
    final user = FirebaseAuth.instance.currentUser;
    final senderName = user?.displayName ?? '';

    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ShareBuildSheet(
        build: build,
        senderName: senderName,
        repo: _repo,
      ),
    );
  }

  Future<void> _renameBuild(User user, SavedBuild build) async {
    final ctrl = TextEditingController(text: build.title);
    String? selectedCover = build.heroImageUrl;
    final result =
        await showDialog<({String title, String? heroImageUrl})>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(ctx.l10n.buildDialogEditTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: ctx.l10n.buildDialogNameHint,
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              Text(
                ctx.l10n.buildDialogCoverLabel,
                style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 8),
              BuildCoverPicker(
                selectedCoverId: selectedCover,
                onChanged: (id) =>
                    setDialogState(() => selectedCover = id),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(ctx, rootNavigator: true).pop(),
              child: Text(ctx.l10n.settingsCancel),
            ),
            FilledButton(
              onPressed: () {
                final trimmed = ctrl.text.trim();
                if (trimmed.isEmpty) return;
                Navigator.of(ctx, rootNavigator: true).pop(
                  (title: trimmed, heroImageUrl: selectedCover),
                );
              },
              child: Text(ctx.l10n.settingsSave),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (result == null) return;
    await _repo.renameBuild(
      uid: user.uid,
      buildId: build.buildId,
      title: result.title,
      heroImageUrl: result.heroImageUrl,
    );
  }

  Future<void> _duplicateBuild(User user, SavedBuild build) async {
    final ctrl = TextEditingController(text: context.l10n.buildDialogCopyOf(build.title));
    String? selectedCover = build.heroImageUrl;
    String? nameError;
    final result = await showDialog<({String title, String? heroImageUrl})>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
            title: Text(ctx.l10n.buildDialogDuplicateTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: ctx.l10n.buildDialogDuplicateNameHint,
                    border: const OutlineInputBorder(),
                    errorText: nameError,
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                Text(
                  ctx.l10n.buildDialogCoverLabel,
                  style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 8),
                BuildCoverPicker(
                  selectedCoverId: selectedCover,
                  onChanged: (id) =>
                      setDialogState(() => selectedCover = id),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
                child: Text(ctx.l10n.settingsCancel),
              ),
              FilledButton(
                onPressed: () {
                  final t = ctrl.text.trim();
                  if (t.isEmpty) {
                    setDialogState(() => nameError = ctx.l10n.buildDialogNameRequired);
                    return;
                  }
                  Navigator.of(ctx, rootNavigator: true)
                      .pop((title: t, heroImageUrl: selectedCover));
                },
                child: Text(ctx.l10n.commonDuplicate),
              ),
            ],
          ),
      ),
    );
    ctrl.dispose();
    if (result == null || !mounted) return;

    try {
      await _repo.saveBuild(
        uid: user.uid,
        selectedParts: build.selectedParts,
        totalPrice: build.totalPrice,
        estimatedWattage: build.estimatedWattage,
        status: build.status,
        title: result.title,
        heroImageUrl: result.heroImageUrl,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.buildDialogSaved(result.title)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.buildDialogDuplicateError(e.toString())),
        ),
      );
    }
  }

  Future<void> _deleteBuild(User user, SavedBuild build) async {
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.buildDialogDeleteTitle),
        content: Text(ctx.l10n.buildDialogDeleteContent(build.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: Text(ctx.l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            child: Text(ctx.l10n.commonDelete),
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
            if (!build.readOnly)
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: Text(ctx.l10n.commonRename),
                onTap: () => Navigator.of(ctx).pop('rename'),
              ),
            if (!build.readOnly)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: Text(ctx.l10n.commonDuplicate),
                onTap: () => Navigator.of(ctx).pop('duplicate'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(ctx.l10n.commonDelete),
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
    if (action == 'duplicate') {
      await _duplicateBuild(user, build);
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
      return Center(child: Text(context.l10n.buildsSignInPrompt));
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
                  context.l10n.myBuildsTitle,
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
                hintText: context.l10n.myBuildsSearchHint,
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
                  label: Text(context.l10n.myBuildsFilters),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(context.l10n.myBuildsFilterAll),
                    selected: _filter == _BuildFilter.all,
                    onSelected: (_) => setState(() => _filter = _BuildFilter.all),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(context.l10n.myBuildsFilterCompleted),
                    selected: _filter == _BuildFilter.completed,
                    onSelected: (_) =>
                        setState(() => _filter = _BuildFilter.completed),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(context.l10n.myBuildsFilterInProgress),
                    selected: _filter == _BuildFilter.inProgress,
                    onSelected: (_) =>
                        setState(() => _filter = _BuildFilter.inProgress),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(context.l10n.myBuildsFilterImported),
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
                    pinCostToBottom: true,
                    onTap: () => context.go('/configure', extra: ConfigureScreenArgs(build: build, readOnly: build.readOnly, backRoute: '/my-builds')),
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
            context.l10n.buildsNoBuilds,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onStart,
            child: Text(context.l10n.buildsStartNew),
          ),
        ],
      ),
    );
  }
}
