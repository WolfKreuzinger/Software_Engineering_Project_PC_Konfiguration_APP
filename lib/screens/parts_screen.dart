import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';

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

String _localizedSortName(String sort, AppLocalizations l10n) {
  switch (sort) {
    case 'Price: Low to High':
      return l10n.partsSortPriceLowToHigh;
    case 'Price: High to Low':
      return l10n.partsSortPriceHighToLow;
    case 'Name: A to Z':
      return l10n.partsSortNameAtoZ;
    default:
      return sort;
  }
}

String _localizedTypeName(String value, AppLocalizations l10n) {
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
      return l10n.partsTypeStorage;
    case 'power-supply':
      return l10n.partsTypePowerSupply;
    case 'case':
      return l10n.partsTypeCase;
    case 'cpu-cooler':
      return l10n.partsTypeCpuCooler;
    case 'case-fan':
      return l10n.partsTypeCaseFan;
    case 'wired-network-card':
      return l10n.partsTypeEthernetCard;
    case 'wireless-network-card':
      return l10n.partsTypeWifiCard;
    case 'sound-card':
      return l10n.partsTypeSoundCard;
    case 'optical-drive':
      return l10n.partsTypeOpticalDrive;
    case 'fan-controller':
      return l10n.partsTypeFanController;
    case 'thermal-paste':
      return l10n.partsTypeThermalPaste;
    case 'external-hard-drive':
      return l10n.partsTypeExternalStorage;
    case 'ups':
      return l10n.partsTypeUps;
    case 'case-accessory':
      return l10n.partsTypeCaseAccessory;
    case 'os':
      return 'OS';
    case 'all components':
      return l10n.partsAllComponents;
    default:
      return value;
  }
}

String _localizedSpecLabel(String label, AppLocalizations l10n) {
  switch (label) {
    case 'Brand': return l10n.specLabelBrand;
    case 'Core Count': return l10n.specLabelCoreCount;
    case 'Core Clock': return l10n.specLabelCoreClock;
    case 'Boost Clock': return l10n.specLabelBoostClock;
    case 'Microarchitecture': return l10n.specLabelMicroarchitecture;
    case 'Integrated Graphics': return l10n.specLabelIntegratedGraphics;
    case 'Chipset': return l10n.specLabelChipset;
    case 'Color': return l10n.specLabelColor;
    case 'VRAM': return l10n.specLabelVram;
    case 'Length': return l10n.specLabelLength;
    case 'DDR Generation': return l10n.specLabelDdrGeneration;
    case 'Modules': return l10n.specLabelModules;
    case 'Module Size': return l10n.specLabelModuleSize;
    case 'Speed': return l10n.specLabelSpeed;
    case 'CAS Latency': return l10n.specLabelCasLatency;
    case 'First Word Latency': return l10n.specLabelFirstWordLatency;
    case 'Price / GB': return l10n.specLabelPricePerGb;
    case 'Capacity': return l10n.specLabelCapacity;
    case 'Form Factor': return l10n.specLabelFormFactor;
    case 'Interface': return l10n.specLabelInterface;
    case 'Socket': return l10n.specLabelSocket;
    case 'Max Memory': return l10n.specLabelMaxMemory;
    case 'Memory Slots': return l10n.specLabelMemorySlots;
    case 'Type': return l10n.specLabelType;
    case 'Wattage': return l10n.specLabelWattage;
    case 'Efficiency Certification': return l10n.specLabelEfficiencyCertification;
    case 'Noise Level': return l10n.specLabelNoiseLevel;
    case 'RPM': return l10n.specLabelRpm;
    case 'Side Panel': return l10n.specLabelSidePanel;
    case 'Included PSU': return l10n.specLabelIncludedPsu;
    case 'External Volume': return l10n.specLabelExternalVolume;
    case '3.5" Bays': return l10n.specLabelBays35;
    case 'Size': return l10n.specLabelSize;
    case 'Airflow': return l10n.specLabelAirflow;
    case 'Channels': return l10n.specLabelChannels;
    case 'Channel Wattage': return l10n.specLabelChannelWattage;
    case 'Memory': return l10n.specLabelMemory;
    case 'Efficiency': return l10n.specLabelEfficiency;
    case 'Blu-ray Read': return l10n.specLabelBluRayRead;
    case 'Blu-ray Write': return l10n.specLabelBluRayWrite;
    case 'DVD Read': return l10n.specLabelDvdRead;
    case 'DVD Write': return l10n.specLabelDvdWrite;
    case 'CD Read': return l10n.specLabelCdRead;
    case 'CD Write': return l10n.specLabelCdWrite;
    case 'Mode': return l10n.specLabelMode;
    case 'Capacity (VA)': return l10n.specLabelCapacityVa;
    case 'Capacity (W)': return l10n.specLabelCapacityW;
    case 'Protocol': return l10n.specLabelProtocol;
    case 'Sample Rate': return l10n.specLabelSampleRate;
    case 'SNR': return l10n.specLabelSnr;
    case 'Digital Audio': return l10n.specLabelDigitalAudio;
    case 'Amount': return l10n.specLabelAmount;
    case 'Internal 3.5" Bays': return l10n.specLabelInternal35Bays;
    default: return label;
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

  /// Returns human-readable labels for critical fields that are missing.
  /// Empty list = data is complete.
  List<String> get missingDataFields =>
      _partMissingDataFields(type, rawData, price);
}

/// Returns human-readable labels of missing critical fields for a part.
List<String> _partMissingDataFields(
  String type,
  Map<String, dynamic> rawData,
  double? price,
) {
  final missing = <String>[];
  if (price == null) missing.add('Preis');

  final spec = rawData['spec'];

  // Look up a value by camelCase key in spec map, snake_case in both,
  // or top-level in rawData.
  dynamic v(String camel, String snake) {
    if (spec is Map) {
      final sv = spec[camel] ?? spec[snake];
      if (sv != null) return sv;
    }
    return rawData[snake] ?? rawData[camel];
  }

  bool empty(dynamic val) {
    if (val == null) return true;
    if (val is String) return val.trim().isEmpty || val == 'null';
    if (val is List) return val.isEmpty;
    return false;
  }

  switch (type) {
    case 'cpu':
      if (empty(v('tdp', 'tdp'))) missing.add('TDP');
      if (empty(v('socket', 'socket'))) missing.add('Sockel');
      if (empty(v('coreCount', 'core_count'))) missing.add('Kernanzahl');
    case 'video-card':
      if (empty(v('chipset', 'chipset'))) missing.add('Chipsatz');
      if (empty(v('memory', 'memory'))) missing.add('VRAM');
    case 'memory':
      if (empty(v('speed', 'speed'))) missing.add('Geschwindigkeit');
      if (empty(v('modules', 'modules'))) missing.add('Module');
    case 'internal-hard-drive':
      if (empty(v('capacityGb', 'capacity'))) missing.add('Kapazität');
      if (empty(v('interface', 'interface'))) missing.add('Schnittstelle');
    case 'motherboard':
      if (empty(v('socket', 'socket'))) missing.add('Sockel');
      if (empty(v('formFactor', 'form_factor'))) missing.add('Formfaktor');
      if (empty(v('memorySlots', 'memory_slots'))) missing.add('RAM-Slots');
    case 'power-supply':
      if (empty(v('wattage', 'wattage'))) missing.add('Leistung');
  }
  return missing;
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

  static const int _kBatchSize = 100;

  bool _isLoading = true;
  String? _loadError;
  List<(String, Map<String, dynamic>)> _allParts = [];

  // Pagination state
  int _displayedCount = _kBatchSize;
  final Map<String, DocumentSnapshot?> _lastDocPerCategory = {};
  final Map<String, bool> _hasMorePerCategory = {};
  bool _isLoadingMore = false;
  final Map<String, int> _countPerCategory = {};
  final Map<String, int> _loadedCountPerCategory = {};

  // Cached filtered+sorted list — recomputed only when data or filters change,
  // not on every scroll frame.
  List<(String, Map<String, dynamic>, _PartIndex)> _filteredParts = [];

  final ScrollController _scrollCtrl = ScrollController();

  String _selectedType = 'All Components';
  String _selectedSort = 'Price: Low to High';
  RangeValues _priceRange = const RangeValues(0, 5000);
  Map<String, _ActiveFilter> _specFilters = {};
  _DataCompletenessFilter _dataFilter = _DataCompletenessFilter.showAll;

  static const _types = <String>[
    'All Components',
    'case', // Case
    'case-accessory', // Case Accessory
    'case-fan', // Case Fan
    'cpu', // CPU
    'cpu-cooler', // CPU Cooler
    'wired-network-card', // Ethernet Card
    'external-hard-drive', // External Storage
    'fan-controller', // Fan Controller
    'video-card', // GPU
    'motherboard', // Motherboard
    'optical-drive', // Optical Drive
    'os', // OS
    'power-supply', // Power Supply
    'memory', // RAM
    'sound-card', // Sound Card
    'internal-hard-drive', // Storage
    'thermal-paste', // Thermal Paste
    'ups', // UPS
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

  /// Load the first batch of items from each per-type collection.
  /// Each document gets a synthetic `_category` field so type-detection works
  /// without relying on stored `metadata.datasetType`.
  Future<void> _loadParts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _loadError = null;
      _displayedCount = _kBatchSize;
      _lastDocPerCategory.clear();
      _hasMorePerCategory.clear();
      _countPerCategory.clear();
      _loadedCountPerCategory.clear();
    });

    final db = FirebaseFirestore.instance;
    final parts = <(String, Map<String, dynamic>)>[];

    final categories = _isTypeLocked
        ? [_canonicalType(widget.lockedType!)]
        : _types.where((t) => t != 'All Components').toList();

    final errors = <String>[];

    await Future.wait(
      categories.map((cat) async {
        try {
          final snap = await db.collection(cat).limit(_kBatchSize).get();
          for (final d in snap.docs) {
            final data = Map<String, dynamic>.from(d.data());
            data['_category'] = cat;
            parts.add((d.reference.path, data));
          }
          if (snap.docs.isNotEmpty) {
            _lastDocPerCategory[cat] = snap.docs.last;
          }
          _loadedCountPerCategory[cat] = snap.docs.length;

          // Fetch total count and use it to determine if more docs exist
          try {
            final countSnap = await db.collection(cat).count().get();
            final total = countSnap.count ?? snap.docs.length;
            _countPerCategory[cat] = total;
            _hasMorePerCategory[cat] = snap.docs.length < total;
          } catch (_) {
            _countPerCategory[cat] = snap.docs.length;
            _hasMorePerCategory[cat] = snap.docs.length >= _kBatchSize;
          }
        } catch (e) {
          errors.add('$cat: $e');
          // ignore: avoid_print
          print('[_loadParts] error loading $cat: $e');
        }
      }),
    );

    if (!mounted) return;
    setState(() {
      _allParts = parts;
      _loadError = parts.isEmpty && errors.isNotEmpty ? errors.first : null;
      _isLoading = false;
      _recomputeFiltered();
    });
  }

  /// Fetches the next batch for all categories that still have more docs.
  /// Pure data operation — no setState, no loading-flag management.
  /// Returns the newly loaded parts.
  Future<List<(String, Map<String, dynamic>)>> _fetchNextBatch() async {
    final db = FirebaseFirestore.instance;
    final newParts = <(String, Map<String, dynamic>)>[];
    final cats = _hasMorePerCategory.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    await Future.wait(
      cats.map((cat) async {
        try {
          final lastDoc = _lastDocPerCategory[cat];
          Query<Map<String, dynamic>> query = db
              .collection(cat)
              .limit(_kBatchSize);
          if (lastDoc != null) query = query.startAfterDocument(lastDoc);
          final snap = await query.get();
          for (final d in snap.docs) {
            final data = Map<String, dynamic>.from(d.data());
            data['_category'] = cat;
            newParts.add((d.reference.path, data));
          }
          if (snap.docs.isNotEmpty) _lastDocPerCategory[cat] = snap.docs.last;
          final loaded = (_loadedCountPerCategory[cat] ?? 0) + snap.docs.length;
          _loadedCountPerCategory[cat] = loaded;
          _hasMorePerCategory[cat] =
              loaded < (_countPerCategory[cat] ?? loaded);
        } catch (e) {
          // ignore: avoid_print
          print('[_fetchNextBatch] $cat: $e');
          _hasMorePerCategory[cat] = false; // prevent infinite loop
        }
      }),
    );

    return newParts;
  }

  /// Loads the next single batch (used by the "Load More" button).
  Future<void> _loadMoreFromDb() async {
    if (_isLoadingMore || !mounted) return;
    setState(() => _isLoadingMore = true);
    final newParts = await _fetchNextBatch();
    if (!mounted) return;
    setState(() {
      _allParts = [..._allParts, ...newParts];
      _isLoadingMore = false;
      _recomputeFiltered();
    });
  }

  /// Loads ALL remaining data from Firestore in a single round-trip per
  /// category (no limit), then recomputes. Much faster than looping small
  /// batches because it avoids sequential network round-trips.
  Future<void> _loadAllFromDb() async {
    if (_isLoadingMore || !mounted) return;
    final cats = _hasMorePerCategory.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    if (cats.isEmpty) {
      setState(() => _recomputeFiltered());
      return;
    }
    setState(() {
      _isLoading = true;
      _isLoadingMore = true;
    });

    final db = FirebaseFirestore.instance;
    final allNew = <(String, Map<String, dynamic>)>[];

    // One unlimited request per category – all categories in parallel.
    await Future.wait(
      cats.map((cat) async {
        try {
          final lastDoc = _lastDocPerCategory[cat];
          Query<Map<String, dynamic>> query = db.collection(cat);
          if (lastDoc != null) query = query.startAfterDocument(lastDoc);
          final snap = await query.get();
          for (final d in snap.docs) {
            final data = Map<String, dynamic>.from(d.data());
            data['_category'] = cat;
            allNew.add((d.reference.path, data));
          }
          if (snap.docs.isNotEmpty) _lastDocPerCategory[cat] = snap.docs.last;
          final loaded = (_loadedCountPerCategory[cat] ?? 0) + snap.docs.length;
          _loadedCountPerCategory[cat] = loaded;
          _hasMorePerCategory[cat] = false;
        } catch (e) {
          // ignore: avoid_print
          print('[_loadAllFromDb] $cat: $e');
          _hasMorePerCategory[cat] = false;
        }
      }),
    );

    if (!mounted) return;
    setState(() {
      _allParts = [..._allParts, ...allNew];
      _isLoading = false;
      _isLoadingMore = false;
      _recomputeFiltered();
    });
  }

  /// Called when the user taps "Load More".
  Future<void> _handleLoadMore(int filteredCount) async {
    if (_isLoadingMore) return;
    if (_displayedCount < filteredCount) {
      setState(() => _displayedCount += _kBatchSize);
    } else if (_hasMorePerCategory.values.any((v) => v)) {
      await _loadMoreFromDb();
      if (mounted) setState(() => _displayedCount += _kBatchSize);
    }
  }

  void _scrollToTop() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(0);
    }
  }

  // Recomputes _filteredParts from _allParts + current filters + sort.
  // Must be called inside every setState that changes data or filter state.
  void _recomputeFiltered() {
    final list = _allParts
        .map((p) => (p.$1, p.$2, _partIndexFor(p.$1, p.$2)))
        .where((e) => _matchesSelectedTypeIdx(_selectedType, e.$3))
        .where((e) => _matchesSearchIdx(_searchQuery, e.$3))
        .where((e) => _matchesPrice(_priceRange, e.$3))
        .where((e) => _matchesSpecs(_specFilters, e.$2))
        .where((e) {
          if (_dataFilter == _DataCompletenessFilter.showAll) return true;
          final price = _toDouble(e.$2['price']).isNaN
              ? null
              : _toDouble(e.$2['price']);
          return _partMissingDataFields(e.$3.type, e.$2, price).isEmpty;
        })
        .toList();
    list.sort((a, b) => _sortCompare(_selectedSort, a.$2, b.$2));
    _filteredParts = list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _applySearch() {
    final next = _searchCtrl.text;
    if (next == _searchQuery) return;
    setState(() {
      _searchQuery = next;
      _displayedCount = _kBatchSize;
      _recomputeFiltered();
    });
    _scrollToTop();
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

  static String _displayType(String value) =>
      _typeDisplayName(_canonicalType(value));

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
      final chipset =
          ((spec is Map ? spec['chipset'] : null) ?? data['chipset'] ?? '')
              .toString();
      return chipset.isEmpty ? 'Graphics card' : chipset;
    }

    if (type == 'cpu') {
      final cores = _toInt(
        (spec is Map ? spec['coreCount'] : null) ?? data['core_count'],
      );
      final boost = _toDouble(
        (spec is Map ? spec['boostClock'] : null) ?? data['boost_clock'],
      );
      final pieces = <String>[];
      if (cores > 0) pieces.add('$cores cores');
      if (!boost.isNaN && boost > 0) pieces.add('$boost GHz');
      return pieces.isEmpty ? 'Processor' : pieces.join('\n');
    }

    if (type == 'memory') {
      final modules = (spec is Map ? spec['modules'] : null) ?? data['modules'];
      final speed = (spec is Map ? spec['speed'] : null) ?? data['speed'];
      final pieces = <String>[];
      if (modules is List && modules.length >= 2) {
        final count = _toInt(modules[0]);
        final size = _toInt(modules[1]);
        if (count > 0 && size > 0) pieces.add('${count}x${size}GB');
      }
      if (speed is List && speed.isNotEmpty) {
        final ddr = _toInt(speed[0]);
        if (ddr > 0) pieces.add('DDR$ddr');
      }
      return pieces.isEmpty ? 'Memory' : pieces.join('\n');
    }

    if (type == 'internal-hard-drive') {
      final cap = _toInt(
        (spec is Map ? spec['capacityGb'] : null) ?? data['capacity'],
      );
      final ff =
          ((spec is Map ? spec['formFactor'] : null) ??
                  data['form_factor'] ??
                  '')
              .toString();
      final pieces = <String>[];
      if (cap > 0) pieces.add('${cap}GB');
      if (ff.isNotEmpty) pieces.add(ff);
      return pieces.isEmpty ? 'Storage' : pieces.join('\n');
    }

    if (type == 'motherboard') {
      final socket =
          ((spec is Map ? spec['socket'] : null) ?? data['socket'] ?? '')
              .toString();
      return socket.isEmpty ? 'Motherboard' : socket;
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
      if (eff.isNotEmpty) {
        final effNorm = eff.trim().toLowerCase();
        final effDisplay = switch (effNorm) {
          '80+' => '80+',
          '80+ bronze' || 'bronze' => '80+ Bronze',
          '80+ silver' || 'silver' => '80+ Silver',
          '80+ gold' || 'gold' => '80+ Gold',
          '80+ platinum' || 'platinum' => '80+ Platinum',
          '80+ titanium' || 'titanium' => '80+ Titanium',
          _ => eff.trim(),
        };
        pieces.add(effDisplay);
      }
      return pieces.isEmpty ? 'Power supply' : pieces.join('\n');
    }

    if (type == 'case') {
      final caseType =
          ((spec is Map ? spec['type'] : null) ?? data['type'] ?? '')
              .toString();
      return caseType.isEmpty ? 'Case' : caseType;
    }

    if (type == 'case-accessory') {
      final caseType =
          ((spec is Map ? spec['type'] : null) ?? data['type'] ?? '')
              .toString();
      return caseType.isEmpty ? 'Case Accessory' : caseType;
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
      return pieces.isEmpty ? 'CPU cooler' : pieces.join('\n');
    }

    if (type == 'case-fan') {
      final size = _toInt(
        (spec is Map ? spec['sizeMm'] : null) ?? data['size'],
      );
      final noise =
          (spec is Map ? spec['noiseLevelDb'] : null) ?? data['noise_level'];
      final pieces = <String>[];
      if (size > 0) pieces.add('${size}mm');
      if (noise is num) pieces.add('${noise.toString()} dBA');
      return pieces.isEmpty ? 'Case fan' : pieces.join('\n');
    }

    if (type == 'fan-controller') {
      final channels = _toInt(
        (spec is Map ? spec['channels'] : null) ?? data['channels'],
      );
      return channels > 0 ? '$channels Channels' : 'Fan Controller';
    }

    if (type == 'wired-network-card') {
      final iface =
          ((spec is Map ? spec['interface'] : null) ?? data['interface'] ?? '')
              .toString();
      return iface.isEmpty ? 'Ethernet Card' : iface;
    }

    if (type == 'external-hard-drive') {
      final cap = _toInt(
        (spec is Map ? spec['capacityGb'] : null) ?? data['capacity'],
      );
      return cap > 0 ? '${cap}GB' : 'External Storage';
    }

    if (type == 'optical-drive') {
      final bdWrite =
          (spec is Map ? spec['bd_write'] : null) ?? data['bd_write'];
      final bdRead = (spec is Map ? spec['bd'] : null) ?? data['bd'];
      if (bdWrite != null) return 'Blu-ray Writer';
      if (bdRead != null) return 'Blu-ray Reader';
      return 'CD/DVD Drive';
    }

    if (type == 'sound-card') {
      final channels =
          (spec is Map ? spec['channels'] : null) ?? data['channels'];
      final iface =
          ((spec is Map ? spec['interface'] : null) ?? data['interface'] ?? '')
              .toString();
      final pieces = <String>[];
      if (channels != null) {
        final ch = channels.toString().trim();
        if (ch.isNotEmpty) pieces.add(ch);
      }
      if (iface.isNotEmpty) pieces.add(iface);
      return pieces.isEmpty ? 'Sound Card' : pieces.join('\n');
    }

    if (type == 'ups') {
      final cap = _toInt(
        (spec is Map ? spec['capacityW'] : null) ?? data['capacity_w'],
      );
      return cap > 0 ? '${cap}W' : 'UPS';
    }

    if (type == 'wireless-network-card') {
      final protocol =
          ((spec is Map ? spec['protocol'] : null) ?? data['protocol'] ?? '')
              .toString();
      final iface =
          ((spec is Map ? spec['interface'] : null) ?? data['interface'] ?? '')
              .toString();
      final pieces = <String>[];
      if (protocol.isNotEmpty) pieces.add(protocol);
      if (iface.isNotEmpty) pieces.add(iface);
      return pieces.isEmpty ? 'Wi-Fi Card' : pieces.join('\n');
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
    Map<String, _ActiveFilter> specFilters,
    Map<String, dynamic> data,
  ) {
    if (specFilters.isEmpty) return true;
    final defs = _typeSpecDefs[_selectedType] ?? [];
    for (final def in defs) {
      final filter = specFilters[def.specKey];
      if (filter == null) continue;

      // Resolve raw value from spec sub-map or top-level data
      final spec = data['spec'];
      dynamic rawVal;
      if (spec is Map) {
        rawVal = spec[def.specKey] ?? spec[def.dataKey] ?? data[def.dataKey];
      } else {
        rawVal = data[def.dataKey];
      }

      // Extract element by index when the field is a List (e.g. speed[0])
      if (def.listIndex != null) {
        rawVal = (rawVal is List && def.listIndex! < rawVal.length)
            ? rawVal[def.listIndex!]
            : null;
      }

      // ── Special filter modes ──────────────────────────────────────────────
      if (def.filterMode == _FilterMode.driveType) {
        final filterText = filter.textValue?.trim() ?? '';
        if (filterText.isEmpty) continue;
        final sp = data['spec'];
        dynamic f(String k) => (sp is Map ? sp[k] : null) ?? data[k];
        final bdRead = f('bd');
        final bdWrite = f('bd_write');
        final pass = switch (filterText) {
          'CD/DVD Drive' => bdRead == null && bdWrite == null,
          'Blu-ray Reader' => bdRead != null && bdWrite == null,
          'Blu-ray Writer' => bdWrite != null,
          _ => true,
        };
        if (!pass) return false;
        continue;
      }

      if (def.filterMode == _FilterMode.nonNull) {
        if ((filter.textValue?.trim() ?? '').isEmpty) continue;
        if (rawVal == null) return false;
        continue;
      }

      if (def.filterMode == _FilterMode.boolTrue) {
        if ((filter.textValue?.trim() ?? '').isEmpty) continue;
        if (rawVal != true) return false;
        continue;
      }

      // ── Normal matching ───────────────────────────────────────────────────
      if (filter.isRange) {
        final filterRange = filter.rangeValues!;
        if (filterRange.start == def.min && filterRange.end == def.max) {
          continue;
        }
        // List field without explicit listIndex (e.g. cpu-cooler rpm = [min, max])
        if (rawVal is List) {
          final vals = rawVal.map(_toDouble).where((v) => !v.isNaN).toList();
          if (vals.isNotEmpty) {
            final listMin = vals.reduce((a, b) => a < b ? a : b);
            final listMax = vals.reduce((a, b) => a > b ? a : b);
            if (listMax < filterRange.start || listMin > filterRange.end) {
              return false;
            }
          }
          continue;
        }
        final numVal = _toDouble(rawVal);
        // NaN means the field is null (N/A) → exclude when filtered
        if (numVal.isNaN ||
            numVal < filterRange.start ||
            numVal > filterRange.end) {
          return false;
        }
      } else {
        // Text filter
        final filterText = filter.textValue!.trim().toLowerCase();
        if (filterText.isEmpty) continue;
        final rawStr = rawVal?.toString().trim().toLowerCase() ?? '';
        if (rawStr.isEmpty) return false; // N/A value → exclude when filtered
        if (def.containsMatch) {
          if (!rawStr.contains(filterText)) return false;
        } else {
          if (rawStr != filterText) return false;
        }
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
                              context.l10n.partsTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Builder(
                              builder: (context) {
                                if (_isLoading) {
                                  return Text(
                                    context.l10n.partsNoProductsFound,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                                final hasActiveFilters =
                                    _searchQuery.trim().isNotEmpty ||
                                    _specFilters.isNotEmpty ||
                                    _priceRange.start > 0 ||
                                    _priceRange.end < 5000;
                                final int count;
                                if (hasActiveFilters) {
                                  // Use the pre-computed cache — free during build
                                  count = _filteredParts.length;
                                } else if (_selectedType == 'All Components') {
                                  count = _countPerCategory.values.fold(
                                    0,
                                    (a, b) => a + b,
                                  );
                                } else {
                                  count =
                                      _countPerCategory[_canonicalType(
                                        _selectedType,
                                      )] ??
                                      0;
                                }
                                return Text(
                                  context.l10n.partsProductsFound(count),
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
                                  final sortChanged = sort != _selectedSort;
                                  setState(() {
                                    _selectedType = t;
                                    _selectedSort = sort;
                                    _priceRange = range;
                                    _displayedCount = _kBatchSize;
                                    if (!sortChanged) _recomputeFiltered();
                                  });
                                  _scrollToTop();
                                  Navigator.of(context).pop();
                                  if (sortChanged) _loadAllFromDb();
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
                    hint: context.l10n.partsSearchHint,
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
                              label: _localizedTypeName(_selectedType, context.l10n),
                              selected: true,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (_) => _SimplePickerSheet(
                                    title: context.l10n.partsComponentType,
                                    items: _types,
                                    selected: _selectedType,
                                    onPick: (v) {
                                      setState(() {
                                        _selectedType = v;
                                        _specFilters = {};
                                        _displayedCount = _kBatchSize;
                                        _recomputeFiltered();
                                      });
                                      _scrollToTop();
                                      Navigator.of(context).pop();
                                    },
                                    theme: theme,
                                    labelFor: (t) => _localizedTypeName(t, context.l10n),
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
                                  ? context.l10n.partsSpecs
                                  : '${context.l10n.partsSpecs} (${_specFilters.length})',
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
                                      setState(() {
                                        _specFilters = filters;
                                        _displayedCount = _kBatchSize;
                                        _recomputeFiltered();
                                      });
                                      _scrollToTop();
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
                            label: context.l10n.partsSort,
                            selected:
                                _selectedSort != _sorts[0] ||
                                _priceRange.start > 0 ||
                                _priceRange.end < 5000 ||
                                _dataFilter != _DataCompletenessFilter.showAll,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (_) => _SortSheet(
                                  sorts: _sorts,
                                  selectedSort: _selectedSort,
                                  priceRange: _priceRange,
                                  dataFilter: _dataFilter,
                                  onApply: (sort, range, dataFilter) {
                                    final sortChanged = sort != _selectedSort;
                                    setState(() {
                                      _selectedSort = sort;
                                      _priceRange = range;
                                      _dataFilter = dataFilter;
                                      _displayedCount = _kBatchSize;
                                      if (!sortChanged) _recomputeFiltered();
                                    });
                                    _scrollToTop();
                                    Navigator.of(context).pop();
                                    if (sortChanged) _loadAllFromDb();
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
        title: context.l10n.partsNoData,
        subtitle: context.l10n.partsNoDataSubtitle,
        theme: theme,
      );
    }

    final filtered = _filteredParts;
    final hasMoreInDb = _hasMorePerCategory.values.any((v) => v);

    // Auto-fetch more batches when the visible result count is below a full
    // batch and the DB still has documents. This ensures that e.g. a "16+ cores"
    // filter immediately fills the screen instead of stopping at whatever few
    // items happened to be in the first loaded batch.
    final hasActiveFilters =
        _searchQuery.trim().isNotEmpty ||
        _specFilters.isNotEmpty ||
        _priceRange.start > 0 ||
        _priceRange.end < 5000 ||
        _dataFilter != _DataCompletenessFilter.showAll;
    if (hasMoreInDb && hasActiveFilters && filtered.length < _kBatchSize) {
      if (!_isLoadingMore) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _loadMoreFromDb();
        });
      }
      // Show whatever partial results we already have while fetching more.
      if (filtered.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
    }

    if (filtered.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off_rounded,
        title: context.l10n.partsNoResults,
        subtitle: context.l10n.partsNoResultsSubtitle,
        theme: theme,
      );
    }

    final totalFiltered = filtered.length;
    final displayList = filtered.take(_displayedCount).toList();
    // While auto-fetching to fill up to a full batch, suppress the Load More
    // footer so the button/spinner doesn't flicker at the bottom of the list.
    final isAutoFetching =
        hasActiveFilters && hasMoreInDb && totalFiltered < _kBatchSize;
    // Show "Load More" if there are more pages in memory OR if the DB has more
    // documents that haven't been loaded yet (they might match the current filter).
    final showLoadMore =
        !isAutoFetching &&
        ((_displayedCount < totalFiltered && totalFiltered >= _kBatchSize) ||
            hasMoreInDb);

    return ListView.separated(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
      itemCount: displayList.length + (showLoadMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i == displayList.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Center(
              child: _isLoadingMore
                  ? const CircularProgressIndicator()
                  : FilledButton(
                      onPressed: () => _handleLoadMore(totalFiltered),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(context.l10n.partsLoadMore),
                    ),
            ),
          );
        }

        final id = displayList[i].$1;
        final data = displayList[i].$2;
        final idx = displayList[i].$3;
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
          actionText: widget.returnSelection ? context.l10n.partsAddToConfig : context.l10n.commonView,
          secondaryActionText: widget.returnSelection ? context.l10n.commonView : null,
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
                          context.l10n.partsNoSpecs,
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
                                  _localizedSpecLabel(specs[i].$1, context.l10n),
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
    final type = _datasetTypeFrom(data);
    final spec = data['spec'];

    dynamic getVal(String snakeKey, [String? camelKey]) {
      if (spec is Map) {
        final sv = camelKey != null
            ? (spec[camelKey] ?? spec[snakeKey])
            : spec[snakeKey];
        if (sv != null) return sv;
      }
      return data[snakeKey];
    }

    String fmtVal(dynamic v) {
      if (v == null) return 'N/A';
      if (v is bool) return v ? 'Yes' : 'No';
      if (v is List) {
        final parts = v
            .where((e) => e != null)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty && e != 'null')
            .toList();
        return parts.isEmpty ? 'N/A' : parts.join(' / ');
      }
      final s = v.toString().trim();
      return (s.isEmpty || s == 'null') ? 'N/A' : s;
    }

    (String, String) row(String label, String snakeKey, [String? camelKey]) =>
        (label, fmtVal(getVal(snakeKey, camelKey)));

    switch (type) {
      case 'case':
        return [
          row('Type', 'type'),
          row('Color', 'color'),
          row('Side Panel', 'side_panel'),
          row('Included PSU', 'psu'),
          row('External Volume', 'external_volume'),
          row('Internal 3.5" Bays', 'internal_35_bays'),
        ];
      case 'case-accessory':
        return [
          row('Brand', 'brand'),
          row('Type', 'type'),
          row('Form Factor', 'form_factor', 'formFactor'),
        ];
      case 'case-fan':
        return [
          row('Size', 'size'),
          row('RPM', 'rpm'),
          row('Airflow', 'airflow'),
          row('Noise Level', 'noise_level', 'noiseLevelDb'),
          row('PWM', 'pwm'),
          row('Color', 'color'),
        ];
      case 'cpu':
        return [
          row('Brand', 'brand'),
          row('Core Count', 'core_count', 'coreCount'),
          row('Core Clock', 'core_clock', 'coreClock'),
          row('Boost Clock', 'boost_clock', 'boostClock'),
          row('TDP', 'tdp'),
          row('Microarchitecture', 'microarchitecture'),
          row('Integrated Graphics', 'graphics'),
        ];
      case 'cpu-cooler':
        return [
          row('Color', 'color'),
          row('RPM', 'rpm'),
          row('Noise Level', 'noise_level', 'noiseLevelDb'),
          row('Size', 'size'),
        ];
      case 'external-hard-drive':
        return [
          row('Type', 'type'),
          row('Capacity', 'capacity', 'capacityGb'),
          row('Interface', 'interface'),
          row('Color', 'color'),
          row('Price / GB', 'price_per_gb', 'pricePerGb'),
        ];
      case 'fan-controller':
        return [
          row('Color', 'color'),
          row('Channels', 'channels'),
          row('Channel Wattage', 'channel_wattage', 'channelWattage'),
          row('Form Factor', 'form_factor', 'formFactor'),
          row('PWM', 'pwm'),
        ];
      case 'video-card':
        return [
          row('Chipset', 'chipset'),
          row('Color', 'color'),
          row('Core Clock', 'core_clock', 'coreClock'),
          row('Boost Clock', 'boost_clock', 'boostClock'),
          row('Memory', 'memory'),
          row('Length', 'length'),
        ];
      case 'motherboard':
        return [
          row('Brand', 'brand'),
          row('Socket', 'socket'),
          row('Form Factor', 'form_factor', 'formFactor'),
          row('Color', 'color'),
          row('Max Memory', 'max_memory', 'maxMemory'),
          row('Memory Slots', 'memory_slots', 'memorySlots'),
        ];
      case 'optical-drive':
        return [
          row('Blu-ray Read', 'bd'),
          row('Blu-ray Write', 'bd_write', 'bdWrite'),
          row('DVD Read', 'dvd'),
          row('DVD Write', 'dvd_write', 'dvdWrite'),
          row('CD Read', 'cd'),
          row('CD Write', 'cd_write', 'cdWrite'),
        ];
      case 'os':
        return [
          row('Mode', 'mode'),
          row('Max Memory', 'max_memory', 'maxMemory'),
        ];
      case 'power-supply':
        return [
          row('Type', 'type'),
          row('Color', 'color'),
          row('Wattage', 'wattage'),
          row('Efficiency', 'efficiency'),
          row('Modular', 'modular'),
        ];
      case 'memory':
        return [
          row('Speed', 'speed'),
          row('Modules', 'modules'),
          row('CAS Latency', 'cas_latency', 'casLatency'),
          row('First Word Latency', 'first_word_latency', 'firstWordLatency'),
          row('Color', 'color'),
          row('Price / GB', 'price_per_gb', 'pricePerGb'),
        ];
      case 'sound-card':
        return [
          row('Brand', 'brand'),
          row('Chipset', 'chipset'),
          row('Channels', 'channels'),
          row('Sample Rate', 'sample_rate', 'sampleRate'),
          row('SNR', 'snr'),
          row('Digital Audio', 'digital_audio', 'digitalAudio'),
          row('Interface', 'interface'),
        ];
      case 'thermal-paste':
        return [
          row('Amount', 'amount'),
        ];
      case 'ups':
        return [
          row('Capacity (VA)', 'capacity_va', 'capacityVa'),
          row('Capacity (W)', 'capacity_w', 'capacityW'),
        ];
      case 'internal-hard-drive':
        return [
          row('Type', 'type'),
          row('Capacity', 'capacity', 'capacityGb'),
          row('Form Factor', 'form_factor', 'formFactor'),
          row('Interface', 'interface'),
          row('Cache', 'cache'),
          row('Price / GB', 'price_per_gb', 'pricePerGb'),
        ];
      case 'wired-network-card':
        return [
          row('Interface', 'interface'),
          row('Color', 'color'),
        ];
      case 'wireless-network-card':
        return [
          row('Protocol', 'protocol'),
          row('Interface', 'interface'),
          row('Color', 'color'),
        ];
      default:
        // Fallback for unknown types: show all non-null fields
        final rows = <(String, String)>[];
        final brand = data['brand']?.toString().trim() ?? '';
        if (brand.isNotEmpty && brand != 'null') {
          rows.add(('Brand', brand));
        }
        for (final e in data.entries) {
          final key = e.key;
          if (_skipFields.contains(key) || key == 'brand') continue;
          if (e.value is Map) continue;
          final formatted = _formatValue(e.value);
          if (formatted.isEmpty || formatted == 'null') continue;
          rows.add((_prettyKey(key), formatted));
        }
        return rows;
    }
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

/// Controls which parts are filtered out based on data completeness.
enum _DataCompletenessFilter {
  showAll, // Alle anzeigen – no filter
  compatOnly, // Hide parts missing compat-critical fields
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
                  context.l10n.myBuildsFilters,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  context.l10n.partsComponentType,
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
                          _localizedTypeName(t, context.l10n),
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
                  context.l10n.partsPriceRange,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                _SliderWithLabels(
                  initial: _range,
                  min: 0,
                  max: 5000,
                  divisions: 100,
                  prefix: '\$',
                  theme: theme,
                  cs: cs,
                  onChanged: (v) => setState(() => _range = v),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.partsSort,
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
                          _localizedSortName(s, context.l10n),
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
                    child: Text(context.l10n.commonApply),
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

// A filter value is either a numeric range or a text/string value.
class _ActiveFilter {
  final RangeValues? rangeValues;
  final String? textValue;

  const _ActiveFilter.range(this.rangeValues) : textValue = null;
  const _ActiveFilter.text(this.textValue) : rangeValues = null;

  bool get isRange => rangeValues != null;
}

enum _SpecWidgetType {
  rangeSlider, // Continuous range – RangeSlider
  minMaxInput, // Two text fields for min / max (numeric, free entry)
  minChips, // Discrete minimum value – chips with "≥ X" semantics
  exactChips, // Discrete exact value – chips (numeric)
  textChips, // Exact string value – chips
  textDropdown, // Exact string value – dropdown (many options)
}

enum _FilterMode {
  normal, // Standard matching against dataKey field
  driveType, // Multi-field: CD/DVD / Blu-ray Reader / Blu-ray Writer
  nonNull, // Passes only when dataKey field is non-null (e.g. "Writable")
  boolTrue, // Passes only when the field value is boolean true
}

class _SpecDef {
  final String specKey; // camelCase key; also used as filter-map key
  final String dataKey; // snake_case key in the raw data / Firestore doc
  final String label;
  final double min;
  final double max;
  final String unit;
  final int divisions;
  final _SpecWidgetType widgetType;
  // Numeric chip options (for minChips / exactChips)
  final List<double> chips;
  // Optional prefix to prepend to chip labels (e.g. "DDR" → "DDR4")
  final String chipLabelPrefix;
  // Per-chip label overrides (same length as chips); overrides auto-generated labels
  final List<String> chipLabelOverrides;
  // String options for textChips / textDropdown
  final List<String> textOptions;
  // When true, text matching uses contains() instead of exact equality
  final bool containsMatch;
  // Index to extract when the raw data field is a List (e.g. speed[0] = DDR gen)
  final int? listIndex;
  // Overrides default matching logic in _matchesSpecs
  final _FilterMode filterMode;
  // When true, items with a null/empty value are excluded (not skipped) when
  // this filter is active – used for Color so N/A products are hidden.
  final bool excludeNull;

  const _SpecDef({
    required this.specKey,
    required this.dataKey,
    required this.label,
    this.min = 0,
    this.max = 100,
    this.unit = '',
    this.divisions = 50,
    this.widgetType = _SpecWidgetType.rangeSlider,
    this.chips = const [],
    this.chipLabelPrefix = '',
    this.chipLabelOverrides = const [],
    this.textOptions = const [],
    this.containsMatch = false,
    this.listIndex,
    this.filterMode = _FilterMode.normal,
    this.excludeNull = false,
  });
}

const Map<String, List<_SpecDef>> _typeSpecDefs = {
  // ── CPU ──────────────────────────────────────────────────────────────────
  'cpu': [
    _SpecDef(
      specKey: 'brand',
      dataKey: 'brand',
      label: 'Brand',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: ['AMD', 'Intel'],
    ),
    _SpecDef(
      specKey: 'coreCount',
      dataKey: 'core_count',
      label: 'Core Count',
      min: 1,
      max: 64,
      widgetType: _SpecWidgetType.minChips,
      chips: [4, 6, 8, 12, 16, 32],
    ),
    _SpecDef(
      specKey: 'coreClock',
      dataKey: 'core_clock',
      label: 'Core Clock',
      min: 1.0,
      max: 5.5,
      unit: 'GHz',
      divisions: 45,
    ),
    _SpecDef(
      specKey: 'boostClock',
      dataKey: 'boost_clock',
      label: 'Boost Clock',
      min: 1.5,
      max: 6.5,
      unit: 'GHz',
      divisions: 50,
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
    _SpecDef(
      specKey: 'microarchitecture',
      dataKey: 'microarchitecture',
      label: 'Microarchitecture',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: [
        'Zen 5', 'Zen 4', 'Zen 4c', 'Zen 3', 'Zen 2', 'Zen+', 'Zen',
        'Arrow Lake', 'Meteor Lake', 'Raptor Lake', 'Alder Lake',
        'Rocket Lake', 'Comet Lake', 'Ice Lake', 'Kaby Lake', 'Coffee Lake',
        'Tiger Lake', 'Skylake',
      ],
    ),
    _SpecDef(
      specKey: 'graphics',
      dataKey: 'graphics',
      label: 'Integrated Graphics',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      textOptions: ['Radeon', 'Intel UHD', 'Intel Iris Xe', 'Intel HD'],
    ),
  ],

  // ── GPU ──────────────────────────────────────────────────────────────────
  'video-card': [
    _SpecDef(
      specKey: 'chipset',
      dataKey: 'chipset',
      label: 'Chipset',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      textOptions: [
        // NVIDIA RTX 50
        'RTX 5090', 'RTX 5080', 'RTX 5070 Ti', 'RTX 5070', 'RTX 5060 Ti', 'RTX 5060',
        // NVIDIA RTX 40
        'RTX 4090', 'RTX 4080 Super', 'RTX 4080', 'RTX 4070 Ti Super',
        'RTX 4070 Ti', 'RTX 4070 Super', 'RTX 4070', 'RTX 4060 Ti', 'RTX 4060',
        // NVIDIA RTX 30
        'RTX 3090 Ti', 'RTX 3090', 'RTX 3080 Ti', 'RTX 3080', 'RTX 3070 Ti',
        'RTX 3070', 'RTX 3060 Ti', 'RTX 3060',
        // NVIDIA RTX 20
        'RTX 2080 Ti', 'RTX 2080 Super', 'RTX 2080', 'RTX 2070 Super',
        'RTX 2070', 'RTX 2060 Super', 'RTX 2060',
        // NVIDIA GTX 16 / 10
        'GTX 1660 Ti', 'GTX 1660 Super', 'GTX 1660', 'GTX 1650 Super', 'GTX 1650',
        'GTX 1080 Ti', 'GTX 1080', 'GTX 1070 Ti', 'GTX 1070', 'GTX 1060',
        // AMD RX 9
        'RX 9070 XT', 'RX 9070',
        // AMD RX 7
        'RX 7900 XTX', 'RX 7900 XT', 'RX 7900 GRE', 'RX 7800 XT',
        'RX 7700 XT', 'RX 7600 XT', 'RX 7600',
        // AMD RX 6
        'RX 6950 XT', 'RX 6900 XT', 'RX 6800 XT', 'RX 6800', 'RX 6700 XT',
        'RX 6700', 'RX 6650 XT', 'RX 6600 XT', 'RX 6600', 'RX 6500 XT', 'RX 6400',
        // AMD RX 5
        'RX 5700 XT', 'RX 5700', 'RX 5600 XT', 'RX 5500 XT',
        // Intel Arc
        'Arc A770', 'Arc A750', 'Arc A580', 'Arc A380',
      ],
    ),
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray', 'RGB'],
    ),
    _SpecDef(
      specKey: 'memory',
      dataKey: 'memory',
      label: 'VRAM',
      min: 2,
      max: 24,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [4, 6, 8, 10, 12, 16, 20, 24],
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
      widgetType: _SpecWidgetType.minMaxInput,
    ),
  ],

  // ── RAM ──────────────────────────────────────────────────────────────────
  // speed field is [ddrGen, mhz], modules field is [count, sizeGb]
  'memory': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray', 'RGB'],
    ),
    _SpecDef(
      specKey: 'speedGen',
      dataKey: 'speed',
      label: 'DDR Generation',
      min: 3,
      max: 5,
      widgetType: _SpecWidgetType.exactChips,
      chips: [3, 4, 5],
      chipLabelPrefix: 'DDR',
      listIndex: 0,
    ),
    _SpecDef(
      specKey: 'moduleCount',
      dataKey: 'modules',
      label: 'Modules',
      min: 1,
      max: 8,
      unit: 'x',
      widgetType: _SpecWidgetType.exactChips,
      chips: [1, 2, 4, 8],
      listIndex: 0,
    ),
    _SpecDef(
      specKey: 'moduleGb',
      dataKey: 'modules',
      label: 'Module Size',
      min: 4,
      max: 128,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [4, 8, 16, 32, 64],
      listIndex: 1,
    ),
    _SpecDef(
      specKey: 'speedMhz',
      dataKey: 'speed',
      label: 'Speed',
      min: 800,
      max: 8000,
      unit: 'MHz',
      divisions: 72,
      listIndex: 1,
    ),
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
    _SpecDef(
      specKey: 'pricePerGb',
      dataKey: 'price_per_gb',
      label: 'Price / GB',
      min: 0.01,
      max: 10.0,
      unit: '\$/GB',
      divisions: 99,
    ),
  ],

  // ── Storage ───────────────────────────────────────────────────────────────
  'internal-hard-drive': [
    _SpecDef(
      specKey: 'capacityGb',
      dataKey: 'capacity',
      label: 'Capacity',
      min: 100,
      max: 20000,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [128, 256, 512, 1000, 2000, 4000],
      chipLabelOverrides: [
        '128 GB+',
        '256 GB+',
        '512 GB+',
        '1 TB+',
        '2 TB+',
        '4 TB+',
      ],
    ),
    _SpecDef(
      specKey: 'cache',
      dataKey: 'cache',
      label: 'Cache',
      min: 0,
      max: 2000,
      unit: 'MB',
      widgetType: _SpecWidgetType.minChips,
      chips: [0, 256, 512, 1000, 2000],
      chipLabelOverrides: ['0 MB', '256 MB+', '512 MB+', '1 GB+', '2 GB+'],
    ),
    _SpecDef(
      specKey: 'formFactor',
      dataKey: 'form_factor',
      label: 'Form Factor',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['2.5"', '3.5"', 'M.2-2280', 'M.2-2242', 'M.2-22110'],
    ),
    _SpecDef(
      specKey: 'interface',
      dataKey: 'interface',
      label: 'Interface',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: ['SATA', 'PCIe 3.0', 'PCIe 4.0', 'PCIe 5.0', 'NVMe'],
    ),
    _SpecDef(
      specKey: 'pricePerGb',
      dataKey: 'price_per_gb',
      label: 'Price / GB',
      min: 0.01,
      max: 2.0,
      unit: '\$/GB',
      divisions: 79,
    ),
  ],

  // ── Motherboard ───────────────────────────────────────────────────────────
  'motherboard': [
    _SpecDef(
      specKey: 'brand',
      dataKey: 'brand',
      label: 'Brand',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: [
        'ASRock', 'ASUS', 'MSI', 'Gigabyte', 'Biostar', 'EVGA', 'Supermicro',
      ],
    ),
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray', 'RGB'],
    ),
    _SpecDef(
      specKey: 'socket',
      dataKey: 'socket',
      label: 'Socket',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: [
        'AM4', 'AM5', 'LGA1700', 'LGA1200', 'LGA1151', 'LGA1155',
        'TR4', 'sTRX4', 'LGA2066',
      ],
    ),
    _SpecDef(
      specKey: 'formFactor',
      dataKey: 'form_factor',
      label: 'Form Factor',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['ATX', 'Micro ATX', 'Mini ITX', 'EATX', 'Mini DTX'],
    ),
    _SpecDef(
      specKey: 'maxMemory',
      dataKey: 'max_memory',
      label: 'Max Memory',
      min: 8,
      max: 256,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [16, 32, 64, 128, 256],
    ),
    _SpecDef(
      specKey: 'memorySlots',
      dataKey: 'memory_slots',
      label: 'Memory Slots',
      min: 2,
      max: 8,
      widgetType: _SpecWidgetType.exactChips,
      chips: [2, 4, 8],
    ),
  ],

  // ── Power Supply ──────────────────────────────────────────────────────────
  'power-supply': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'type',
      dataKey: 'type',
      label: 'Type',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['ATX', 'SFX', 'SFX-L', 'TFX', 'Flex ATX'],
    ),
    _SpecDef(
      specKey: 'wattage',
      dataKey: 'wattage',
      label: 'Wattage',
      min: 150,
      max: 1600,
      unit: 'W',
      widgetType: _SpecWidgetType.minChips,
      chips: [200, 300, 400, 450, 550, 650, 750, 850, 1000, 1200],
    ),
    _SpecDef(
      specKey: 'efficiency',
      dataKey: 'efficiency',
      label: 'Efficiency Certification',
      widgetType: _SpecWidgetType.textChips,
      textOptions: [
        '80+', '80+ Bronze', '80+ Silver', '80+ Gold',
        '80+ Platinum', '80+ Titanium',
      ],
    ),
    _SpecDef(
      specKey: 'modular',
      dataKey: 'modular',
      label: 'Modular',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['Full', 'Semi', 'No'],
    ),
  ],

  // ── Case ──────────────────────────────────────────────────────────────────
  'case': [
    _SpecDef(
      specKey: 'brand',
      dataKey: 'brand',
      label: 'Brand',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: [
        'Corsair', 'NZXT', 'Fractal Design', 'Lian Li', 'be quiet!',
        'Thermaltake', 'Cooler Master', 'Phanteks', 'Silverstone', 'BitFenix',
      ],
    ),
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'type',
      dataKey: 'type',
      label: 'Type',
      widgetType: _SpecWidgetType.textChips,
      textOptions: [
        'Mini ITX Tower', 'MicroATX Mid Tower', 'ATX Mid Tower',
        'ATX Full Tower', 'Mini Tower', 'Desktop', 'HTPC',
      ],
    ),
    _SpecDef(
      specKey: 'internal35Bays',
      dataKey: 'internal_35_bays',
      label: '3.5" Bays',
      min: 0,
      max: 10,
      widgetType: _SpecWidgetType.minChips,
      chips: [1, 2, 4, 6],
    ),
    _SpecDef(
      specKey: 'sidePanel',
      dataKey: 'side_panel',
      label: 'Side Panel',
      widgetType: _SpecWidgetType.textChips,
      textOptions: [
        'Tempered Glass', 'Tinted Tempered Glass', 'Acrylic', 'Mesh',
        'Solid Steel',
      ],
    ),
    _SpecDef(
      specKey: 'psu',
      dataKey: 'psu',
      label: 'Included PSU',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.nonNull,
      textOptions: ['Included'],
    ),
    _SpecDef(
      specKey: 'externalVolume',
      dataKey: 'external_volume',
      label: 'External Volume',
      min: 0,
      max: 100,
      unit: 'L',
      divisions: 50,
    ),
  ],

  // ── CPU Cooler ────────────────────────────────────────────────────────────
  'cpu-cooler': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray', 'RGB'],
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
    // rpm can be a single value or [min, max]; _matchesSpecs handles both
    _SpecDef(
      specKey: 'rpm',
      dataKey: 'rpm',
      label: 'RPM',
      min: 0,
      max: 5000,
      unit: 'RPM',
      divisions: 50,
    ),
    _SpecDef(
      specKey: 'sizeMm',
      dataKey: 'size',
      label: 'Size',
      min: 40,
      max: 420,
      unit: 'mm',
      widgetType: _SpecWidgetType.exactChips,
      chips: [92, 120, 140, 240, 280, 360],
    ),
  ],

  // ── Case Fan ──────────────────────────────────────────────────────────────
  'case-fan': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray', 'RGB'],
    ),
    _SpecDef(
      specKey: 'sizeMm',
      dataKey: 'size',
      label: 'Size',
      min: 80,
      max: 200,
      unit: 'mm',
      widgetType: _SpecWidgetType.exactChips,
      chips: [80, 92, 120, 140, 200],
    ),
    _SpecDef(
      specKey: 'rpm',
      dataKey: 'rpm',
      label: 'RPM',
      min: 200,
      max: 3000,
      unit: 'RPM',
      divisions: 56,
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
    _SpecDef(
      specKey: 'pwm',
      dataKey: 'pwm',
      label: 'PWM',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.boolTrue,
      textOptions: ['PWM Support'],
    ),
  ],

  // ── External Hard Drive ───────────────────────────────────────────────────
  'external-hard-drive': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'type',
      dataKey: 'type',
      label: 'Type',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: ['Portable', 'Desktop'],
    ),
    _SpecDef(
      specKey: 'capacityGb',
      dataKey: 'capacity',
      label: 'Capacity',
      min: 100,
      max: 20000,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [128, 256, 512, 1000, 2000, 4000],
      chipLabelOverrides: [
        '128 GB+', '256 GB+', '512 GB+', '1 TB+', '2 TB+', '4 TB+',
      ],
    ),
    _SpecDef(
      specKey: 'interface',
      dataKey: 'interface',
      label: 'Interface',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: [
        'USB 3.0', 'USB 3.1', 'USB 3.2', 'USB-C', 'Thunderbolt 3',
        'Thunderbolt 4',
      ],
    ),
    _SpecDef(
      specKey: 'pricePerGb',
      dataKey: 'price_per_gb',
      label: 'Price / GB',
      min: 0.01,
      max: 0.5,
      unit: '\$/GB',
      divisions: 49,
    ),
  ],

  // ── Sound Card ────────────────────────────────────────────────────────────
  'sound-card': [
    _SpecDef(
      specKey: 'brand',
      dataKey: 'brand',
      label: 'Brand',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: ['ASUS', 'Creative', 'Sound Blaster', 'M-Audio', 'EVGA'],
    ),
    _SpecDef(
      specKey: 'chipset',
      dataKey: 'chipset',
      label: 'Chipset',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      textOptions: ['AV100', 'AV200', 'CA0132', 'CA0108', 'AK4396'],
    ),
    _SpecDef(
      specKey: 'channels',
      dataKey: 'channels',
      label: 'Channels',
      widgetType: _SpecWidgetType.exactChips,
      chips: [2, 5.1, 7.1],
      chipLabelOverrides: ['2.0', '5.1', '7.1'],
    ),
    _SpecDef(
      specKey: 'snr',
      dataKey: 'snr',
      label: 'SNR',
      min: 90,
      max: 130,
      unit: 'dB',
      divisions: 40,
    ),
    _SpecDef(
      specKey: 'sampleRate',
      dataKey: 'sample_rate',
      label: 'Sample Rate',
      min: 44,
      max: 384,
      unit: 'kHz',
      divisions: 17,
    ),
    _SpecDef(
      specKey: 'interface',
      dataKey: 'interface',
      label: 'Interface',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: ['PCIe', 'USB', 'Thunderbolt'],
    ),
    _SpecDef(
      specKey: 'digitalAudio',
      dataKey: 'digital_audio',
      label: 'Digital Audio',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['Optical', 'Coaxial', 'HDMI'],
    ),
  ],

  // ── Wired Network Card ────────────────────────────────────────────────────
  'wired-network-card': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'interface',
      dataKey: 'interface',
      label: 'Interface',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: ['PCIe x1', 'PCIe x4', 'USB'],
    ),
  ],

  // ── Wireless Network Card ─────────────────────────────────────────────────
  'wireless-network-card': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'interface',
      dataKey: 'interface',
      label: 'Interface',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: ['PCIe x1', 'USB'],
    ),
    _SpecDef(
      specKey: 'protocol',
      dataKey: 'protocol',
      label: 'Protocol',
      widgetType: _SpecWidgetType.textChips,
      containsMatch: true,
      textOptions: ['Wi-Fi 5', 'Wi-Fi 6', 'Wi-Fi 6E', 'Wi-Fi 7', 'Bluetooth'],
    ),
  ],

  // ── Fan Controller ────────────────────────────────────────────────────────
  'fan-controller': [
    _SpecDef(
      specKey: 'color',
      dataKey: 'color',
      label: 'Color',
      widgetType: _SpecWidgetType.textDropdown,
      containsMatch: true,
      excludeNull: true,
      textOptions: ['Black', 'White', 'Silver', 'Red', 'Blue', 'Gray'],
    ),
    _SpecDef(
      specKey: 'channels',
      dataKey: 'channels',
      label: 'Channels',
      min: 1,
      max: 12,
      unit: '',
      divisions: 11,
    ),
    _SpecDef(
      specKey: 'channelWattage',
      dataKey: 'channel_wattage',
      label: 'Channel Wattage',
      min: 5,
      max: 30,
      unit: 'W',
      divisions: 25,
    ),
    _SpecDef(
      specKey: 'formFactor',
      dataKey: 'form_factor',
      label: 'Form Factor',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['5.25', '3.5', '2.5'],
    ),
    _SpecDef(
      specKey: 'pwm',
      dataKey: 'pwm',
      label: 'PWM',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.boolTrue,
      textOptions: ['PWM Support'],
    ),
  ],

  // ── Optical Drive ─────────────────────────────────────────────────────────
  'optical-drive': [
    _SpecDef(
      specKey: 'driveType',
      dataKey: '',
      label: 'Drive Type',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.driveType,
      textOptions: ['CD/DVD Drive', 'Blu-ray Reader', 'Blu-ray Writer'],
    ),
    _SpecDef(
      specKey: 'cdSpeed',
      dataKey: 'cd',
      label: 'CD Read Speed',
      min: 1,
      max: 56,
      unit: 'x',
      widgetType: _SpecWidgetType.minChips,
      chips: [24, 32, 40, 48, 52],
    ),
    _SpecDef(
      specKey: 'dvdSpeed',
      dataKey: 'dvd',
      label: 'DVD Read Speed',
      min: 1,
      max: 24,
      unit: 'x',
      widgetType: _SpecWidgetType.minChips,
      chips: [8, 16, 20],
    ),
    _SpecDef(
      specKey: 'bdSpeed',
      dataKey: 'bd',
      label: 'Blu-ray Read Speed',
      min: 1,
      max: 16,
      unit: 'x',
      widgetType: _SpecWidgetType.minChips,
      chips: [4, 6, 8, 12],
    ),
    _SpecDef(
      specKey: 'cdWritable',
      dataKey: 'cd_write',
      label: 'CD Writing',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.nonNull,
      textOptions: ['Writable'],
    ),
    _SpecDef(
      specKey: 'dvdWritable',
      dataKey: 'dvd_write',
      label: 'DVD Writing',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.nonNull,
      textOptions: ['Writable'],
    ),
    _SpecDef(
      specKey: 'bdWritable',
      dataKey: 'bd_write',
      label: 'Blu-ray Writing',
      widgetType: _SpecWidgetType.textChips,
      filterMode: _FilterMode.nonNull,
      textOptions: ['Writable'],
    ),
  ],

  // ── UPS ───────────────────────────────────────────────────────────────────
  'ups': [
    _SpecDef(
      specKey: 'capacityVa',
      dataKey: 'capacity_va',
      label: 'Capacity (VA)',
      min: 300,
      max: 10000,
      unit: 'VA',
      widgetType: _SpecWidgetType.minChips,
      chips: [500, 1000, 1500, 2000, 3000, 5000],
    ),
    _SpecDef(
      specKey: 'capacityW',
      dataKey: 'capacity_w',
      label: 'Capacity (Watt)',
      min: 100,
      max: 3000,
      unit: 'W',
      widgetType: _SpecWidgetType.minChips,
      chips: [200, 300, 400, 600, 800, 1000, 1500, 2000],
    ),
  ],

  // ── Case Accessory ────────────────────────────────────────────────────────
  'case-accessory': [
    _SpecDef(
      specKey: 'brand',
      dataKey: 'brand',
      label: 'Brand',
      widgetType: _SpecWidgetType.textDropdown,
      textOptions: [
        'Corsair', 'NZXT', 'Lian Li', 'Thermaltake', 'Cooler Master',
        'BitFenix', 'Phanteks', 'Silverstone',
      ],
    ),
    _SpecDef(
      specKey: 'type',
      dataKey: 'type',
      label: 'Type',
      widgetType: _SpecWidgetType.textChips,
      textOptions: [
        'Card Reader', 'Front Panel', 'Drive Cage', 'USB Hub', 'Temp Display',
      ],
    ),
    _SpecDef(
      specKey: 'formFactor',
      dataKey: 'form_factor',
      label: 'Form Factor',
      widgetType: _SpecWidgetType.textChips,
      textOptions: ['5.25', '3.5', '2.5'],
    ),
  ],

  // ── OS ────────────────────────────────────────────────────────────────────
  'os': [
    _SpecDef(
      specKey: 'mode',
      dataKey: 'mode',
      label: 'Mode',
      widgetType: _SpecWidgetType.exactChips,
      chips: [32, 64],
      unit: '-bit',
    ),
    _SpecDef(
      specKey: 'maxMemory',
      dataKey: 'max_memory',
      label: 'Max Memory',
      min: 4,
      max: 2048,
      unit: 'GB',
      widgetType: _SpecWidgetType.minChips,
      chips: [4, 8, 16, 32, 64, 128],
    ),
  ],

  // ── Thermal Paste ─────────────────────────────────────────────────────────
  'thermal-paste': [
    _SpecDef(
      specKey: 'amount',
      dataKey: 'amount',
      label: 'Amount',
      min: 1,
      max: 30,
      unit: 'g',
      divisions: 29,
    ),
  ],
};

// ── Sort sheet (sort order + price range) ───────────────────────────────────

class _SortSheet extends StatefulWidget {
  final List<String> sorts;
  final String selectedSort;
  final RangeValues priceRange;
  final _DataCompletenessFilter dataFilter;
  final void Function(
    String sort,
    RangeValues range,
    _DataCompletenessFilter dataFilter,
  )
  onApply;
  final ThemeData theme;

  const _SortSheet({
    required this.sorts,
    required this.selectedSort,
    required this.priceRange,
    required this.dataFilter,
    required this.onApply,
    required this.theme,
  });

  @override
  State<_SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<_SortSheet> {
  late String _sort = widget.selectedSort;
  late RangeValues _range = widget.priceRange;
  late _DataCompletenessFilter _dataFilter = widget.dataFilter;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.partsSort,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.partsOrder,
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
                      _localizedSortName(s, context.l10n),
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
              context.l10n.partsPriceRange,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
              ),
            ),
            _SliderWithLabels(
              initial: _range,
              min: 0,
              max: 5000,
              divisions: 100,
              prefix: '\$',
              theme: theme,
              cs: cs,
              onChanged: (v) => setState(() => _range = v),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.partsDataCompleteness,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.partsDataCompletenessHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (filter, label) in [
                  (_DataCompletenessFilter.showAll, context.l10n.partsShowAll),
                  (_DataCompletenessFilter.compatOnly, context.l10n.partsCompatibilityOnly),
                ])
                  InkWell(
                    onTap: () => setState(() => _dataFilter = filter),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _dataFilter == filter
                            ? cs.primary
                            : cs.surfaceContainerHighest.withValues(
                                alpha: 0.65,
                              ),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _dataFilter == filter
                              ? cs.onPrimary
                              : cs.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => widget.onApply(_sort, _range, _dataFilter),
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: Text(context.l10n.commonApply),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Specs sheet (component-specific spec filters) ────────────────────────────

class _SpecsSheet extends StatefulWidget {
  final String selectedType;
  final Map<String, _ActiveFilter> specFilters;
  final void Function(Map<String, _ActiveFilter> filters) onApply;
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
  late final Map<String, _ActiveFilter> _filters = Map.from(widget.specFilters);

  // Controllers for minMaxInput specs (keyed by specKey)
  final Map<String, TextEditingController> _minCtrls = {};
  final Map<String, TextEditingController> _maxCtrls = {};

  @override
  void initState() {
    super.initState();
    final defs = _typeSpecDefs[widget.selectedType] ?? [];
    for (final def in defs) {
      if (def.widgetType == _SpecWidgetType.minMaxInput) {
        final current = _filters[def.specKey]?.rangeValues;
        _minCtrls[def.specKey] = TextEditingController(
          text: (current != null && current.start > def.min)
              ? current.start.toStringAsFixed(0)
              : '',
        );
        _maxCtrls[def.specKey] = TextEditingController(
          text: (current != null && current.end < def.max)
              ? current.end.toStringAsFixed(0)
              : '',
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _minCtrls.values) {
      c.dispose();
    }
    for (final c in _maxCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Numeric chip row (minChips / exactChips) ──────────────────────────────

  Widget _buildNumericChips(_SpecDef def, ColorScheme cs, ThemeData theme) {
    final unitStr = def.unit.isNotEmpty ? ' ${def.unit}' : '';
    final selectedVal = _filters[def.specKey]?.rangeValues?.start;

    return _SpecSection(
      label: def.label,
      theme: theme,
      cs: cs,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: def.chips.asMap().entries.map((entry) {
          final i = entry.key;
          final v = entry.value;
          final isSelected = selectedVal == v;
          final String chipLabel;
          if (i < def.chipLabelOverrides.length) {
            chipLabel = def.chipLabelOverrides[i];
          } else if (def.chipLabelPrefix.isNotEmpty) {
            chipLabel = '${def.chipLabelPrefix}${v.toInt()}';
          } else if (def.widgetType == _SpecWidgetType.minChips) {
            chipLabel = '${v.toInt()}$unitStr+';
          } else {
            chipLabel = '${v.toInt()}$unitStr';
          }
          return _SpecChip(
            label: chipLabel,
            selected: isSelected,
            theme: theme,
            cs: cs,
            onTap: () => setState(() {
              if (isSelected) {
                _filters.remove(def.specKey);
              } else if (def.widgetType == _SpecWidgetType.minChips) {
                // v == 0 means "exactly zero" (e.g. no cache), not "≥0 = everything"
                _filters[def.specKey] = _ActiveFilter.range(
                  v == 0 ? const RangeValues(0, 0) : RangeValues(v, def.max),
                );
              } else {
                _filters[def.specKey] = _ActiveFilter.range(RangeValues(v, v));
              }
            }),
          );
        }).toList(),
      ),
    );
  }

  // ── Text chip row ─────────────────────────────────────────────────────────

  Widget _buildTextChips(_SpecDef def, ColorScheme cs, ThemeData theme) {
    final selectedText = _filters[def.specKey]?.textValue;

    return _SpecSection(
      label: def.label,
      theme: theme,
      cs: cs,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: def.textOptions.map((opt) {
          final isSelected = selectedText == opt;
          return _SpecChip(
            label: opt,
            selected: isSelected,
            theme: theme,
            cs: cs,
            onTap: () => setState(() {
              if (isSelected) {
                _filters.remove(def.specKey);
              } else {
                _filters[def.specKey] = _ActiveFilter.text(opt);
              }
            }),
          );
        }).toList(),
      ),
    );
  }

  // ── Text dropdown ─────────────────────────────────────────────────────────

  Widget _buildTextDropdown(_SpecDef def, ColorScheme cs, ThemeData theme) {
    final selectedText = _filters[def.specKey]?.textValue ?? '';
    final isActive = selectedText.isNotEmpty;

    return _SpecSection(
      label: def.label,
      theme: theme,
      cs: cs,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? cs.primaryContainer.withValues(alpha: 0.7)
              : cs.surfaceContainerHighest.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? cs.primary.withValues(alpha: 0.5)
                : cs.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: DropdownButton<String>(
          value: selectedText.isEmpty ? '' : selectedText,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          dropdownColor: cs.surface,
          iconEnabledColor: isActive
              ? cs.onPrimaryContainer
              : cs.onSurfaceVariant,
          items: [
            DropdownMenuItem<String>(
              value: '',
              child: Text(
                context.l10n.partsSpecsAny,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...def.textOptions.map(
              (opt) => DropdownMenuItem<String>(
                value: opt,
                child: Text(
                  opt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
          onChanged: (val) => setState(() {
            if (val == null || val.isEmpty) {
              _filters.remove(def.specKey);
            } else {
              _filters[def.specKey] = _ActiveFilter.text(val);
            }
          }),
        ),
      ),
    );
  }

  // ── Range slider ──────────────────────────────────────────────────────────

  Widget _buildRangeSlider(_SpecDef def, ColorScheme cs, ThemeData theme) {
    final current =
        _filters[def.specKey]?.rangeValues ?? RangeValues(def.min, def.max);
    return _SpecSection(
      label: def.label,
      theme: theme,
      cs: cs,
      child: _SliderWithLabels(
        initial: current,
        min: def.min,
        max: def.max,
        divisions: def.divisions,
        suffix: def.unit.isNotEmpty ? ' ${def.unit}' : '',
        theme: theme,
        cs: cs,
        onChanged: (v) =>
            setState(() => _filters[def.specKey] = _ActiveFilter.range(v)),
      ),
    );
  }

  Widget _buildMinMaxInput(_SpecDef def, ColorScheme cs, ThemeData theme) {
    final unitStr = def.unit.isNotEmpty ? ' ${def.unit}' : '';
    final minCtrl = _minCtrls[def.specKey]!;
    final maxCtrl = _maxCtrls[def.specKey]!;

    void commit() {
      final minVal = double.tryParse(minCtrl.text);
      final maxVal = double.tryParse(maxCtrl.text);
      if (minVal == null && maxVal == null) {
        setState(() => _filters.remove(def.specKey));
        return;
      }
      final start = minVal ?? def.min;
      final end = maxVal ?? def.max;
      setState(
        () => _filters[def.specKey] = _ActiveFilter.range(
          RangeValues(start < end ? start : end, end > start ? end : start),
        ),
      );
    }

    return _SpecSection(
      label: def.label,
      theme: theme,
      cs: cs,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: minCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Min$unitStr',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onEditingComplete: commit,
              onTapOutside: (_) => commit(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: maxCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Max$unitStr',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onEditingComplete: commit,
              onTapOutside: (_) => commit(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final cs = theme.colorScheme;
    final defs = _typeSpecDefs[widget.selectedType] ?? [];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.partsSpecs,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (_filters.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _filters.clear()),
                    child: Text(context.l10n.partsSpecsReset),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...defs.map(
              (def) => switch (def.widgetType) {
                _SpecWidgetType.rangeSlider => _buildRangeSlider(
                  def,
                  cs,
                  theme,
                ),
                _SpecWidgetType.minChips || _SpecWidgetType.exactChips =>
                  _buildNumericChips(def, cs, theme),
                _SpecWidgetType.textChips => _buildTextChips(def, cs, theme),
                _SpecWidgetType.textDropdown => _buildTextDropdown(
                  def,
                  cs,
                  theme,
                ),
                _SpecWidgetType.minMaxInput => _buildMinMaxInput(
                  def,
                  cs,
                  theme,
                ),
              },
            ),
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
                child: Text(context.l10n.commonApply),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable spec-filter helper widgets ──────────────────────────────────────

/// Label + child widget pair used in every spec-filter row.
class _SpecSection extends StatelessWidget {
  final String label;
  final Widget child;
  final ThemeData theme;
  final ColorScheme cs;

  const _SpecSection({
    required this.label,
    required this.child,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localizedSpecLabel(label, context.l10n),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 12),
      ],
    );
  }
}

/// Pill-shaped selectable chip used in spec-filter rows.
// ── Slider with always-visible value labels above each thumb ─────────────────

/// Custom thumb shape that also paints the value label directly above the
/// thumb.  Flutter passes the exact thumb centre to [paint], so the label
/// is always perfectly in sync — no external geometry calculation needed.
class _ThumbWithLabel extends RangeSliderThumbShape {
  final String startLabel;
  final String endLabel;
  final TextStyle? labelStyle;

  static const double _r = 10.0; // thumb radius, matches M2/M3 default
  static const double _gap = 4.0;

  const _ThumbWithLabel({
    required this.startLabel,
    required this.endLabel,
    required this.labelStyle,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(_r);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    TextDirection textDirection = TextDirection.ltr,
    required SliderThemeData sliderTheme,
    Thumb thumb = Thumb.start,
    double value = 0,
  }) {
    // Delegate to Flutter's default thumb so theme colours / shadows are kept.
    const RoundRangeSliderThumbShape(enabledThumbRadius: _r).paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      isOnTop: isOnTop,
      isPressed: isPressed,
      textDirection: textDirection,
      sliderTheme: sliderTheme,
      thumb: thumb,
    );

    // Paint value label centred above the thumb.
    final label = thumb == Thumb.start ? startLabel : endLabel;
    final tp = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      context.canvas,
      Offset(center.dx - tp.width / 2, center.dy - _r - _gap - tp.height),
    );
  }
}

class _SliderWithLabels extends StatefulWidget {
  final RangeValues initial;
  final double min;
  final double max;
  final int divisions;
  final String prefix;
  final String suffix;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RangeValues) onChanged;

  const _SliderWithLabels({
    required this.initial,
    required this.min,
    required this.max,
    required this.divisions,
    required this.theme,
    required this.cs,
    required this.onChanged,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  State<_SliderWithLabels> createState() => _SliderWithLabelsState();
}

class _SliderWithLabelsState extends State<_SliderWithLabels> {
  late RangeValues _current = widget.initial;

  @override
  void didUpdateWidget(_SliderWithLabels old) {
    super.didUpdateWidget(old);
    // Sync when parent resets or pushes a new value (e.g. "Reset" button)
    if (old.initial != widget.initial) _current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = widget.theme.textTheme.labelSmall?.copyWith(
      color: widget.cs.primary,
      fontWeight: FontWeight.w700,
    );
    // Use decimal places when the range is small (e.g. $/GB sliders)
    final decimals = (widget.max - widget.min) < 10 ? 2 : 0;
    String fmt(double v) =>
        '${widget.prefix}${v.toStringAsFixed(decimals)}${widget.suffix}';

    // _ThumbWithLabel receives the exact thumb centre from Flutter's own
    // rendering pipeline — labels are always in sync and always visible.
    // The top padding reserves visual space so labels don't overlap the
    // section heading above.
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          rangeThumbShape: _ThumbWithLabel(
            startLabel: fmt(_current.start),
            endLabel: fmt(_current.end),
            labelStyle: labelStyle,
          ),
        ),
        child: RangeSlider(
          values: _current,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: (v) {
            setState(() => _current = v);
            widget.onChanged(v);
          },
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme cs;

  const _SpecChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary
              : cs.surfaceContainerHighest.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? cs.onPrimary : cs.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
