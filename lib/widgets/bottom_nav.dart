import 'package:flutter/material.dart';
import '../l10n/l10n_ext.dart';

enum BottomNavMode { public, authed }

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.mode,
    required this.currentIndex,
    required this.onChanged,
  });

  final BottomNavMode mode;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  List<_NavItem> _items(BuildContext context) {
    final l10n = context.l10n;
    if (mode == BottomNavMode.public) {
      return [
        _NavItem(label: l10n.navHome, icon: Icons.home_rounded),
        _NavItem(label: l10n.navConfigure, icon: Icons.build_circle_rounded),
        _NavItem(label: l10n.navSettings, icon: Icons.settings_rounded),
      ];
    }
    return [
      _NavItem(label: l10n.navDashboard, icon: Icons.dashboard_rounded),
      _NavItem(label: l10n.navComponents, icon: Icons.grid_view_rounded),
      _NavItem(label: l10n.navSettings, icon: Icons.settings_rounded),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _items(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (i) {
                final selected = i == currentIndex;
                final item = items[i];

                return Expanded(
                  child: _NavButton(
                    label: item.label,
                    icon: item.icon,
                    selected: selected,
                    onTap: () => onChanged(i),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}