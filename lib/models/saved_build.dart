import 'package:cloud_firestore/cloud_firestore.dart';

enum BuildStatus { draft, inProgress, completed, archived }

BuildStatus buildStatusFromString(String raw) {
  switch (raw) {
    case 'draft':
      return BuildStatus.draft;
    case 'completed':
      return BuildStatus.completed;
    case 'archived':
      return BuildStatus.archived;
    case 'inProgress':
    default:
      return BuildStatus.inProgress;
  }
}

String buildStatusToString(BuildStatus status) {
  switch (status) {
    case BuildStatus.draft:
      return 'draft';
    case BuildStatus.completed:
      return 'completed';
    case BuildStatus.archived:
      return 'archived';
    case BuildStatus.inProgress:
      return 'inProgress';
  }
}

const List<String> buildSlotKeys = <String>[
  'cpu',
  'cpuCooler',
  'thermalPaste',
  'motherboard',
  'ram',
  'gpu',
  'storage',
  'case',
  'caseFans',
  'fanController',
  'caseAccessories',
  'psu',
  'wifi',
  'ethernet',
  'soundCard',
  'opticalDrive',
  'externalHdd',
  'ups',
  'os',
];

class SavedBuild {
  const SavedBuild({
    required this.buildId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.status,
    required this.selectedParts,
    required this.totalPrice,
    required this.estimatedWattage,
    this.heroImageUrl,
  });

  final String buildId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final BuildStatus status;
  final Map<String, dynamic> selectedParts;
  final double totalPrice;
  final int estimatedWattage;
  final String? heroImageUrl;

  int get selectedCount {
    var count = 0;
    for (final key in buildSlotKeys) {
      if (selectedParts[key] != null) count++;
    }
    return count;
  }

  String get componentProgressLabel =>
      '$selectedCount/${buildSlotKeys.length} Components Selected';

  String? get cpuName {
    final cpu = selectedParts['cpu'];
    if (cpu is Map) return (cpu['name'] ?? '').toString().trim();
    return null;
  }

  String? get gpuName {
    final gpu = selectedParts['gpu'];
    if (gpu is Map) return (gpu['name'] ?? '').toString().trim();
    return null;
  }

  String get summaryLine {
    final parts = <String>[
      if ((gpuName ?? '').isNotEmpty) gpuName!,
      if ((cpuName ?? '').isNotEmpty) cpuName!,
    ];
    if (parts.isNotEmpty) return parts.join(' • ');
    return componentProgressLabel;
  }

  bool get isResumable =>
      status == BuildStatus.inProgress || status == BuildStatus.draft;

  String get statusLabel {
    switch (status) {
      case BuildStatus.completed:
        return 'COMPLETED';
      case BuildStatus.draft:
        return 'DRAFT';
      case BuildStatus.archived:
        return 'ARCHIVED';
      case BuildStatus.inProgress:
        return 'IN PROGRESS';
    }
  }

  factory SavedBuild.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdRaw = data['createdAt'];
    final updatedRaw = data['updatedAt'];

    final createdAt = createdRaw is Timestamp
        ? createdRaw.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);
    final updatedAt = updatedRaw is Timestamp ? updatedRaw.toDate() : createdAt;

    return SavedBuild(
      buildId: (data['buildId'] ?? doc.id).toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: ((data['title'] ?? '').toString().trim().isEmpty)
          ? 'Build'
          : data['title'].toString(),
      status: buildStatusFromString((data['status'] ?? '').toString()),
      selectedParts: (data['selectedParts'] is Map)
          ? Map<String, dynamic>.from(data['selectedParts'] as Map)
          : <String, dynamic>{},
      totalPrice: _toDouble(data['totalPrice']),
      estimatedWattage: _toInt(data['estimatedWattage']),
      heroImageUrl: (data['heroImageUrl'] ?? '').toString().trim().isEmpty
          ? null
          : data['heroImageUrl'].toString(),
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
