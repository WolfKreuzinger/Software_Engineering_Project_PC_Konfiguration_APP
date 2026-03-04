import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import 'parts_screen.dart';

class ConfigureScreen extends StatefulWidget {
  const ConfigureScreen({super.key});

  @override
  State<ConfigureScreen> createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  final Map<String, PartSelection> _selectedParts = <String, PartSelection>{};

  int _gpuFallbackWattsFromChipset(String chipset) {
    final s = chipset.toLowerCase();

    final ultra450 = ['4090', '3090', '3090 ti', '7900 xtx', '7900xtx'];
    for (final k in ultra450) {
      if (s.contains(k)) return 450;
    }

    final high300 = [
      '4080',
      '3080',
      '3080 ti',
      '3070 ti',
      '4070 ti',
      '4070ti',
      '7900 xt',
      '7900xt',
    ];
    for (final k in high300) {
      if (s.contains(k)) return 300;
    }

    final mid200 = [
      '4070',
      '4060',
      '3060',
      '3050',
      '6600',
      '6650',
      '6700',
      '6750',
      '7600',
      '7700',
    ];
    for (final k in mid200) {
      if (s.contains(k)) return 200;
    }

    return 300;
  }

  int _estimateWattsUpperBound({
    required int cpuTdp,
    required String? gpuChipset,
    required int ramModules,
    required int ssdCount,
    required bool hasMotherboard,
    required int caseFans,
    required bool hasCpuCooler,
  }) {
    final cpu = cpuTdp;
    final gpu = gpuChipset == null
        ? 0
        : _gpuFallbackWattsFromChipset(gpuChipset);
    final ram = ramModules * 5;
    final ssd = ssdCount * 7;
    final mb = hasMotherboard ? 60 : 0;
    final fans = caseFans * 4;
    final cpuCoolerFan = hasCpuCooler ? 4 : 0;

    return cpu + gpu + ram + ssd + mb + fans + cpuCoolerFan;
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  _BuildSelection _buildSelection() {
    final cpu = _selectedParts['cpu'];
    final gpu = _selectedParts['gpu'];
    final ram = _selectedParts['ram'];

    final cpuRaw = cpu?.rawData;
    final gpuRaw = gpu?.rawData;
    final ramRaw = ram?.rawData;

    final cpuSpec = cpuRaw?['spec'];
    final gpuSpec = gpuRaw?['spec'];
    final ramSpec = ramRaw?['spec'];

    final cpuTdp = _toInt(
      (cpuSpec is Map ? cpuSpec['tdp'] : null) ?? cpuRaw?['tdp'],
    );
    final gpuChipset =
        ((gpuSpec is Map ? gpuSpec['chipset'] : null) ??
                gpuRaw?['chipset'] ??
                '')
            .toString()
            .trim();

    final modulesRaw =
        (ramSpec is Map ? ramSpec['modules'] : null) ?? ramRaw?['modules'];
    int ramModules = 0;
    if (modulesRaw is List && modulesRaw.isNotEmpty) {
      ramModules = _toInt(modulesRaw.first);
    } else if (modulesRaw is num || modulesRaw is String) {
      ramModules = _toInt(modulesRaw);
    }

    return _BuildSelection(
      cpuTdp: cpuTdp,
      gpuChipset: gpuChipset.isEmpty ? null : gpuChipset,
      ramModules: ramModules,
      ssdCount: _selectedParts.containsKey('storage') ? 1 : 0,
      hasMotherboard: _selectedParts.containsKey('motherboard'),
      caseFans: _selectedParts.containsKey('caseFans') ? 1 : 0,
      hasCpuCooler: _selectedParts.containsKey('cpuCooler'),
    );
  }

  Future<void> _choosePart(_PartSlot slot) async {
    final picked = await Navigator.of(context).push<PartSelection>(
      MaterialPageRoute(
        builder: (_) =>
            PartsScreen(lockedType: slot.type, returnSelection: true),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedParts[slot.key] = picked);
  }

  String _priceLabel(double? price) {
    if (price == null) return '-';
    return '\$${price.toStringAsFixed(2)}';
  }

  List<_PartSlot> _slots(BuildContext context) {
    final l10n = context.l10n;
    return <_PartSlot>[
      _PartSlot(
        key: 'cpu',
        type: 'cpu',
        icon: Icons.computer_rounded,
        label: l10n.configureCatCpu,
        emptyTitle: l10n.configureChooseCpu,
      ),
      _PartSlot(
        key: 'cpuCooler',
        type: 'cpu-cooler',
        icon: Icons.air_rounded,
        label: l10n.configureCatCpuCooler,
        emptyTitle: l10n.configureChooseCpuCooler,
      ),
      _PartSlot(
        key: 'thermalPaste',
        type: 'thermal-paste',
        icon: Icons.grain_rounded,
        label: l10n.configureCatThermalPaste,
        emptyTitle: l10n.configureChooseThermalPaste,
      ),
      _PartSlot(
        key: 'motherboard',
        type: 'motherboard',
        icon: Icons.developer_board_rounded,
        label: l10n.configureCatMotherboard,
        emptyTitle: l10n.configureChooseMotherboard,
      ),
      _PartSlot(
        key: 'ram',
        type: 'memory',
        icon: Icons.memory_rounded,
        label: l10n.configureCatRam,
        emptyTitle: l10n.configureChooseRam,
      ),
      _PartSlot(
        key: 'gpu',
        type: 'video-card',
        icon: Icons.videogame_asset_rounded,
        label: l10n.configureCatGpu,
        emptyTitle: l10n.configureChooseGpu,
      ),
      _PartSlot(
        key: 'storage',
        type: 'internal-hard-drive',
        icon: Icons.storage_rounded,
        label: l10n.configureCatStorage,
        emptyTitle: l10n.configureChooseStorage,
      ),
      _PartSlot(
        key: 'case',
        type: 'case',
        icon: Icons.desktop_windows_rounded,
        label: l10n.configureCatCase,
        emptyTitle: l10n.configureChooseCase,
      ),
      _PartSlot(
        key: 'caseFans',
        type: 'case-fan',
        icon: Icons.blur_circular_rounded,
        label: l10n.configureCatCaseFans,
        emptyTitle: l10n.configureChooseCaseFans,
      ),
      _PartSlot(
        key: 'fanController',
        type: 'fan-controller',
        icon: Icons.tune_rounded,
        label: l10n.configureCatFanController,
        emptyTitle: l10n.configureChooseFanController,
      ),
      _PartSlot(
        key: 'caseAccessories',
        type: 'case-accessory',
        icon: Icons.grid_view_rounded,
        label: l10n.configureCatCaseAccessories,
        emptyTitle: l10n.configureChooseCaseAccessories,
      ),
      _PartSlot(
        key: 'psu',
        type: 'power-supply',
        icon: Icons.power_rounded,
        label: l10n.configureCatPsu,
        emptyTitle: l10n.configureChoosePsu,
      ),
      _PartSlot(
        key: 'wifi',
        type: 'wireless-network-card',
        icon: Icons.network_wifi_rounded,
        label: l10n.configureCatWifi,
        emptyTitle: l10n.configureChooseWifi,
      ),
      _PartSlot(
        key: 'ethernet',
        type: 'wired-network-card',
        icon: Icons.settings_ethernet_rounded,
        label: l10n.configureCatEthernet,
        emptyTitle: l10n.configureChooseEthernet,
      ),
      _PartSlot(
        key: 'soundCard',
        type: 'sound-card',
        icon: Icons.volume_up_rounded,
        label: l10n.configureCatSoundCard,
        emptyTitle: l10n.configureChooseSoundCard,
      ),
      _PartSlot(
        key: 'opticalDrive',
        type: 'optical-drive',
        icon: Icons.disc_full_rounded,
        label: l10n.configureCatOpticalDrive,
        emptyTitle: l10n.configureChooseOpticalDrive,
      ),
      _PartSlot(
        key: 'externalHdd',
        type: 'external-hard-drive',
        icon: Icons.usb_rounded,
        label: l10n.configureCatExternalHdd,
        emptyTitle: l10n.configureChooseExternalHdd,
      ),
      _PartSlot(
        key: 'ups',
        type: 'ups',
        icon: Icons.battery_charging_full_rounded,
        label: l10n.configureCatUps,
        emptyTitle: l10n.configureChooseUps,
      ),
      _PartSlot(
        key: 'os',
        type: 'os',
        icon: Icons.window_rounded,
        label: l10n.configureCatOs,
        emptyTitle: l10n.configureChooseOs,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final slots = _slots(context);

    final parts = slots
        .map((slot) {
          final selected = _selectedParts[slot.key];
          return _PartTile(
            icon: slot.icon,
            label: slot.label,
            title: selected?.title ?? slot.emptyTitle,
            price: _priceLabel(selected?.price),
            isSelected: selected != null,
            onChange: () => _choosePart(slot),
          );
        })
        .toList(growable: false);

    final selection = _buildSelection();
    final partsDone = parts.where((p) => p.isSelected).length;
    final partsTotal = parts.length;
    final progress = partsTotal == 0
        ? 0.0
        : (partsDone / partsTotal).clamp(0.0, 1.0);
    final totalPrice = _selectedParts.values.fold<double>(
      0,
      (sum, part) => sum + (part.price ?? 0),
    );

    final estWatts = _estimateWattsUpperBound(
      cpuTdp: selection.cpuTdp,
      gpuChipset: selection.gpuChipset,
      ramModules: selection.ramModules,
      ssdCount: selection.ssdCount,
      hasMotherboard: selection.hasMotherboard,
      caseFans: selection.caseFans,
      hasCpuCooler: selection.hasCpuCooler,
    );

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: theme.colorScheme.surface.withValues(
                alpha: 0.92,
              ),
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
                    Expanded(
                      child: Text(
                        l10n.configureBuildTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                            l10n.configureBuildProgress,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.configurePartsCount(partsDone, partsTotal),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final p = parts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == parts.length - 1 ? 0 : 12,
                    ),
                    child: _SelectedPartCard(
                      categoryIcon: p.icon,
                      categoryLabel: p.label,
                      title: p.title,
                      price: p.price,
                      onChange: p.onChange,
                      isEmpty: !p.isSelected,
                    ),
                  );
                }, childCount: parts.length),
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
                color: theme.colorScheme.surface.withValues(alpha: 0.96),
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
                        child: _BottomMetric(
                          label: l10n.configureTotalPrice,
                          value: '\$${totalPrice.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BottomMetric(
                          label: l10n.configureEstimatedWattage,
                          value: '${estWatts}W',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 132,
                        height: 44,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                              fontSize: 12,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(l10n.configureAddToBuilds),
                          ),
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

class _BuildSelection {
  const _BuildSelection({
    required this.cpuTdp,
    required this.gpuChipset,
    required this.ramModules,
    required this.ssdCount,
    required this.hasMotherboard,
    required this.caseFans,
    required this.hasCpuCooler,
  });

  final int cpuTdp;
  final String? gpuChipset;
  final int ramModules;
  final int ssdCount;
  final bool hasMotherboard;
  final int caseFans;
  final bool hasCpuCooler;
}

class _PartSlot {
  const _PartSlot({
    required this.key,
    required this.type,
    required this.icon,
    required this.label,
    required this.emptyTitle,
  });

  final String key;
  final String type;
  final IconData icon;
  final String label;
  final String emptyTitle;
}

class _PartTile {
  const _PartTile({
    required this.icon,
    required this.label,
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onChange,
  });

  final IconData icon;
  final String label;
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onChange;
}

class _BottomMetric extends StatelessWidget {
  const _BottomMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
    final l10n = context.l10n;

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
                    isEmpty ? l10n.configureChoose : l10n.configureChange,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
