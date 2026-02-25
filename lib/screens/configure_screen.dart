import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n_ext.dart';

class ConfigureScreen extends StatelessWidget {
  const ConfigureScreen({super.key});

  int _gpuFallbackWattsFromChipset(String chipset) {
    final s = chipset.toLowerCase();

    final ultra450 = [
      '4090',
      '3090',
      '3090 ti',
      '7900 xtx',
      '7900xtx',
    ];
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
    final gpu =
        gpuChipset == null ? 0 : _gpuFallbackWattsFromChipset(gpuChipset);
    final ram = ramModules * 5;
    final ssd = ssdCount * 7;
    final mb = hasMotherboard ? 60 : 0;
    final fans = caseFans * 4;
    final cpuCoolerFan = hasCpuCooler ? 4 : 0;

    return cpu + gpu + ram + ssd + mb + fans + cpuCoolerFan;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final build = _BuildSelection(
      cpuTdp: 0,
      gpuChipset: null,
      ramModules: 0,
      ssdCount: 0,
      hasMotherboard: false,
      caseFans: 0,
      hasCpuCooler: false,
    );

    final parts = <_PartTile>[
      _PartTile(
        icon: Icons.computer_rounded,
        label: l10n.configureCatCpu,
        title: l10n.configureChooseCpu,
        price: '—',
        isSelected: build.cpuTdp > 0,
      ),
      _PartTile(
        icon: Icons.air_rounded,
        label: l10n.configureCatCpuCooler,
        title: l10n.configureChooseCpuCooler,
        price: '—',
        isSelected: build.hasCpuCooler,
      ),
      _PartTile(
        icon: Icons.grain_rounded,
        label: l10n.configureCatThermalPaste,
        title: l10n.configureChooseThermalPaste,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.developer_board_rounded,
        label: l10n.configureCatMotherboard,
        title: l10n.configureChooseMotherboard,
        price: '—',
        isSelected: build.hasMotherboard,
      ),
      _PartTile(
        icon: Icons.memory_rounded,
        label: l10n.configureCatRam,
        title: l10n.configureChooseRam,
        price: '—',
        isSelected: build.ramModules > 0,
      ),
      _PartTile(
        icon: Icons.videogame_asset_rounded,
        label: l10n.configureCatGpu,
        title: l10n.configureChooseGpu,
        price: '—',
        isSelected: build.gpuChipset != null,
      ),
      _PartTile(
        icon: Icons.storage_rounded,
        label: l10n.configureCatStorage,
        title: l10n.configureChooseStorage,
        price: '—',
        isSelected: build.ssdCount > 0,
      ),
      _PartTile(
        icon: Icons.desktop_windows_rounded,
        label: l10n.configureCatCase,
        title: l10n.configureChooseCase,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.blur_circular_rounded,
        label: l10n.configureCatCaseFans,
        title: l10n.configureChooseCaseFans,
        price: '—',
        isSelected: build.caseFans > 0,
      ),
      _PartTile(
        icon: Icons.tune_rounded,
        label: l10n.configureCatFanController,
        title: l10n.configureChooseFanController,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.grid_view_rounded,
        label: l10n.configureCatCaseAccessories,
        title: l10n.configureChooseCaseAccessories,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.power_rounded,
        label: l10n.configureCatPsu,
        title: l10n.configureChoosePsu,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.network_wifi_rounded,
        label: l10n.configureCatWifi,
        title: l10n.configureChooseWifi,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.settings_ethernet_rounded,
        label: l10n.configureCatEthernet,
        title: l10n.configureChooseEthernet,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.volume_up_rounded,
        label: l10n.configureCatSoundCard,
        title: l10n.configureChooseSoundCard,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.disc_full_rounded,
        label: l10n.configureCatOpticalDrive,
        title: l10n.configureChooseOpticalDrive,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.usb_rounded,
        label: l10n.configureCatExternalHdd,
        title: l10n.configureChooseExternalHdd,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.battery_charging_full_rounded,
        label: l10n.configureCatUps,
        title: l10n.configureChooseUps,
        price: '—',
        isSelected: false,
      ),
      _PartTile(
        icon: Icons.window_rounded,
        label: l10n.configureCatOs,
        title: l10n.configureChooseOs,
        price: '—',
        isSelected: false,
      ),
    ];

    final partsDone = parts.where((p) => p.isSelected).length;
    final partsTotal = parts.length;
    final progress =
        partsTotal == 0 ? 0.0 : (partsDone / partsTotal).clamp(0.0, 1.0);

    final estWatts = _estimateWattsUpperBound(
      cpuTdp: build.cpuTdp,
      gpuChipset: build.gpuChipset,
      ramModules: build.ramModules,
      ssdCount: build.ssdCount,
      hasMotherboard: build.hasMotherboard,
      caseFans: build.caseFans,
      hasCpuCooler: build.hasCpuCooler,
    );

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor:
                  theme.colorScheme.surface.withValues(alpha: 0.92),
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              toolbarHeight: 64,
              titleSpacing: 0,
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.go('/dashboard'),
                      icon: const Icon(
                          Icons.arrow_back_rounded),
                      splashRadius: 22,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.configureBuildTitle,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(
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
                preferredSize:
                    const Size.fromHeight(46),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                          16, 0, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.configureBuildProgress,
                            style: theme.textTheme
                                .labelSmall
                                ?.copyWith(
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.configurePartsCount(partsDone, partsTotal),
                            style: theme.textTheme
                                .labelSmall
                                ?.copyWith(
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                                999),
                        child: SizedBox(
                          height: 8,
                          child:
                              LinearProgressIndicator(
                            value: progress,
                            backgroundColor: theme
                                .colorScheme
                                .surfaceContainerHighest,
                            valueColor:
                                AlwaysStoppedAnimation<
                                        Color>(
                                    theme
                                        .colorScheme
                                        .primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(
                      16, 16, 16, 92),
              sliver: SliverList(
                delegate:
                    SliverChildBuilderDelegate(
                  (context, index) {
                    final p = parts[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index ==
                                  parts.length - 1
                              ? 0
                              : 12),
                      child: _SelectedPartCard(
                        categoryIcon: p.icon,
                        categoryLabel: p.label,
                        title: p.title,
                        price: p.price,
                        onChange: () {},
                        isEmpty: !p.isSelected,
                      ),
                    );
                  },
                  childCount: parts.length,
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
                color: theme
                    .colorScheme.surface
                    .withValues(alpha: 0.96),
                border: Border(
                  top: BorderSide(
                      color: theme.colorScheme
                          .outlineVariant),
                ),
              ),
              padding:
                  const EdgeInsets.fromLTRB(
                      16, 12, 16, 12),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                          maxWidth: 560),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomMetric(
                          label: l10n.configureTotalPrice,
                          value: '\$0.00',
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
                          style:
                              FilledButton.styleFrom(
                            shape:
                                const StadiumBorder(),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                                        horizontal:
                                            10),
                            textStyle:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing:
                                  1.0,
                              fontSize: 12,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                l10n.configureAddToBuilds),
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

class _PartTile {
  const _PartTile({
    required this.icon,
    required this.label,
    required this.title,
    required this.price,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final String title;
  final String price;
  final bool isSelected;
}

class _BottomMetric extends StatelessWidget {
  const _BottomMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme
              .labelSmall
              ?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme
                .onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme
              .titleMedium
              ?.copyWith(
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

class _SelectedPartCard
    extends StatelessWidget {
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
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
            color:
                theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(categoryIcon,
                    color: theme
                        .colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    categoryLabel
                        .toUpperCase(),
                    style: theme.textTheme
                        .labelSmall
                        ?.copyWith(
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 1.0,
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onChange,
                  child: Text(
                    isEmpty
                        ? l10n.configureChoose
                        : l10n.configureChange,
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      color: theme
                          .colorScheme
                          .primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment:
                  Alignment.centerLeft,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight:
                          FontWeight.w900,
                      height: 1.12,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: theme.textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight:
                          FontWeight.w900,
                      color: isEmpty
                          ? theme
                              .colorScheme
                              .onSurfaceVariant
                          : theme
                              .colorScheme
                              .primary,
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
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
