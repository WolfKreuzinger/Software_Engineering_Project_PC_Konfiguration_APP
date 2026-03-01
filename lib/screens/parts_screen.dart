import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  final ValueNotifier<int> _visibleCount = ValueNotifier<int>(0);
  final Map<String, _PartIndex> _partIndexCache = <String, _PartIndex>{};
  int? _pendingVisibleCount;

  String _selectedType = 'All Components';
  String _selectedSort = 'Price: Low to High';
  RangeValues _priceRange = const RangeValues(0, 5000);

  static const _types = <String>[
    'All Components',
    'cpu',
    'motherboard',
    'video-card',
    'memory',
    'internal-hard-drive',
    'power-supply',
    'case',
    'cpu-cooler',
    'case-fan',
    'wired-network-card',
    'wireless-network-card',
    'sound-card',
    'optical-drive',
    'fan-controller',
    'thermal-paste',
    'external-hard-drive',
    'ups',
    'case-accessory',
    'os',
  ];

  static const _sorts = <String>[
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
  ];

  bool _useCollectionGroup = false;

  @override
  void initState() {
    super.initState();
    _detectPartsLocation();
  }

  Future<void> _detectPartsLocation() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('parts')
          .limit(1)
          .get();
      if (!mounted) return;
      setState(() => _useCollectionGroup = snap.docs.isEmpty);
    } catch (_) {
      if (!mounted) return;
      setState(() => _useCollectionGroup = false);
    }
  }

  Query<Map<String, dynamic>> _partsQuery() {
    if (_useCollectionGroup) {
      return FirebaseFirestore.instance.collectionGroup('parts');
    }
    return FirebaseFirestore.instance.collection('parts');
  }

  @override
  void dispose() {
    _pendingVisibleCount = null;
    _visibleCount.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _setVisibleCount(int next, {bool immediate = false}) {
    if (immediate) {
      if (_visibleCount.value != next) _visibleCount.value = next;
      return;
    }
    if (_visibleCount.value == next || _pendingVisibleCount == next) return;
    _pendingVisibleCount = next;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final pending = _pendingVisibleCount;
      _pendingVisibleCount = null;
      if (pending == null || _visibleCount.value == pending) return;
      _visibleCount.value = pending;
    });
  }

  void _applySearch() {
    final next = _searchCtrl.text;
    if (next == _searchQuery) return;
    setState(() {
      _searchQuery = next;
      _setVisibleCount(0, immediate: true);
    });
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
    final meta = data['metadata'];
    if (meta is Map) {
      final ds = meta['datasetType'];
      if (ds != null && ds.toString().trim().isNotEmpty) {
        return _canonicalType(ds.toString());
      }
    }

    final t = data['type'];
    if (t != null && t.toString().trim().isNotEmpty) {
      final raw = t.toString().trim();
      final fromRaw = _canonicalType(raw);
      if (fromRaw.isNotEmpty) return fromRaw;
      return _canonicalType(_camelToKebab(raw));
    }

    return '';
  }

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
      case 'case-fan':
      case 'fan-controller':
        return Icons.toys_rounded;
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
                            ValueListenableBuilder<int>(
                              valueListenable: _visibleCount,
                              builder: (context, visibleCount, _) {
                                return Text(
                                  '$visibleCount Products Found',
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
                                  _setVisibleCount(0, immediate: true);
                                });
                                Navigator.of(context).pop();
                              },
                              theme: theme,
                            ),
                          );
                        },
                        icon: const Icon(Icons.tune_rounded),
                      ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _Pill(
                          label: _selectedType,
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
                                    _setVisibleCount(0, immediate: true);
                                  });
                                  Navigator.of(context).pop();
                                },
                                theme: theme,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _Pill(
                          label:
                              'Price ${_priceRange.start.toStringAsFixed(0)}–${_priceRange.end.toStringAsFixed(0)}',
                          selected: false,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (_) => _PriceSheet(
                                priceRange: _priceRange,
                                onApply: (v) {
                                  setState(() {
                                    _priceRange = v;
                                    _setVisibleCount(0, immediate: true);
                                  });
                                  Navigator.of(context).pop();
                                },
                                theme: theme,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _Pill(
                          label: _selectedSort,
                          selected: false,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              builder: (_) => _SimplePickerSheet(
                                title: 'Sort',
                                items: _sorts,
                                selected: _selectedSort,
                                onPick: (v) {
                                  setState(() {
                                    _selectedSort = v;
                                    _setVisibleCount(0, immediate: true);
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _partsQuery().snapshots(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        _setVisibleCount(0);
                        return _EmptyState(
                          icon: Icons.error_outline_rounded,
                          title: 'Error',
                          subtitle: snap.error.toString(),
                          theme: theme,
                        );
                      }

                      if (!snap.hasData) {
                        _setVisibleCount(0);
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snap.data!.docs;
                      final docIds = docs.map((d) => d.reference.path).toSet();
                      _partIndexCache.removeWhere(
                        (id, _) => !docIds.contains(id),
                      );
                      if (docs.isEmpty) {
                        _setVisibleCount(0);
                        return _EmptyState(
                          icon: Icons.cloud_off_rounded,
                          title: 'No data loaded',
                          subtitle: _useCollectionGroup
                              ? 'collectionGroup("parts") returned 0 docs.'
                              : 'collection("parts") returned 0 docs.',
                          theme: theme,
                        );
                      }

                      final q = _searchQuery;
                      final filtered = docs
                          .map((d) {
                            final data = d.data();
                            final idx = _partIndexFor(d.reference.path, data);
                            return (d.id, data, idx);
                          })
                          .where(
                            (e) => _matchesSelectedTypeIdx(_selectedType, e.$3),
                          )
                          .where((e) => _matchesSearchIdx(q, e.$3))
                          .where((e) => _matchesPrice(_priceRange, e.$3))
                          .toList(growable: true);

                      filtered.sort(
                        (a, b) => _sortCompare(_selectedSort, a.$2, b.$2),
                      );
                      _setVisibleCount(filtered.length);

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
                            actionText: 'View',
                            actionEnabled: true,
                            onTapAction: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: $title'),
                                  duration: const Duration(milliseconds: 900),
                                ),
                              );
                              await FirebaseFirestore.instance
                                  .collection('selected_parts')
                                  .doc('current')
                                  .collection('items')
                                  .doc(id)
                                  .set({
                                    'partId': id,
                                    'name': data['name'],
                                    'type': type,
                                    'price': data['price'],
                                    'addedAt': FieldValue.serverTimestamp(),
                                  }, SetOptions(merge: true));
                            },
                          );
                        },
                      );
                    },
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

class _PartCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String specs;
  final String price;
  final String actionText;
  final bool actionEnabled;
  final VoidCallback onTapAction;

  const _PartCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.specs,
    required this.price,
    required this.actionText,
    required this.actionEnabled,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 74,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: cs.onSurfaceVariant, size: 26),
                  const SizedBox(height: 8),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          price,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: actionEnabled ? onTapAction : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
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
                ],
              ),
            ),
          ],
        ),
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
                          t,
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

  const _SimplePickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onPick,
    required this.theme,
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
              e,
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

class _PriceSheet extends StatefulWidget {
  final RangeValues priceRange;
  final ValueChanged<RangeValues> onApply;
  final ThemeData theme;

  const _PriceSheet({
    required this.priceRange,
    required this.onApply,
    required this.theme,
  });

  @override
  State<_PriceSheet> createState() => _PriceSheetState();
}

class _PriceSheetState extends State<_PriceSheet> {
  late RangeValues _range = widget.priceRange;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Range',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
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
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => widget.onApply(_range),
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
