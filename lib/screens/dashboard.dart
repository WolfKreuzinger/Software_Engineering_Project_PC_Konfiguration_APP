import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../widgets/build_placeholder_card.dart';
import '../widgets/guided_configurator_card.dart';
import '../widgets/start_new_build_tile.dart';
import '../widgets/section_header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
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
                    Text(
                      'BuildMyPC',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.1,
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
          actions: const [SizedBox(width: 8)],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        /// My Builds Header
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.dashboardMyBuilds,
            trailingText: l10n.dashboardViewAll,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        /// Horizontal Builds
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return BuildPlaceholderCard(
                  title: index == 0 ? "Gaming Beast" : "Work Rig",
                  subtitle: index == 0
                      ? "RTX 4090 • i9-14900K"
                      : "RTX 4070 • R9 7900X",
                  price: index == 0 ? 3420 : 1850,
                  progress: index == 0 ? 1.0 : 0.85,
                  compatible: index == 0,
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        /// Guided Configurator
        const SliverToBoxAdapter(
          child: GuidedConfiguratorCard(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        /// Start New Build
        const SliverToBoxAdapter(
          child: StartNewBuildTile(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
