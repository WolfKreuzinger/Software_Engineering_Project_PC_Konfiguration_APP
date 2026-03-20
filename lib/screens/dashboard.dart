import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import '../widgets/build_list_card.dart';
import '../widgets/guided_configurator_card.dart';
import '../widgets/build_cover_picker.dart';
import '../widgets/section_header.dart';
import '../widgets/share_build_sheet.dart';
import '../widgets/start_new_build_tile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _repo = BuildsRepository();

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
            onPressed: () =>
                Navigator.of(ctx, rootNavigator: true).pop(false),
            child: Text(ctx.l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(ctx, rootNavigator: true).pop(true),
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 92,
          titleSpacing: 16,
          title: Container(
            constraints: const BoxConstraints(minWidth: 260),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.all(1),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(998),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.go('/settings'),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.tertiary,
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.1,
                          ),
                          children: [
                            TextSpan(
                              text: 'BuildMy',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'PC',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PRO BUILDER',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.05,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: const [SizedBox(width: 8)],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.dashboardMyBuilds,
            trailingText: l10n.dashboardViewAll,
            onTrailingTap: () => context.go('/my-builds'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        if (user == null || user.isAnonymous)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.buildsSignInPrompt),
            ),
          )
        else
          SliverToBoxAdapter(
            child: StreamBuilder<List<SavedBuild>>(
              stream: _repo.watchBuilds(user.uid),
              builder: (context, snap) {
                final builds = snap.data ?? const <SavedBuild>[];
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (builds.isEmpty) {
                  return _DashboardEmptyState(
                    onStart: () => context.go('/configure'),
                  );
                }
                final shown = builds.take(4).toList(growable: false);
                return SizedBox(
                  height: 360,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 340,
                    ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final build = shown[index];
                      return BuildListCard(
                        savedBuild: build,
                        compact: true,
                        pinCostToBottom: true,
                        onTap: () =>
                            context.go('/configure', extra: build),
                        onShare: () => _shareBuild(build),
                        onMore: () => _openBuildActions(user, build),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: GuidedConfiguratorCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: StartNewBuildTile()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _DashboardEmptyState extends StatelessWidget {
  const _DashboardEmptyState({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.buildsNoBuilds,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            OutlinedButton(
                onPressed: onStart, child: Text(context.l10n.buildsStartNew)),
          ],
        ),
      ),
    );
  }
}
