import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfigureScreen extends StatelessWidget {
  const ConfigureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const partsDone = 5;
    const partsTotal = 8;
    final progress = partsDone / partsTotal;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
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
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Custom PC Builder',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _Pill(
                      icon: Icons.bolt_rounded,
                      text: '420W Est.',
                      color: theme.colorScheme.primary,
                      background:
                          theme.colorScheme.primary.withOpacity(0.10),
                      border:
                          theme.colorScheme.primary.withOpacity(0.20),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(46),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Build Progress',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$partsDone / $partsTotal Parts',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _SelectedPartCard(
                      categoryIcon: Icons.computer_rounded,
                      categoryLabel: 'Processor',
                      title: 'Intel Core i9-13900K 3 GHz 24-Core',
                      price: '\$569.99',
                      onChange: () {},
                    ),
                    const SizedBox(height: 12),
                    _SelectedPartCard(
                      categoryIcon: Icons.developer_board_rounded,
                      categoryLabel: 'Motherboard',
                      title: 'Asus ROG MAXIMUS Z790 HERO ATX',
                      price: '\$629.99',
                      onChange: () {},
                    ),
                    const SizedBox(height: 12),
                    _SelectedPartCard(
                      categoryIcon: Icons.videogame_asset_rounded,
                      categoryLabel: 'Graphics Card',
                      title: 'NVIDIA RTX 4080 16GB',
                      price: '\$1,199.00',
                      onChange: () {},
                    ),
                    const SizedBox(height: 12),
                    _SelectedPartCard(
                      categoryIcon: Icons.storage_rounded,
                      categoryLabel: 'Storage',
                      title: 'Samsung 980 Pro 2 TB NVME',
                      price: '\$159.99',
                      onChange: () {},
                    ),
                    const SizedBox(height: 12),
                    _SelectedPartCard(
                      categoryIcon: Icons.desktop_windows_rounded,
                      categoryLabel: 'Case',
                      title: 'Choose a Case',
                      price: '—',
                      onChange: () {},
                      isEmpty: true,
                    ),
                    const SizedBox(height: 12),
                    _SelectedPartCard(
                      categoryIcon: Icons.power_rounded,
                      categoryLabel: 'Power Supply',
                      title: 'Corsair RM850x 850 W',
                      price: '\$149.99',
                      onChange: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.96),
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$2,708.96',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 190,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.6,
                            ),
                          ),
                          child: const Text('ADD TO BUILDS'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
    required this.border,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPartCard extends StatelessWidget {
  const _SelectedPartCard({
    required this.categoryIcon,
    required this.categoryLabel,
    required this.title,
    required this.price,
    required this.onChange,
    this.isEmpty = false,
  });

  final IconData categoryIcon;
  final String categoryLabel;
  final String title;
  final String price;
  final VoidCallback onChange;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(categoryIcon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    categoryLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onChange,
                  child: Text(
                    isEmpty ? 'Choose' : 'Change',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isEmpty
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}