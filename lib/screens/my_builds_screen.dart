import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              title: const Text('Draft'),
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
            Text(
              'My Builds',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
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
                    label: const Text('Draft'),
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
