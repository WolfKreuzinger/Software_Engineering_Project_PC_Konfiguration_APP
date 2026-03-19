import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_ext.dart';
import '../models/saved_build.dart';
import '../services/compatibility_checker.dart';
import '../services/builds_repository.dart';
import '../widgets/build_cover_picker.dart';
import '../services/pending_build_save_service.dart';
import 'parts_screen.dart';

class ConfigureScreenArgs {
  const ConfigureScreenArgs({required this.build, this.readOnly = false, this.backRoute = '/dashboard'});
  final SavedBuild build;
  final bool readOnly;
  final String backRoute;
}

class ConfigureScreen extends StatefulWidget {
  const ConfigureScreen({super.key, this.initialBuild, this.readOnly = false, this.backRoute = '/dashboard'});

  final SavedBuild? initialBuild;
  final bool readOnly;
  final String backRoute;

  @override
  State<ConfigureScreen> createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  final Map<String, PartSelection> _selectedParts = <String, PartSelection>{};
  final BuildsRepository _buildsRepository = BuildsRepository();
  String? _editingBuildId;
  String? _editingBuildTitle;
  bool _isImportedBuild = false;
  String _rawImportedTitle = '';
  String _rawImportedAuthor = '';
  DateTime? _editingCreatedAt;
  bool _isSaving = false;

  void _goNextFrame(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(route);
    });
  }

  static const Set<String> _mandatorySlots = <String>{
    'cpu',
    'cpuCooler',
    'motherboard',
    'ram',
    'gpu',
    'storage',
    'case',
    'psu',
  };

  static const Map<String, String> _slotTypeByKey = <String, String>{
    'cpu': 'cpu',
    'cpuCooler': 'cpu-cooler',
    'thermalPaste': 'thermal-paste',
    'motherboard': 'motherboard',
    'ram': 'memory',
    'gpu': 'video-card',
    'storage': 'internal-hard-drive',
    'case': 'case',
    'caseFans': 'case-fan',
    'fanController': 'fan-controller',
    'caseAccessories': 'case-accessory',
    'psu': 'power-supply',
    'wifi': 'wireless-network-card',
    'ethernet': 'wired-network-card',
    'soundCard': 'sound-card',
    'opticalDrive': 'optical-drive',
    'externalHdd': 'external-hard-drive',
    'ups': 'ups',
    'os': 'os',
  };

  @override
  void initState() {
    super.initState();
    _loadInitialBuild();
  }

  void _loadInitialBuild() {
    final build = widget.initialBuild;
    if (build == null) return;
    final isTemplate = build.buildId.isEmpty || widget.readOnly;
    _editingBuildId = isTemplate ? null : build.buildId;
    if (widget.readOnly && (build.importedFrom ?? '').isNotEmpty) {
      _isImportedBuild = true;
      _rawImportedTitle = build.title;
      _rawImportedAuthor = build.importedFrom!;
    } else {
      _editingBuildTitle = build.title.isEmpty ? null : build.title;
    }
    _editingCreatedAt = isTemplate ? null : build.createdAt;
    for (final key in buildSlotKeys) {
      final raw = build.selectedParts[key];
      if (raw is! Map) continue;
      final name = (raw['name'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      final rawData = <String, dynamic>{};
      // Restore full Firestore data when available (newer saves) so the spec
      // detail sheet can show all fields, just like the components screen does.
      if (raw['rawPartData'] is Map) {
        rawData.addAll(Map<String, dynamic>.from(raw['rawPartData'] as Map));
      }
      if (raw['specSnippet'] is Map) {
        rawData['spec'] = Map<String, dynamic>.from(raw['specSnippet'] as Map);
      }
      // Always overlay the compat fields so they are present even for older saves.
      if (raw['wattage'] != null) rawData['wattage'] = raw['wattage'];
      if (raw['tdp'] != null) rawData['tdp'] = raw['tdp'];
      if (raw['chipset'] != null) rawData['chipset'] = raw['chipset'];
      if (raw['modules'] != null) rawData['modules'] = raw['modules'];
      rawData['name'] = name;
      if (raw['socket'] != null) rawData['socket'] = raw['socket'];
      if (raw['form_factor'] != null) rawData['form_factor'] = raw['form_factor'];
      if (raw['speed'] != null) rawData['speed'] = raw['speed'];
      if (raw['case_type'] != null) rawData['type'] = raw['case_type'];

      _selectedParts[key] = PartSelection(
        partId: (raw['partId'] ?? '').toString(),
        type: (raw['type'] ?? _slotTypeByKey[key] ?? '').toString(),
        title: name,
        subtitle: (raw['subtitle'] ?? '').toString(),
        price: raw['price'] is num
            ? (raw['price'] as num).toDouble()
            : double.tryParse(raw['price']?.toString() ?? ''),
        rawData: rawData,
      );
    }
    // Restore extra multi-select entries (storage_1, ram_1, caseFans_1, …)
    for (final entry in build.selectedParts.entries) {
      if (buildSlotKeys.contains(entry.key)) continue;
      final raw = entry.value;
      if (raw is! Map) continue;
      final name = (raw['name'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      final rawData = <String, dynamic>{'name': name};
      if (raw['rawPartData'] is Map) {
        rawData.addAll(Map<String, dynamic>.from(raw['rawPartData'] as Map));
      }
      if (raw['specSnippet'] is Map) {
        rawData['spec'] = Map<String, dynamic>.from(raw['specSnippet'] as Map);
      }
      rawData['name'] = name;
      if (raw['case_type'] != null && !rawData.containsKey('type')) {
        rawData['type'] = raw['case_type'];
      }
      _selectedParts[entry.key] = PartSelection(
        partId: (raw['partId'] ?? '').toString(),
        type: (raw['type'] ?? '').toString(),
        title: name,
        subtitle: (raw['subtitle'] ?? '').toString(),
        price: raw['price'] is num
            ? (raw['price'] as num).toDouble()
            : double.tryParse(raw['price']?.toString() ?? ''),
        rawData: rawData,
      );
    }
  }

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
      ssdCount: _keysForSlot('storage').length,
      hasMotherboard: _selectedParts.containsKey('motherboard'),
      caseFans: _keysForSlot('caseFans').length,
      hasCpuCooler: _selectedParts.containsKey('cpuCooler'),
    );
  }

  void _showCompatDetails(
    BuildContext context,
    CompatibilityResult result,
    int estimatedWatts,
    int psuWatts,
  ) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _CompatReportScreen(
          result: result,
          estimatedWatts: estimatedWatts,
          psuWatts: psuWatts,
        ),
      ),
    );
  }

  // ── Multi-select slots ─────────────────────────────────────────────────────
  static const _multiSelectSlots = {'storage', 'ram', 'caseFans'};

  List<String> _keysForSlot(String base) {
    final keys = <String>[];
    if (_selectedParts.containsKey(base)) keys.add(base);
    var i = 1;
    while (_selectedParts.containsKey('${base}_$i')) {
      keys.add('${base}_$i');
      i++;
    }
    return keys;
  }

  String _nextKey(String base) {
    if (!_selectedParts.containsKey(base)) return base;
    var i = 1;
    while (_selectedParts.containsKey('${base}_$i')) {
      i++;
    }
    return '${base}_$i';
  }

  void _removeSlotEntry(String removedKey, String base) {
    final allKeys = _keysForSlot(base);
    final remaining = [
      for (final k in allKeys)
        if (k != removedKey) _selectedParts[k]!,
    ];
    for (final k in allKeys) {
      _selectedParts.remove(k);
    }
    for (var i = 0; i < remaining.length; i++) {
      _selectedParts[i == 0 ? base : '${base}_$i'] = remaining[i];
    }
  }

  // ── Part picking ───────────────────────────────────────────────────────────

  Future<void> _choosePart(_PartSlot slot, {String? overrideKey}) async {
    final picked = await Navigator.of(context).push<PartSelection>(
      MaterialPageRoute(
        builder: (_) =>
            PartsScreen(lockedType: slot.type, returnSelection: true),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedParts[overrideKey ?? slot.key] = picked);
  }

  Future<void> _addPart(_PartSlot slot) async {
    await _choosePart(slot, overrideKey: _nextKey(slot.key));
  }

  /// Converts camelCase to snake_case so spec keys from Firestore snapshots
  /// (e.g. `coreCount`) match the `_labelMap` in PartsScreen (e.g. `core_count`).
  static String _camelToSnake(String key) =>
      key.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  void _viewPart(PartSelection part) {
    final data = <String, dynamic>{
      ...part.rawData,
      'name': part.title,
      'price': part.price,
    };
    // Flatten the nested spec map (stored with camelCase keys) to the top level
    // using snake_case keys so PartsScreen._detailSpecs can render them.
    final specMap = part.rawData['spec'];
    if (specMap is Map) {
      for (final e in specMap.entries) {
        final snakeKey = _camelToSnake(e.key.toString());
        data.putIfAbsent(snakeKey, () => e.value);
      }
    }
    PartsScreen.showDetailSheet(context, data, part.type, part.title);
  }

  Map<String, dynamic> _serializePart(PartSelection part) {
    final spec = part.rawData['spec'];
    // Save full rawData (minus the synthetic _category field) so the detail
    // sheet can display all specs when the build is loaded back later.
    final specData = Map<String, dynamic>.from(part.rawData)
      ..remove('_category');
    return <String, dynamic>{
      'partId': part.partId,
      'name': part.title,
      'price': part.price,
      'type': part.type,
      'subtitle': part.subtitle,
      'specSnippet': spec is Map ? Map<String, dynamic>.from(spec) : null,
      // Full raw Firestore data — used by the spec detail sheet so all fields
      // (core_count, boost_clock, microarchitecture, …) are preserved across save/reload.
      'rawPartData': part.rawData,
      'wattage': part.rawData['wattage'],
      'tdp': part.rawData['tdp'],
      'chipset': part.rawData['chipset'],
      'modules': part.rawData['modules'],
      'socket': part.rawData['socket'],
      'form_factor': part.rawData['form_factor'],
      'speed': part.rawData['speed'],
      'case_type': part.rawData['type'],
      'specData': specData,
    };
  }

  Map<String, dynamic> _serializeSelectedParts() {
    final payload = <String, dynamic>{};
    // Standard slots
    for (final key in buildSlotKeys) {
      final part = _selectedParts[key];
      payload[key] = part == null ? null : _serializePart(part);
    }
    // Extra multi-select entries (e.g. storage_1, ram_1)
    for (final entry in _selectedParts.entries) {
      if (!buildSlotKeys.contains(entry.key)) {
        payload[entry.key] = _serializePart(entry.value);
      }
    }
    return payload;
  }

  Future<void> _saveToBuilds({
    required double totalPrice,
    required int estimatedWattage,
  }) async {
    if (_selectedParts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.configureSelectComponent),
        ),
      );
      return;
    }

    // In read-only mode the title is locked — skip the name prompt.
    String? buildName;
    String? selectedCoverId = widget.initialBuild?.heroImageUrl;
    if (widget.readOnly) {
      buildName = (_editingBuildTitle ?? '').trim();
    } else {
      final info = await _promptBuildInfo(
        initial: (_editingBuildTitle ?? '').trim(),
        currentCoverId: selectedCoverId,
      );
      if (!mounted) return;
      if (info == null) return;
      buildName = info.title;
      selectedCoverId = info.heroImageUrl;
    }

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      final selectedParts = _serializeSelectedParts();
      final status = _buildsRepository.computeStatusFromSelectedParts(
        selectedParts,
      );
      PendingBuildSaveService.instance.setPending(
        PendingBuildSave(
          selectedParts: selectedParts,
          totalPrice: totalPrice,
          estimatedWattage: estimatedWattage,
          status: status,
          title: buildName,
          existingBuildId: _editingBuildId,
          existingTitle: _editingBuildTitle,
          existingCreatedAt: _editingCreatedAt,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.configureSignInPrompt),
        ),
      );
      _goNextFrame('/login');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final selectedParts = _serializeSelectedParts();
      final status = _buildsRepository.computeStatusFromSelectedParts(
        selectedParts,
      );
      final buildId = await _buildsRepository.saveBuild(
        uid: user.uid,
        existingBuildId: _editingBuildId,
        title: buildName,
        existingTitle: _editingBuildTitle,
        existingCreatedAt: _editingCreatedAt,
        selectedParts: selectedParts,
        totalPrice: totalPrice,
        estimatedWattage: estimatedWattage,
        status: status,
        readOnly: widget.readOnly,
        importedFrom: widget.readOnly
            ? widget.initialBuild?.importedFrom
            : null,
        heroImageUrl: selectedCoverId,
      );
      if (!mounted) return;
      setState(() {
        _editingBuildId = buildId;
        _editingCreatedAt ??= DateTime.now();
        _editingBuildTitle = buildName;
      });
      _goNextFrame('/my-builds');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.configureSaveBuildError(e.toString())),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<({String title, String? heroImageUrl})?> _promptBuildInfo({
    required String initial,
    String? currentCoverId,
  }) async {
    final ctrl = TextEditingController(text: initial);
    String? selectedCover = currentCoverId;
    final result = await showDialog<({String title, String? heroImageUrl})>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: Text(ctx.l10n.configureSaveBuildTitle),
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
        );
      },
    );
    ctrl.dispose();
    return result;
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

    final mandatoryParts = <_PartTile>[];
    final optionalParts = <_PartTile>[];
    for (final slot in slots) {
      _PartTile tile;
      if (_multiSelectSlots.contains(slot.key)) {
        final keys = _keysForSlot(slot.key);
        tile = _PartTile(
          icon: slot.icon,
          label: slot.label,
          emptyTitle: slot.emptyTitle,
          onChoose: () => _choosePart(slot),
          selectedEntries: [
            for (final key in keys)
              _SelectedEntry(
                part: _selectedParts[key]!,
                onView: () => _viewPart(_selectedParts[key]!),
                onChange: () => _choosePart(slot, overrideKey: key),
                onRemove: () => setState(() => _removeSlotEntry(key, slot.key)),
              ),
          ],
          isMultiSelect: true,
          onAdd: () => _addPart(slot),
          readOnly: widget.readOnly,
        );
      } else {
        final selected = _selectedParts[slot.key];
        tile = _PartTile(
          icon: slot.icon,
          label: slot.label,
          emptyTitle: slot.emptyTitle,
          onChoose: () => _choosePart(slot),
          selectedEntries: selected == null
              ? []
              : [
                  _SelectedEntry(
                    part: selected,
                    onView: () => _viewPart(selected),
                    onChange: () => _choosePart(slot),
                    onRemove: () =>
                        setState(() => _selectedParts.remove(slot.key)),
                  ),
                ],
          readOnly: widget.readOnly,
        );
      }
      if (_mandatorySlots.contains(slot.key)) {
        mandatoryParts.add(tile);
      } else {
        optionalParts.add(tile);
      }
    }

    final selection = _buildSelection();
    final mandatoryDone = slots
        .where((s) => _mandatorySlots.contains(s.key) && _selectedParts.containsKey(s.key))
        .length;
    final mandatoryTotal = _mandatorySlots.length;
    final optionalDone = slots
        .where((s) => !_mandatorySlots.contains(s.key) && _selectedParts.containsKey(s.key))
        .length;
    final optionalTotal = slots.length - mandatoryTotal;
    final partsDone = mandatoryDone + optionalDone;
    final partsTotal = slots.length;
    final mandatoryProgress = mandatoryTotal == 0
        ? 0.0
        : (mandatoryDone / mandatoryTotal).clamp(0.0, 1.0);
    final optionalProgress = optionalTotal == 0
        ? 0.0
        : (optionalDone / optionalTotal).clamp(0.0, 1.0);
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

    final rawCompatResult = CompatibilityChecker.check(
      parts: _selectedParts,
      estimatedWatts: estWatts,
      l10n: l10n,
    );
    // Append incomplete-data notices as warnings so they appear in the
    // compatibility report screen instead of inline below each component.
    final slotLabelByKey = {for (final s in slots) s.key: s.label};
    final incompleteWarnings = [
      for (final entry in _selectedParts.entries)
        if (entry.value.missingDataFields.isNotEmpty)
          CompatIssue(
            l10n.configureMissingData(slotLabelByKey[entry.key] ?? entry.key, entry.value.missingDataFields.join(', ')),
            CompatIssueLevel.warning,
          ),
    ];
    final compatResult = incompleteWarnings.isEmpty
        ? rawCompatResult
        : CompatibilityResult(
            [...rawCompatResult.issues, ...incompleteWarnings],
          );
    final psuWatts = _toInt(_selectedParts['psu']?.rawData['wattage']);
    final showCompat = _selectedParts.isNotEmpty;

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
                      onPressed: () => context.go(
                        widget.readOnly ? '/' : widget.backRoute,
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                      splashRadius: 22,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.readOnly && (_isImportedBuild || (_editingBuildTitle ?? '').isNotEmpty)
                            ? (_isImportedBuild
                                ? l10n.configureImportedFrom(_rawImportedTitle, _rawImportedAuthor)
                                : _editingBuildTitle!)
                            : l10n.configureBuildTitle,
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
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final totalWidth = constraints.maxWidth;
                          final junctionX = totalWidth *
                              mandatoryTotal /
                              (mandatoryTotal + optionalTotal);
                          final slashColor = theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 8,
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: mandatoryTotal,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(999),
                                        ),
                                        child: LinearProgressIndicator(
                                          value: mandatoryProgress,
                                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: optionalTotal,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.horizontal(
                                          right: Radius.circular(999),
                                        ),
                                        child: LinearProgressIndicator(
                                          value: optionalProgress,
                                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            Color(0xFFE8A020),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: junctionX - 5,
                                top: -5,
                                child: SizedBox(
                                  width: 10,
                                  height: 18,
                                  child: CustomPaint(
                                    painter: _SlashDividerPainter(color: slashColor),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 148),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < mandatoryParts.length) {
                    final p = mandatoryParts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SelectedPartCard(
                        categoryIcon: p.icon,
                        categoryLabel: p.label,
                        emptyTitle: p.emptyTitle,
                        onChoose: p.onChoose,
                        selectedEntries: p.selectedEntries,
                        isMultiSelect: p.isMultiSelect,
                        onAdd: p.onAdd,
                        readOnly: p.readOnly,
                      ),
                    );
                  } else {
                    return _OptionalComponentsSection(parts: optionalParts, readOnly: widget.readOnly);
                  }
                }, childCount: mandatoryParts.length + 1),
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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showCompat)
                        _CompatBar(
                          result: compatResult,
                          onViewDetails: () => _showCompatDetails(
                            context,
                            compatResult,
                            estWatts,
                            psuWatts,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                                onPressed: _isSaving
                                    ? null
                                    : () => _saveToBuilds(
                                        totalPrice: totalPrice,
                                        estimatedWattage: estWatts,
                                      ),
                                style: FilledButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                    fontSize: 12,
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _isSaving
                                        ? l10n.configureSaving
                                        : widget.readOnly
                                            ? l10n.configureAddToMyBuilds
                                            : l10n.configureAddToBuilds,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

class _SlashDividerPainter extends CustomPainter {
  const _SlashDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    // "/" forward slash: bottom-left → top-right, with inset
    const inset = 2.5;
    canvas.drawLine(
      Offset(0, size.height - inset),
      Offset(size.width, inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SlashDividerPainter old) => old.color != color;
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

class _SelectedEntry {
  const _SelectedEntry({
    required this.part,
    required this.onView,
    required this.onChange,
    required this.onRemove,
  });

  final PartSelection part;
  final VoidCallback onView;
  final VoidCallback onChange;
  final VoidCallback onRemove;
}

class _PartTile {
  const _PartTile({
    required this.icon,
    required this.label,
    required this.emptyTitle,
    required this.onChoose,
    this.selectedEntries = const [],
    this.isMultiSelect = false,
    this.onAdd,
    this.readOnly = false,
  });

  final IconData icon;
  final String label;
  final String emptyTitle;
  final VoidCallback onChoose;
  final List<_SelectedEntry> selectedEntries;
  final bool isMultiSelect;
  final VoidCallback? onAdd;
  final bool readOnly;

  bool get isSelected => selectedEntries.isNotEmpty;
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
    required this.emptyTitle,
    required this.onChoose,
    required this.selectedEntries,
    this.isMultiSelect = false,
    this.onAdd,
    this.accentColor,
    this.readOnly = false,
  });

  final IconData categoryIcon;
  final String categoryLabel;
  final String emptyTitle;
  final VoidCallback onChoose;
  final List<_SelectedEntry> selectedEntries;
  final bool isMultiSelect;
  final VoidCallback? onAdd;
  final Color? accentColor;
  final bool readOnly;

  String _priceLabel(double? price) =>
      price == null ? '-' : '\$${price.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isEmpty = selectedEntries.isEmpty;
    final accent = accentColor ?? theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Category header ──────────────────────────────────────────────
            Row(
              children: [
                Icon(categoryIcon, color: accent),
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
                if (selectedEntries.any(
                  (e) => e.part.missingDataFields.isNotEmpty,
                ))
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tooltip(
                      message: [
                        for (final e in selectedEntries.where(
                          (e) => e.part.missingDataFields.isNotEmpty,
                        ))
                          context.l10n.configureMissingDataTooltip(e.part.missingDataFields.join(', ')),
                      ].join('\n'),
                      triggerMode: TooltipTriggerMode.tap,
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: Color(0xFFE65100),
                      ),
                    ),
                  ),
              ],
            ),

            if (isEmpty) ...[
              // ── Empty state ─────────────────────────────────────────────────
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      emptyTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!readOnly)
                    TextButton(
                      onPressed: onChoose,
                      child: Text(
                        l10n.configureChoose,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: accent,
                        ),
                      ),
                    ),
                ],
              ),
            ] else ...[
              // ── Selected items ───────────────────────────────────────────────
              for (final entry in selectedEntries) ...[
                const Divider(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.part.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _priceLabel(entry.part.price),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: entry.onView,
                          child: Text(
                            l10n.commonView,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: accent,
                            ),
                          ),
                        ),
                        if (!readOnly) ...[
                          TextButton(
                            onPressed: entry.onChange,
                            child: Text(
                              l10n.configureChange,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: accent,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: entry.onRemove,
                            child: Text(
                              l10n.configureRemove,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
              // ── Hinzufügen (multi-select only) ───────────────────────────────
              if (!readOnly && isMultiSelect && onAdd != null) ...[
                const Divider(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onAdd,
                    child: Text(
                      context.l10n.configureAdd,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: accent,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}


// ── Optional components section ────────────────────────────────────────────────

class _OptionalComponentsSection extends StatefulWidget {
  const _OptionalComponentsSection({required this.parts, this.readOnly = false});

  final List<_PartTile> parts;
  final bool readOnly;

  @override
  State<_OptionalComponentsSection> createState() =>
      _OptionalComponentsSectionState();
}

class _OptionalComponentsSectionState
    extends State<_OptionalComponentsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accentColor = Color(0xFFE8A020);
    final selectedCount = widget.parts.where((p) => p.isSelected).length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.configureExtras,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (selectedCount > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.configureSelectedCount(selectedCount),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // ── Expanded content ──────────────────────────────────────────────
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  for (final p in widget.parts) ...[
                    const SizedBox(height: 10),
                    _SelectedPartCard(
                      categoryIcon: p.icon,
                      categoryLabel: p.label,
                      emptyTitle: p.emptyTitle,
                      onChoose: p.onChoose,
                      selectedEntries: p.selectedEntries,
                      isMultiSelect: p.isMultiSelect,
                      onAdd: p.onAdd,
                      accentColor: accentColor,
                      readOnly: widget.readOnly,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Compatibility bar ──────────────────────────────────────────────────────────

class _CompatBar extends StatelessWidget {
  const _CompatBar({required this.result, required this.onViewDetails});

  final CompatibilityResult result;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final Color bgColor;
    final Color fgColor;
    final IconData icon;
    final String label;

    switch (result.overallLevel) {
      case CompatIssueLevel.error:
        bgColor = const Color(0xFFEF9A9A); // red 200
        fgColor = const Color(0xFFB71C1C); // red 900
        icon = Icons.cancel_rounded;
        label = l10n.compatibilityError;
      case CompatIssueLevel.warning:
        bgColor = const Color(0xFFFFE082); // amber 200
        fgColor = const Color(0xFFE65100); // deep-orange 900
        icon = Icons.warning_amber_rounded;
        label = l10n.compatibilityWarning;
      case CompatIssueLevel.ok:
        bgColor = const Color(0xFFA5D6A7); // green 200
        fgColor = const Color(0xFF1B5E20); // green 900
        icon = Icons.check_circle_rounded;
        label = l10n.compatibilityOk;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onViewDetails,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: fgColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: fgColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Text(
                  l10n.compatibilityViewDetails,
                  style: TextStyle(
                    color: fgColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                    decorationColor: fgColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Compatibility report screen ───────────────────────────────────────────────

class _CompatReportScreen extends StatelessWidget {
  const _CompatReportScreen({
    required this.result,
    required this.estimatedWatts,
    required this.psuWatts,
  });

  final CompatibilityResult result;
  final int estimatedWatts;
  final int psuWatts;

  // ── helpers ────────────────────────────────────────────────────────────────

  static Color _sectionFg(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error => const Color(0xFFB71C1C),
    CompatIssueLevel.warning => const Color(0xFFE65100),
    CompatIssueLevel.ok => const Color(0xFF1B5E20),
  };

  static Color _sectionBg(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error => const Color(0xFFEF9A9A), // same as _CompatBar
    CompatIssueLevel.warning => const Color(0xFFFFE082),
    CompatIssueLevel.ok => const Color(0xFFA5D6A7),
  };

  static IconData _sectionIcon(CompatIssueLevel lvl) => switch (lvl) {
    CompatIssueLevel.error => Icons.cancel_rounded,
    CompatIssueLevel.warning => Icons.warning_amber_rounded,
    CompatIssueLevel.ok => Icons.check_circle_rounded,
  };

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final level = result.overallLevel;

    final errors = result.issues
        .where((i) => i.level == CompatIssueLevel.error)
        .toList();
    final warnings = result.issues
        .where((i) => i.level == CompatIssueLevel.warning)
        .toList();
    final oks = result.issues
        .where((i) => i.level == CompatIssueLevel.ok)
        .toList();

    final headerBg = _sectionBg(level);
    final headerFg = _sectionFg(level);
    final headerIcon = _sectionIcon(level);

    final String statusLabel;
    final String statusSub;
    if (errors.isNotEmpty) {
      statusLabel = l10n.compatIncompatible;
      statusSub = errors.length == 1
          ? l10n.compatSingleError
          : l10n.compatMultipleErrors(errors.length);
    } else if (warnings.isNotEmpty) {
      statusLabel = l10n.compatWarning;
      statusSub = warnings.length == 1
          ? l10n.compatSingleWarning
          : l10n.compatMultipleWarnings(warnings.length);
    } else {
      statusLabel = l10n.compatCompatible;
      statusSub = l10n.compatAllCompatible;
    }

    final showPower = estimatedWatts > 0 && psuWatts > 0;
    final loadPct = showPower
        ? (estimatedWatts / psuWatts).clamp(0.0, 1.0)
        : 0.0;
    final headroom = psuWatts - estimatedWatts;
    final Color powerBarColor = loadPct >= 0.9
        ? const Color(0xFFB71C1C)
        : loadPct >= 0.75
        ? const Color(0xFFE65100)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          l10n.compatibilityDetails,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Status header card ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: headerFg.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(headerIcon, color: headerFg, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    statusLabel,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: headerFg,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.compatOverallStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                      color: headerFg.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusSub,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: headerFg,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Power usage card ────────────────────────────────────────────
            if (showPower) ...[
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.45),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: powerBarColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.configureEstimatedWattage,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${estimatedWatts}W / ${psuWatts}W',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: powerBarColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: loadPct,
                        minHeight: 8,
                        backgroundColor: theme.colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          powerBarColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          l10n.compatPowerLoad((loadPct * 100).round()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          headroom >= 0
                              ? l10n.compatPowerBuffer(headroom)
                              : l10n.compatPowerInsufficient(-headroom),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: headroom >= 0
                                ? theme.colorScheme.onSurfaceVariant
                                : const Color(0xFFB71C1C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Issue sections ──────────────────────────────────────────────
            if (errors.isNotEmpty) ...[
              _IssueSection(
                label: l10n.compatCriticalErrors,
                issues: errors,
                level: CompatIssueLevel.error,
              ),
              const SizedBox(height: 12),
            ],
            if (warnings.isNotEmpty) ...[
              _IssueSection(
                label: l10n.compatWarnings,
                issues: warnings,
                level: CompatIssueLevel.warning,
              ),
              const SizedBox(height: 12),
            ],
            if (oks.isNotEmpty)
              _IssueSection(
                label: l10n.compatCompatible,
                issues: oks,
                level: CompatIssueLevel.ok,
              ),

            if (result.issues.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.compatibilityNoIssues,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Issue section (header + cards) ────────────────────────────────────────────

class _IssueSection extends StatelessWidget {
  const _IssueSection({
    required this.label,
    required this.issues,
    required this.level,
  });

  final String label;
  final List<CompatIssue> issues;
  final CompatIssueLevel level;

  static Color _fg(CompatIssueLevel l) => switch (l) {
    CompatIssueLevel.error => const Color(0xFFB71C1C),
    CompatIssueLevel.warning => const Color(0xFFE65100),
    CompatIssueLevel.ok => const Color(0xFF1B5E20),
  };

  static IconData _icon(CompatIssueLevel l) => switch (l) {
    CompatIssueLevel.error => Icons.cancel_rounded,
    CompatIssueLevel.warning => Icons.warning_amber_rounded,
    CompatIssueLevel.ok => Icons.check_circle_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = _fg(level);
    final icon = _icon(level);
    // Primary purple from app scheme (used as outline + icon tint)
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(icon, color: fg, size: 16),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
        // Issue cards — surfaceContainerLow bg, purple outline (same as power card)
        ...issues.map(
          (issue) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withValues(alpha: 0.45)),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: fg, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      issue.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
