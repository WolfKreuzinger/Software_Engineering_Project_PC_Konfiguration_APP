import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/build_templates.dart';
import '../l10n/l10n_ext.dart';
import 'configure_screen.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.92),
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: 64,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  splashRadius: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.templateTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.templateDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.87,
                  children: [
                    for (final template in buildTemplates)
                      _TemplateTile(template: template),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template});

  final BuildTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final primary = theme.colorScheme.primary;
    final tertiary = theme.colorScheme.tertiary;
    final priceLabel = '~\$${template.build.totalPrice.toStringAsFixed(0)}';
    final localizedTagline = switch (template.name) {
      'Budget Gaming' => l10n.templateBudgetGamingTagline,
      'High-End Gaming' => l10n.templateHighEndGamingTagline,
      'Office & Work' => l10n.templateOfficeTagline,
      'Workstation' => l10n.templateWorkstationTagline,
      'Mini-ITX Build' => l10n.templateMiniItxTagline,
      'Silent Build' => l10n.templateSilentTagline,
      _ => template.tagline,
    };

    // Gradient border: outer gradient container (1.5 px padding) → inner Material
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, tertiary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/configure', extra: ConfigureScreenArgs(build: template.build, backRoute: '/templates')),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withValues(alpha: 0.08),
                  tertiary.withValues(alpha: 0.04),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Icon ─────────────────────────────────────────────────
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(template.icon, color: primary, size: 26),
                  ),
                  const SizedBox(height: 12),

                  // ── Name ─────────────────────────────────────────────────
                  Text(
                    template.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // ── Tagline ───────────────────────────────────────────────
                  Expanded(
                    child: Text(
                      localizedTagline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // ── Price chip ────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      priceLabel,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
