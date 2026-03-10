import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String _typeDisplayName(String value) {
  switch (value.trim().toLowerCase().replaceAll('_', '-')) {
    case 'cpu':
      return 'CPU';
    case 'motherboard':
      return 'Motherboard';
    case 'video-card':
      return 'GPU';
    case 'memory':
      return 'RAM';
    case 'internal-hard-drive':
      return 'Storage';
    case 'power-supply':
      return 'Power Supply';
    case 'case':
      return 'Case';
    case 'cpu-cooler':
      return 'CPU Cooler';
    case 'case-fan':
      return 'Case Fan';
    case 'wired-network-card':
      return 'Ethernet Card';
    case 'wireless-network-card':
      return 'Wi-Fi Card';
    case 'sound-card':
      return 'Sound Card';
    case 'optical-drive':
      return 'Optical Drive';
    case 'fan-controller':
      return 'Fan Controller';
    case 'thermal-paste':
      return 'Thermal Paste';
    case 'external-hard-drive':
      return 'External Storage';
    case 'ups':
      return 'UPS';
    case 'case-accessory':
      return 'Case Accessory';
    case 'os':
      return 'OS';
    case 'all components':
      return 'All Components';
    default:
      return value;
  }
}

class PartSelection {
  const PartSelection({
    required this.partId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rawData,
  });

  final String partId;
  final String type;
  final String title;
  final String subtitle;
  final double? price;
  final Map<String, dynamic> rawData;
}

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key, this.lockedType, this.returnSelection = false});

  final String? lockedType;
  final bool returnSelection;

  /// Opens the spec detail bottom sheet for a given part.
  /// [data] should be the part's raw data map (PartSelection.rawData + price).
  static void showDetailSheet(
    BuildContext context,
    Map<String, dynamic> data,
    String type,
    String title,
  ) {
    _PartsScreenState._showDetailSheetImpl(context, data, type, title);
  }

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  final Map<String, _PartIndex> _partIndexCache = <String, _PartIndex>{};

  // static const int _kLimitPerCategory = 10;
  bool _isLoading = true;
  String? _loadError;
  List<(String, Map<String, dynamic>)> _allParts = [];

  String _selectedType = 'All Components';
  String _selectedSort = 'Price: Low to High';
  RangeValues _priceRange = const RangeValues(0, 5000);
  Map<String, RangeValues> _specFilters = {};

  static const _types = <String>[
    'All Components',
    'case',           // Case
    'case-accessory', // Case Accessory
    'case-fan',       // Case Fan
    'cpu',            // CPU
    'cpu-cooler',     // CPU Cooler
    'wired-network-card',   // Ethernet Card
    'external-hard-drive',  // External Storage
    'fan-controller', // Fan Controller
    'video-card',     // GPU
    'motherboard',    // Motherboard
    'optical-drive',  // Optical Drive
    'os',             // OS
    'power-supply',   // Power Supply
    'memory',         // RAM
    'sound-card',     // Sound Card
    'internal-hard-drive',  // Storage
    'thermal-paste',  // Thermal Paste
    'ups',            // UPS
    'wireless-network-card', // Wi-Fi Card
  ];

  static const _sorts = <String>[
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
  ];

  bool get _isTypeLocked => (widget.lockedType ?? '').trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isTypeLocked) {
      _selectedType = _canonicalType(widget.lockedType!);
    }
    _loadParts();
  }

  /// Load all items from each per-type collection.
  /// Each document gets a synthetic `_category` field so type-detection works
  /// without relying on stored `metadata.datasetType`.
  Future<void> _loadParts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    final db = FirebaseFirestore.instance;
    final parts = <(String, Map<String, dynamic>)>[];

    // Determine which categories to load
    final categories = _isTypeLocked
        ? [_canonicalType(widget.lockedType!)]
        : _types.where((t) => t != 'All Components').toList();

    String? firstError;

    for (final cat in categories) {
      try {
        final snap = await db.collection(cat).get(); // .limit(_kLimitPerCategory)
        for (final d in snap.docs) {
          final data = Map<String, dynamic>.from(d.data());
          data['_category'] = cat;
          parts.add((d.reference.path, data));
        }
      } catch (e) {
        firstError ??= '$cat: $e';
        // ignore: avoid_print
        print('[_loadParts] error loading $cat: $e');
      }
    }

    if (!mounted) return;
    setState(() {
      _allParts = parts;
      _loadError = parts.isEmpty ? firstError : null;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applySearch() {
    final next = _searchCtrl.text;
    if (next == _searchQuery) return;
    setState(() => _searchQuery = next);
  }

  static String _normType(String s) {
    return s
        .trim()
        .toLowerCase()
        .replaceAll('_', '-')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  static String _camelToKebab(String s) {
    final t = s.trim();
    if (t.isEmpty) return '';
    final out = t.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m.group(1)}-${m.group(2)}',
    );
    return _normType(out);
  }

  static const Map<String, String> _typeAliases = {
    'gpu': 'video-card',
    'psu': 'power-supply',
    'cooler': 'cpu-cooler',
    'storage': 'internal-hard-drive',
    'external-storage': 'external-hard-drive',
    'case-fan': 'case-fan',
    'casefan': 'case-fan',
    'case-accessory': 'case-accessory',
    'caseaccessory': 'case-accessory',
    'fan-controller': 'fan-controller',
    'fancontroller': 'fan-controller',
    'wired-network-card': 'wired-network-card',
    'wirednic': 'wired-network-card',
    'wireless-network-card': 'wireless-network-card',
    'wirelessnic': 'wireless-network-card',
    'sound-card': 'sound-card',
    'soundcard': 'sound-card',
    'optical-drive': 'optical-drive',
    'opticaldrive': 'optical-drive',
    'thermal-paste': 'thermal-paste',
    'thermalpaste': 'thermal-paste',
    'external-hard-drive': 'external-hard-drive',
    'cpu-cooler': 'cpu-cooler',
    'video-card': 'video-card',
    'power-supply': 'power-supply',
    'internal-hard-drive': 'internal-hard-drive',
    'motherboard': 'motherboard',
    'memory': 'memory',
    'case': 'case',
    'cpu': 'cpu',
    'os': 'os',
    'ups': 'ups',
  };

  static String _canonicalType(String value) {
    final normalized = _normType(value);
    return _typeAliases[normalized] ?? normalized;
  }

  static String _datasetTypeFrom(Map<String, dynamic> data) {
    // Injected by _loadParts() from the collection name — always correct
    final cat = data['_category'];
    if (cat != null && cat.toString().trim().isNotEmpty) {
      return _canonicalType(cat.toString());
    }

    // Legacy fallback: old schema stored metadata.datasetType
    final meta = data['metadata'];
    if (meta is Map) {
      final ds = meta['datasetType'];
      if (ds != null && ds.toString().trim().isNotEmpty) {
        return _canonicalType(ds.toString());
      }
    }

    return '';
  }

  static String _displayType(String value) => _typeDisplayName(_canonicalType(value));

  static double _toDouble(dynamic v) {
    if (v == null) return double.nan;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? double.nan;
    return double.nan;
  }

  static int _toInt(dynamic v) {
    if (v == null) return -1;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? -1;
    return -1;
  }

  static String _money(dynamic v) {
    final d = _toDouble(v);
    if (d.isNaN) return '—';
    return '\$${d.toStringAsFixed(2)}';
  }

  static String _titleFor(Map<String, dynamic> data) {
    final name = (data['name'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;
    final model = (data['model'] ?? '').toString().trim();
    if (model.isNotEmpty) return model;
    return 'Unknown Part';
  }

  static String _subtitleFor(Map<String, dynamic> data) {
    final type = _datasetTypeFrom(data);
    final spec = data['spec'];

    if (type == 'video-card') {
      final mem = _toInt(
        (spec is Map ? spec['memory'] : null) ?? data['memory'],
      );
      final chipset =
          ((spec is Map ? spec['chipset'] : null) ?? data['chipset'] ?? '')
              .toString();
      final boost = _toInt(
        (spec is Map ? spec['boostClock'] : null) ?? data['boost_clock'],
      );
      final pieces = <String>[];
      if (mem > 0) pieces.add('${mem}GB');
      if (chipset.isNotEmpty) pieces.add(chipset);
      if (boost > 0) pieces.add('$boost MHz');
      return pieces.isEmpty ? 'Graphics card' : pieces.join(' • ');
    }

    if (type == 'cpu') {
      final cores = _toInt(
        (spec is Map ? spec['coreCount'] : null) ?? data['core_count'],
      );
      final threads = _toInt(
        (spec is Map ? spec['threadCount'] : null) ?? data['thread_count'],
      );
      final tdp = _toInt((spec is Map ? spec['tdp'] : null) ?? data['tdp']);
      final pieces = <String>[];
      if (cores > 0) pieces.add('$cores cores');
      if (threads > 0) pieces.add('$threads threads');
      if (tdp > 0) pieces.add('$tdp W');
      return pieces.isEmpty ? 'Processor' : pieces.join(' • ');
    }

    if (type == 'memory') {
      final speed = (spec is Map ? spec['speed'] : null) ?? data['speed'];
      final modules = (spec is Map ? spec['modules'] : null) ?? data['modules'];
      final cas = _toInt(
        (spec is Map ? spec['casLatency'] : null) ?? data['cas_latency'],
      );
      final pieces = <String>[];
      if (modules is List && modules.length >= 2) {
        final count = _toInt(modules[0]);
        final size = _toInt(modules[1]);
        if (count > 0 && size > 0) pieces.add('${count}x${size}GB');
      }
      if (speed is List && speed.length >= 2) {
        final ddr = _toInt(speed[0]);
        final mhz = _toInt(speed[1]);
        if (ddr > 0 && mhz > 0) pieces.add('DDR$ddr $mhz');
      }
      if (cas > 0) pieces.add('CL$cas');
      return pieces.isEmpty ? 'Memory' : pieces.join(' • ');
    }

    if (type == 'internal-hard-drive') {
      final cap = _toInt(
        (spec is Map ? spec['capacityGb'] : null) ?? data['capacity'],
      );
      final iface =
          ((spec is Map ? spec['interface'] : null) ?? data['interface'] ?? '')
              .toString();
      final pieces = <String>[];
      if (cap > 0) pieces.add('${cap}GB');
      if (iface.isNotEmpty) pieces.add(iface);
      return pieces.isEmpty ? 'Storage' : pieces.join(' • ');
    }

    if (type == 'motherboard') {
      final socket =
          ((spec is Map ? spec['socket'] : null) ?? data['socket'] ?? '')
              .toString();
      final ff =
          ((spec is Map ? spec['formFactor'] : null) ??
                  data['form_factor'] ??
                  '')
              .toString();
      final pieces = <String>[];
      if (socket.isNotEmpty) pieces.add(socket);
      if (ff.isNotEmpty) pieces.add(ff);
      return pieces.isEmpty ? 'Motherboard' : pieces.join(' • ');
    }

    if (type == 'power-supply') {
      final w = _toInt(
        (spec is Map ? spec['wattage'] : null) ?? data['wattage'],
      );
      final eff =
          ((spec is Map ? spec['efficiency'] : null) ??
                  data['efficiency'] ??
                  '')
              .toString();
      final pieces = <String>[];
      if (w > 0) pieces.add('${w}W');
      if (eff.isNotEmpty) pieces.add(eff);
      return pieces.isEmpty ? 'Power supply' : pieces.join(' • ');
    }

    if (type == 'case') {
      final panel =
          ((spec is Map ? spec['sidePanel'] : null) ?? data['side_panel'] ?? '')
              .toString();
      final pieces = <String>[];
      if (panel.isNotEmpty) pieces.add(panel);
      return pieces.isEmpty ? 'Case' : pieces.join(' • ');
    }

    if (type == 'cpu-cooler') {
      final rpm = (spec is Map ? spec['rpm'] : null) ?? data['rpm'];
      final pieces = <String>[];
      if (rpm is List && rpm.length >= 2) {
        final a = _toInt(rpm[0]);
        final b = _toInt(rpm[1]);
        if (a > 0 && b > 0) pieces.add('$a–$b RPM');
      } else {
        final single = _toInt(rpm);
        if (single > 0) pieces.add('$single RPM');
      }
      final noise =
          (spec is Map ? spec['noiseLevelDb'] : null) ?? data['noise_level'];
      if (noise is num) pieces.add('${noise.toString()} dBA');
      return pieces.isEmpty ? 'CPU cooler' : pieces.join(' • ');
    }

    if (type == 'case-fan') {
      final size = _toInt(
        (spec is Map ? spec['sizeMm'] : null) ?? data['size'],
      );
      final pwm = ((spec is Map ? spec['pwm'] : null) ?? data['pwm']) == true
          ? 'PWM'
          : '';
      final pieces = <String>[];
      if (size > 0) pieces.add('${size}mm');
      if (pwm.isNotEmpty) pieces.add(pwm);
      return pieces.isEmpty ? 'Case fan' : pieces.join(' • ');
    }

    final extra =
        (data['chipset'] ?? data['manufacturer'] ?? data['brand'] ?? '')
            .toString();
    return extra.isEmpty ? 'Component' : extra;
  }

  static String _normalizeForSearch(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  _PartIndex _partIndexFor(String docId, Map<String, dynamic> data) {
    final cached = _partIndexCache[docId];
    if (cached != null) return cached;

    final type = _datasetTypeFrom(data);
    final meta = data['metadata'];
    final spec = data['spec'];
    final ds = (meta is Map ? meta['datasetType'] : null)?.toString() ?? '';
    final hay = <String>[
      (data['name'] ?? '').toString(),
      (data['brand'] ?? '').toString(),
      (data['manufacturer'] ?? '').toString(),
      (data['model'] ?? '').toString(),
      (data['chipset'] ?? '').toString(),
      (data['type'] ?? '').toString(),
      ds,
      type,
      if (spec is Map)
        ...spec.values.where((v) => v != null).map((v) => v.toString()),
    ].join(' ');

    final idx = _PartIndex(
      type: type,
      price: _toDouble(data['price']),
      searchHay: _normalizeForSearch(hay),
    );
    _partIndexCache[docId] = idx;
    return idx;
  }

  bool _matchesSelectedTypeIdx(String selectedType, _PartIndex idx) {
    if (selectedType == 'All Components') return true;
    return idx.type == _canonicalType(selectedType);
  }

  bool _matchesSearchIdx(String q, _PartIndex idx) {
    if (q.trim().isEmpty) return true;
    final normalizedQuery = _normalizeForSearch(q);
    if (normalizedQuery.isEmpty) return true;
    final queryTerms = normalizedQuery.split(' ');
    return queryTerms.every(idx.searchHay.contains);
  }

  static bool _matchesPrice(RangeValues r, _PartIndex idx) {
    final p = idx.price;
    if (p.isNaN) return true;
    return p >= r.start && p <= r.end;
  }

  bool _matchesSpecs(
    Map<String, RangeValues> specFilters,
    Map<String, dynamic> data,
  ) {
    if (specFilters.isEmpty) return true;
    final defs = _typeSpecDefs[_selectedType] ?? [];
    for (final def in defs) {
      final filterRange = specFilters[def.dataKey];
      if (filterRange == null) continue;
      if (filterRange.start == def.min && filterRange.end == def.max) continue;
      final spec = data['spec'];
      dynamic rawVal;
      if (spec is Map) {
        rawVal = spec[def.specKey] ?? spec[def.dataKey] ?? data[def.dataKey];
      } else {
        rawVal = data[def.dataKey];
      }
      final numVal = _toDouble(rawVal);
      if (!numVal.isNaN &&
          (numVal < filterRange.start || numVal > filterRange.end)) {
        return false;
      }
    }
    return true;
  }

  static IconData _iconForType(String type) {
    switch (_normType(type)) {
      case 'cpu':
        return Icons.developer_board_rounded;
      case 'motherboard':
        return Icons.view_module_rounded;
      case 'video-card':
        return Icons.videogame_asset_rounded;
      case 'memory':
        return Icons.memory_rounded;
      case 'internal-hard-drive':
      case 'external-hard-drive':
        return Icons.storage_rounded;
      case 'power-supply':
      case 'ups':
        return Icons.power_rounded;
      case 'case':
        return Icons.crop_square_rounded;
      case 'cpu-cooler':
        return Icons.ac_unit_rounded;
      case 'case-fan':
        return Icons.air_rounded;
      case 'fan-controller':
        return Icons.tune_rounded;
      case 'wired-network-card':
      case 'wireless-network-card':
        return Icons.wifi_rounded;
      case 'sound-card':
        return Icons.graphic_eq_rounded;
      case 'optical-drive':
        return Icons.album_rounded;
      case 'os':
        return Icons.window_rounded;
      case 'thermal-paste':
        return Icons.opacity_rounded;
      case 'case-accessory':
        return Icons.extension_rounded;
      default:
        return Icons.build_circle_rounded;
    }
  }

  static int _sortCompare(
    String sort,
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    if (sort == 'Name: A to Z') {
      final an = _titleFor(a).toLowerCase();
      final bn = _titleFor(b).toLowerCase();
      return an.compareTo(bn);
    }

    final ap = _toDouble(a['price']);
    final bp = _toDouble(b['price']);

    final aHas = !ap.isNaN;
    final bHas = !bp.isNaN;

    if (!aHas && !bHas) return 0;
    if (!aHas) return 1;
    if (!bHas) return -1;

    if (sort == 'Price: High to Low') {
      return bp.compareTo(ap);
    }
    return ap.compareTo(bp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    children: [
                      if (widget.returnSelection)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        )
                      else
                        const SizedBox(width: 48),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Components',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Builder(
                              builder: (context) {
                                final count = _isLoading
                                    ? 0
                                    : _allParts
                                          .where(
                                            (p) => _matchesSelectedTypeIdx(
                                              _selectedType,
                                              _partIndexFor(p.$1, p.$2),
                                            ),
                                          )
                                          .where(
                                            (p) => _matchesSearchIdx(
                                              _searchQuery,
                                              _partIndexFor(p.$1, p.$2),
                                            ),
                                          )
                                          .where(
                                            (p) => _matchesPrice(
                                              _priceRange,
                                              _partIndexFor(p.$1, p.$2),
                                            ),
                                          )
                                          .length;
                                return Text(
                                  '$count Products Found',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (!_isTypeLocked)
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (_) => _FiltersSheet(
                                types: _types,
                                sorts: _sorts,
                                selectedType: _selectedType,
                                selectedSort: _selectedSort,
                                priceRange: _priceRange,
                                onApply: (t, sort, range) {
                                  setState(() {
                                    _selectedType = t;
                                    _selectedSort = sort;
                                    _priceRange = range;
                                  });
                                  Navigator.of(context).pop();
                                },
                                theme: theme,
                              ),
                            );
                          },
                          icon: const Icon(Icons.tune_rounded),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: _SearchField(
                    controller: _searchCtrl,
                    hint: 'Search parts (e.g. RTX 3080)',
                    onSubmitted: (_) => _applySearch(),
                    onSearchTap: _applySearch,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_isTypeLocked)
                          _LockedPill(label: _displayType(_selectedType))
                        else
                          _Pill(
                            label: _typeDisplayName(_selectedType),
                            selected: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (_) => _SimplePickerSheet(
                                  title: 'Component Type',
                                  items: _types,
                                  selected: _selectedType,
                                  onPick: (v) {
                                    setState(() {
                                      _selectedType = v;
                                      _specFilters = {};
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  theme: theme,
                                  labelFor: _typeDisplayName,
                                ),
                              );
                            },
                          ),
                        if (_selectedType != 'All Components' &&
                            (_typeSpecDefs[_selectedType]?.isNotEmpty ??
                                false)) ...[
                          const SizedBox(width: 10),
                          _Pill(
                            label: _specFilters.isEmpty
                                ? 'Specs'
                                : 'Specs (${_specFilters.length})',
                            selected: _specFilters.isNotEmpty,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (_) => _SpecsSheet(
                                  selectedType: _selectedType,
                                  specFilters: Map.from(_specFilters),
                                  onApply: (filters) {
                                    setState(() => _specFilters = filters);
                                    Navigator.of(context).pop();
                                  },
                                  theme: theme,
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(width: 10),
                        _Pill(
                          label: 'Sort',
                          selected: _selectedSort != _sorts[0] ||
                              _priceRange.start > 0 ||
                              _priceRange.end < 5000,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (_) => _SortSheet(
                                sorts: _sorts,
                                selectedSort: _selectedSort,
                                priceRange: _priceRange,
                                onApply: (sort, range) {
                                  setState(() {
                                    _selectedSort = sort;
                                    _priceRange = range;
                                  });
                                  Navigator.of(context).pop();
                                },
                                theme: theme,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
                Expanded(child: _buildPartsList(context, theme, cs)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Parts list ─────────────────────────────────────────────────────────────

  Widget _buildPartsList(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return _EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Error',
        subtitle: _loadError!,
        theme: theme,
      );
    }

    if (_allParts.isEmpty) {
      return _EmptyState(
        icon: Icons.cloud_off_rounded,
        title: 'No data loaded',
        subtitle: 'No parts found in any collection.',
        theme: theme,
      );
    }

    final filtered = _allParts
        .map((p) => (p.$1, p.$2, _partIndexFor(p.$1, p.$2)))
        .where((e) => _matchesSelectedTypeIdx(_selectedType, e.$3))
        .where((e) => _matchesSearchIdx(_searchQuery, e.$3))
        .where((e) => _matchesPrice(_priceRange, e.$3))
        .where((e) => _matchesSpecs(_specFilters, e.$2))
        .toList();

    filtered.sort((a, b) => _sortCompare(_selectedSort, a.$2, b.$2));

    if (filtered.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No results',
        subtitle: 'Try adjusting filters or search.',
        theme: theme,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final id = filtered[i].$1;
        final data = filtered[i].$2;
        final idx = filtered[i].$3;
        final title = _titleFor(data);
        final subtitle = _subtitleFor(data);
        final price = _money(data['price']);
        final type = idx.type;

        return _PartCard(
          theme: theme,
          icon: _iconForType(type),
          title: title,
          specs: subtitle,
          price: price,
          actionText: widget.returnSelection ? 'Add to Configuration' : 'View',
          secondaryActionText: widget.returnSelection ? 'View' : null,
          actionEnabled: true,
          onTapAction: () {
            if (widget.returnSelection) {
              Navigator.of(context).pop(
                PartSelection(
                  partId: id,
                  type: type,
                  title: title,
                  subtitle: subtitle,
                  price: _toDouble(data['price']).isNaN
                      ? null
                      : _toDouble(data['price']),
                  rawData: Map<String, dynamic>.from(data),
                ),
              );
            } else {
              _showDetailSheetImpl(context, data, type, title);
            }
          },
          onTapSecondary: widget.returnSelection
              ? () => _showDetailSheetImpl(context, data, type, title)
              : null,
        );
      },
    );
  }

  // ── Detail bottom sheet ────────────────────────────────────────────────────

  static void _showDetailSheetImpl(
    BuildContext context,
    Map<String, dynamic> data,
    String type,
    String title,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final specs = _detailSpecs(data);
    final price = _money(data['price']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              // Header row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _iconForType(type),
                        color: cs.onPrimaryContainer,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.secondaryContainer.withValues(
                                alpha: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              _displayType(type),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSecondaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      price,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24, indent: 20, endIndent: 20),
              // Spec list
              Expanded(
                child: specs.isEmpty
                    ? Center(
                        child: Text(
                          'No specs available.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        itemCount: specs.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  specs[i].$1,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  specs[i].$2,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Spec extraction ────────────────────────────────────────────────────────

  // Human-readable labels for the raw snake_case field names from the dataset
  static const _labelMap = <String, String>{
    'core_count': 'Core Count',
    'core_clock': 'Core Clock',
    'boost_clock': 'Boost Clock',
    'microarchitecture': 'Architecture',
    'tdp': 'TDP',
    'graphics': 'Integrated Graphics',
    'socket': 'Socket',
    'chipset': 'Chipset',
    'memory': 'Memory',
    'length': 'Length',
    'form_factor': 'Form Factor',
    'max_memory': 'Max Memory',
    'memory_slots': 'Memory Slots',
    'speed': 'Speed',
    'modules': 'Modules',
    'price_per_gb': 'Price / GB',
    'first_word_latency': 'First Word Latency',
    'cas_latency': 'CAS Latency',
    'capacity': 'Capacity',
    'interface': 'Interface',
    'cache': 'Cache',
    'type': 'Type',
    'psu': 'Included PSU',
    'side_panel': 'Side Panel',
    'external_volume': 'External Volume',
    'internal_35_bays': 'Internal 3.5" Bays',
    'wattage': 'Wattage',
    'efficiency': 'Efficiency',
    'modular': 'Modular',
    'rpm': 'RPM',
    'noise_level': 'Noise Level',
    'size': 'Size',
    'airflow': 'Airflow',
    'pwm': 'PWM',
    'channels': 'Channels',
    'channel_wattage': 'Channel Wattage',
    'protocol': 'Protocol',
    'snr': 'SNR',
    'sample_rate': 'Sample Rate',
    'digital_audio': 'Digital Audio',
    'bd': 'Blu-ray Read',
    'bd_write': 'Blu-ray Write',
    'dvd': 'DVD Read',
    'dvd_write': 'DVD Write',
    'cd': 'CD Read',
    'cd_write': 'CD Write',
    'capacity_w': 'Capacity (W)',
    'capacity_va': 'Capacity (VA)',
    'amount': 'Amount',
    'mode': 'Mode',
    'color': 'Color',
    'brand': 'Brand',
  };

  static const _skipFields = <String>{
    'name',
    '_category',
    'price',
    'metadata',
    'spec',
  };

  static String _prettyKey(String key) {
    if (_labelMap.containsKey(key)) return _labelMap[key]!;
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static String _formatValue(dynamic v) {
    if (v == null) return '';
    if (v is bool) return v ? 'Yes' : 'No';
    if (v is List) {
      final parts = v
          .where((e) => e != null)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e != 'null')
          .toList();
      return parts.join(' / ');
    }
    return v.toString().trim();
  }

  static List<(String, String)> _detailSpecs(Map<String, dynamic> data) {
    final rows = <(String, String)>[];

    // brand first
    final brand = data['brand']?.toString().trim() ?? '';
    if (brand.isNotEmpty && brand != 'null') {
      rows.add(('Brand', brand));
    }

    for (final e in data.entries) {
      final key = e.key;
      if (_skipFields.contains(key) || key == 'brand') continue;
      if (e.value is Map) continue; // skip nested objects
      final formatted = _formatValue(e.value);
      if (formatted.isEmpty || formatted == 'null') continue;
      rows.add((_prettyKey(key), formatted));
    }

    return rows;
  }
}

class _PartIndex {
  final String type;
  final double price;
  final String searchHay;

  const _PartIndex({
    required this.type,
    required this.price,
    required this.searchHay,
  });
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onSearchTap;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onSubmitted,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final themeBorder = theme.inputDecorationTheme.border;
    final radius = themeBorder is OutlineInputBorder
        ? themeBorder.borderRadius
        : BorderRadius.circular(18);
    final borderSide = BorderSide(
      color: cs.outlineVariant.withValues(alpha: 0.35),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: borderSide,
    );

    return ClipRRect(
      borderRadius: radius,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.6),
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: IconButton(
            onPressed: onSearchTap,
            icon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
          ),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder.copyWith(
            borderSide: BorderSide(color: cs.primary, width: 1.4),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = selected ? cs.primary : cs.primaryContainer.withOpacity(0.6);
    final fg = selected ? cs.onPrimary : cs.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: fg),
          ],
        ),
      ),
    );
  }
}

class _LockedPill extends StatelessWidget {
  const _LockedPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String specs;
  final String price;
  final String actionText;
  final String? secondaryActionText;
  final bool actionEnabled;
  final VoidCallback onTapAction;
  final VoidCallback? onTapSecondary;

  const _PartCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.specs,
    required this.price,
    required this.actionText,
    required this.secondaryActionText,
    required this.actionEnabled,
    required this.onTapAction,
    this.onTapSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final hasTopAction = secondaryActionText != null;
    final topInset = hasTopAction ? 12.0 : 0.0;

    return Container(
      constraints: const BoxConstraints(minHeight: 132),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                SizedBox(
                  width: 86,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: topInset + 4),
                      Icon(icon, color: cs.onSurfaceVariant, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        specs,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: hasTopAction ? 96 : 0),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 10 + topInset),
                      Transform.translate(
                        offset: const Offset(0, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                price,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: actionEnabled ? onTapAction : null,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                textStyle: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              child: Text(actionText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (secondaryActionText != null)
            Positioned(
              top: 12,
              right: 12,
              child: OutlinedButton(
                onPressed: onTapSecondary,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: Text(secondaryActionText!),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: cs.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  final List<String> types;
  final List<String> sorts;
  final String selectedType;
  final String selectedSort;
  final RangeValues priceRange;
  final void Function(String type, String sort, RangeValues range) onApply;
  final ThemeData theme;

  const _FiltersSheet({
    required this.types,
    required this.sorts,
    required this.selectedType,
    required this.selectedSort,
    required this.priceRange,
    required this.onApply,
    required this.theme,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String _type = widget.selectedType;
  late String _sort = widget.selectedSort;
  late RangeValues _range = widget.priceRange;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Component Type',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.types.map((t) {
                    final selected = t == _type;
                    return InkWell(
                      onTap: () => setState(() => _type = t),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary
                              : cs.surfaceContainerHighest.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _typeDisplayName(t),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: selected ? cs.onPrimary : cs.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price Range',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                RangeSlider(
                  values: _range,
                  min: 0,
                  max: 5000,
                  divisions: 100,
                  labels: RangeLabels(
                    _range.start.toStringAsFixed(0),
                    _range.end.toStringAsFixed(0),
                  ),
                  onChanged: (v) => setState(() => _range = v),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sort',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.sorts.map((s) {
                    final selected = s == _sort;
                    return InkWell(
                      onTap: () => setState(() => _sort = s),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary
                              : cs.surfaceContainerHighest.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          s,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: selected ? cs.onPrimary : cs.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => widget.onApply(_type, _sort, _range),
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SimplePickerSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selected;
  final ValueChanged<String> onPick;
  final ThemeData theme;
  final String Function(String)? labelFor;

  const _SimplePickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onPick,
    required this.theme,
    this.labelFor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map((e) {
          final isSelected = e == selected;
          return ListTile(
            onTap: () => onPick(e),
            title: Text(
              labelFor != null ? labelFor!(e) : e,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle_rounded, color: cs.primary)
                : null,
          );
        }),
      ],
    );
  }
}

// ── Spec definitions per component type ────────────────────────────────────

class _SpecDef {
  final String specKey;
  final String dataKey;
  final String label;
  final double min;
  final double max;
  final String unit;
  final int divisions;

  const _SpecDef({
    required this.specKey,
    required this.dataKey,
    required this.label,
    required this.min,
    required this.max,
    required this.unit,
    this.divisions = 50,
  });
}

const Map<String, List<_SpecDef>> _typeSpecDefs = {
  'cpu': [
    _SpecDef(
      specKey: 'coreCount',
      dataKey: 'core_count',
      label: 'Core Count',
      min: 1,
      max: 64,
      unit: '',
      divisions: 63,
    ),
    _SpecDef(
      specKey: 'threadCount',
      dataKey: 'thread_count',
      label: 'Thread Count',
      min: 1,
      max: 128,
      unit: '',
      divisions: 127,
    ),
    _SpecDef(
      specKey: 'boostClock',
      dataKey: 'boost_clock',
      label: 'Boost Clock',
      min: 1000,
      max: 7000,
      unit: 'MHz',
      divisions: 60,
    ),
    _SpecDef(
      specKey: 'tdp',
      dataKey: 'tdp',
      label: 'TDP',
      min: 0,
      max: 300,
      unit: 'W',
      divisions: 60,
    ),
  ],
  'video-card': [
    _SpecDef(
      specKey: 'memory',
      dataKey: 'memory',
      label: 'VRAM',
      min: 2,
      max: 24,
      unit: 'GB',
      divisions: 11,
    ),
    _SpecDef(
      specKey: 'boostClock',
      dataKey: 'boost_clock',
      label: 'Boost Clock',
      min: 500,
      max: 3000,
      unit: 'MHz',
      divisions: 50,
    ),
    _SpecDef(
      specKey: 'tdp',
      dataKey: 'tdp',
      label: 'TDP',
      min: 50,
      max: 500,
      unit: 'W',
      divisions: 90,
    ),
    _SpecDef(
      specKey: 'length',
      dataKey: 'length',
      label: 'Length',
      min: 100,
      max: 420,
      unit: 'mm',
      divisions: 64,
    ),
  ],
  'memory': [
    _SpecDef(
      specKey: 'casLatency',
      dataKey: 'cas_latency',
      label: 'CAS Latency',
      min: 10,
      max: 48,
      unit: 'CL',
      divisions: 38,
    ),
    _SpecDef(
      specKey: 'firstWordLatency',
      dataKey: 'first_word_latency',
      label: 'First Word Latency',
      min: 1,
      max: 20,
      unit: 'ns',
      divisions: 38,
    ),
  ],
  'internal-hard-drive': [
    _SpecDef(
      specKey: 'capacityGb',
      dataKey: 'capacity',
      label: 'Capacity',
      min: 100,
      max: 20000,
      unit: 'GB',
      divisions: 100,
    ),
    _SpecDef(
      specKey: 'cache',
      dataKey: 'cache',
      label: 'Cache',
      min: 0,
      max: 2000,
      unit: 'MB',
      divisions: 100,
    ),
  ],
  'motherboard': [
    _SpecDef(
      specKey: 'maxMemory',
      dataKey: 'max_memory',
      label: 'Max Memory',
      min: 8,
      max: 256,
      unit: 'GB',
      divisions: 31,
    ),
    _SpecDef(
      specKey: 'memorySlots',
      dataKey: 'memory_slots',
      label: 'Memory Slots',
      min: 2,
      max: 8,
      unit: '',
      divisions: 6,
    ),
  ],
  'power-supply': [
    _SpecDef(
      specKey: 'wattage',
      dataKey: 'wattage',
      label: 'Wattage',
      min: 300,
      max: 1600,
      unit: 'W',
      divisions: 65,
    ),
  ],
  'case': [
    _SpecDef(
      specKey: 'internal35Bays',
      dataKey: 'internal_35_bays',
      label: '3.5" Bays',
      min: 0,
      max: 10,
      unit: '',
      divisions: 10,
    ),
  ],
  'cpu-cooler': [
    _SpecDef(
      specKey: 'noiseLevelDb',
      dataKey: 'noise_level',
      label: 'Noise Level',
      min: 0,
      max: 50,
      unit: 'dBA',
      divisions: 50,
    ),
  ],
  'case-fan': [
    _SpecDef(
      specKey: 'sizeMm',
      dataKey: 'size',
      label: 'Size',
      min: 80,
      max: 200,
      unit: 'mm',
      divisions: 12,
    ),
    _SpecDef(
      specKey: 'noiseLevelDb',
      dataKey: 'noise_level',
      label: 'Noise Level',
      min: 0,
      max: 50,
      unit: 'dBA',
      divisions: 50,
    ),
    _SpecDef(
      specKey: 'airflow',
      dataKey: 'airflow',
      label: 'Airflow',
      min: 0,
      max: 100,
      unit: 'CFM',
      divisions: 50,
    ),
  ],
};

// ── Sort sheet (sort order + price range) ───────────────────────────────────

class _SortSheet extends StatefulWidget {
  final List<String> sorts;
  final String selectedSort;
  final RangeValues priceRange;
  final void Function(String sort, RangeValues range) onApply;
  final ThemeData theme;

  const _SortSheet({
    required this.sorts,
    required this.selectedSort,
    required this.priceRange,
    required this.onApply,
    required this.theme,
  });

  @override
  State<_SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<_SortSheet> {
  late String _sort = widget.selectedSort;
  late RangeValues _range = widget.priceRange;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Order',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.sorts.map((s) {
                final selected = s == _sort;
                return InkWell(
                  onTap: () => setState(() => _sort = s),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primary
                          : cs.surfaceContainerHighest.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: cs.outlineVariant.withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      s,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: selected ? cs.onPrimary : cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Price Range',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
              ),
            ),
            RangeSlider(
              values: _range,
              min: 0,
              max: 5000,
              divisions: 100,
              labels: RangeLabels(
                '\$${_range.start.toStringAsFixed(0)}',
                '\$${_range.end.toStringAsFixed(0)}',
              ),
              onChanged: (v) => setState(() => _range = v),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => widget.onApply(_sort, _range),
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Specs sheet (component-specific spec range filters) ─────────────────────

class _SpecsSheet extends StatefulWidget {
  final String selectedType;
  final Map<String, RangeValues> specFilters;
  final void Function(Map<String, RangeValues> filters) onApply;
  final ThemeData theme;

  const _SpecsSheet({
    required this.selectedType,
    required this.specFilters,
    required this.onApply,
    required this.theme,
  });

  @override
  State<_SpecsSheet> createState() => _SpecsSheetState();
}

class _SpecsSheetState extends State<_SpecsSheet> {
  late Map<String, RangeValues> _filters = Map.from(widget.specFilters);

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final cs = theme.colorScheme;
    final defs = _typeSpecDefs[widget.selectedType] ?? [];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Specs',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (_filters.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _filters.clear()),
                    child: const Text('Reset'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...defs.map((def) {
              final current =
                  _filters[def.dataKey] ?? RangeValues(def.min, def.max);
              final unitStr = def.unit.isNotEmpty ? ' ${def.unit}' : '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    def.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  RangeSlider(
                    values: current,
                    min: def.min,
                    max: def.max,
                    divisions: def.divisions,
                    labels: RangeLabels(
                      '${current.start.toStringAsFixed(0)}$unitStr',
                      '${current.end.toStringAsFixed(0)}$unitStr',
                    ),
                    onChanged: (v) =>
                        setState(() => _filters[def.dataKey] = v),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => widget.onApply(_filters),
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
