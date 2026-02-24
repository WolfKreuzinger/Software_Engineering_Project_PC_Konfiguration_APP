import 'package:flutter/material.dart';

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

  List<_NavItem> _items(BottomNavMode mode) {
    if (mode == BottomNavMode.public) {
      return const [
        _NavItem(label: 'Home', icon: Icons.home_rounded),
        _NavItem(label: 'Konfigurieren', icon: Icons.build_circle_rounded),
        _NavItem(label: 'Einstellungen', icon: Icons.settings_rounded),
      ];
    }
    return const [
      _NavItem(label: 'Dashboard', icon: Icons.dashboard_rounded),
      _NavItem(label: 'Komponenten', icon: Icons.grid_view_rounded),
      _NavItem(label: 'Einstellungen', icon: Icons.settings_rounded),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _items(mode);

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bottomPadding = (bottomInset - 20).clamp(0.0, double.infinity);

    final barColor = Color.alphaBlend(
      theme.colorScheme.primary.withOpacity(0.035),
      theme.colorScheme.surface.withOpacity(0.98),
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.85),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 26,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
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

    final selectedBg = Color.alphaBlend(
      theme.colorScheme.primary.withOpacity(0.16),
      theme.colorScheme.surface,
    );

    final selectedBorder = theme.colorScheme.primary.withOpacity(0.18);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: selected ? Border.all(color: selectedBorder, width: 1) : null,
          ),
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
              const SizedBox(height: 7),
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