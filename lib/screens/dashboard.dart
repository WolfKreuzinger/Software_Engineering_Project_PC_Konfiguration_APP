import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/builds_repository.dart';
import '../widgets/build_list_card.dart';
import '../widgets/guided_configurator_card.dart';
import '../widgets/section_header.dart';
import '../widgets/start_new_build_tile.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final repo = BuildsRepository();

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          backgroundColor: theme.colorScheme.primaryContainer,
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Sign in to see saved builds.'),
            ),
          )
        else
          SliverToBoxAdapter(
            child: StreamBuilder<List<SavedBuild>>(
              stream: repo.watchBuilds(user.uid),
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
                final shown = builds.take(3).toList(growable: false);
                return SizedBox(
                  height: 170,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: shown.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final build = shown[index];
                      return SizedBox(
                        width: 340,
                        child: BuildListCard(
                          savedBuild: build,
                          compact: true,
                          onTap: () => context.go('/configure', extra: build),
                          onResume: () => context.go('/configure', extra: build),
                        ),
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
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'No builds saved yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            OutlinedButton(onPressed: onStart, child: const Text('Start new build')),
          ],
        ),
      ),
    );
  }
}
