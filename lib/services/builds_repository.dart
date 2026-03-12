import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/saved_build.dart';

class BuildsRepository {
  BuildsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _buildsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('builds');
  }

  Stream<List<SavedBuild>> watchBuilds(
    String uid, {
    bool includeArchived = false,
  }) {
    return _buildsRef(
      uid,
    ).orderBy('updatedAt', descending: true).snapshots().map((snap) {
      final builds = snap.docs.map(SavedBuild.fromDoc).toList(growable: false);
      if (includeArchived) return builds;
      return builds
          .where((b) => b.status != BuildStatus.archived)
          .toList(growable: false);
    });
  }

  Future<int> _nextBuildNumber(String uid) async {
    final snap = await _buildsRef(uid).get();
    var maxN = 0;
    for (final doc in snap.docs) {
      final title = (doc.data()['title'] ?? '').toString().trim();
      final m = RegExp(r'^Build\s+(\d+)$').firstMatch(title);
      if (m == null) continue;
      final n = int.tryParse(m.group(1) ?? '') ?? 0;
      if (n > maxN) maxN = n;
    }
    if (maxN > 0) return maxN + 1;
    return snap.docs.length + 1;
  }

  BuildStatus computeStatusFromSelectedParts(Map<String, dynamic> selectedParts) {
    final selectedKeys = selectedParts.entries
        .where((e) {
          if (e.value is! Map) return false;
          final name = (e.value as Map)['name']?.toString().trim() ?? '';
          return name.isNotEmpty;
        })
        .map((e) => e.key)
        .toSet();
    if (selectedKeys.isEmpty) return BuildStatus.draft;
    const core = <String>{
      'cpu',
      'motherboard',
      'ram',
      'storage',
      'psu',
      'case',
    };
    return core.every(selectedKeys.contains)
        ? BuildStatus.completed
        : BuildStatus.inProgress;
  }

  Future<String> saveBuild({
    required String uid,
    required Map<String, dynamic> selectedParts,
    required double totalPrice,
    required int estimatedWattage,
    required BuildStatus status,
    String? existingBuildId,
    String? title,
    String? existingTitle,
    DateTime? existingCreatedAt,
    bool readOnly = false,
    String? importedFrom,
  }) async {
    final now = Timestamp.now();
    final ref = existingBuildId == null
        ? _buildsRef(uid).doc()
        : _buildsRef(uid).doc(existingBuildId);

    final buildId = ref.id;
    final requestedTitle = (title ?? '').trim();
    final current = (existingTitle ?? '').trim();
    String resolvedTitle;
    if (requestedTitle.isNotEmpty) {
      resolvedTitle = requestedTitle;
    } else
    if (current.isNotEmpty) {
      resolvedTitle = current;
    } else {
      try {
        resolvedTitle = 'Build ${await _nextBuildNumber(uid)}';
      } catch (_) {
        // Fallback when read access is restricted but write is allowed.
        resolvedTitle = 'Build 1';
      }
    }

    final payload = <String, dynamic>{
      'buildId': buildId,
      'createdAt': existingCreatedAt != null
          ? Timestamp.fromDate(existingCreatedAt)
          : now,
      'updatedAt': now,
      'title': resolvedTitle,
      'status': buildStatusToString(status),
      'selectedParts': selectedParts,
      'totalPrice': totalPrice,
      'estimatedWattage': estimatedWattage,
      'readOnly': readOnly,
      if (importedFrom != null && importedFrom.isNotEmpty)
        'importedFrom': importedFrom,
    };

    await ref.set(payload);
    return buildId;
  }

  Future<void> renameBuild({
    required String uid,
    required String buildId,
    required String title,
  }) async {
    final next = title.trim();
    if (next.isEmpty) return;
    await _buildsRef(uid).doc(buildId).set(<String, dynamic>{
      'title': next,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteBuild({
    required String uid,
    required String buildId,
  }) async {
    await _buildsRef(uid).doc(buildId).delete();
  }

  // ── Sharing ──────────────────────────────────────────────────────────────

  static const String shareBaseUrl = 'https://buildmypc-9ddd0.web.app';

  /// Writes a snapshot of [build] to the public `publicBuilds` collection
  /// and returns the shareable URL.
  ///
  /// If [readOnly] is true the recipient will only be able to view the build.
  /// Pass [senderName] (the sharer's display name) to show attribution.
  Future<String> publishBuild(
    SavedBuild build, {
    bool readOnly = false,
    String? senderName,
  }) async {
    await _firestore.collection('publicBuilds').doc(build.buildId).set({
      'buildId': build.buildId,
      'title': build.title,
      'status': buildStatusToString(build.status),
      'selectedParts': build.selectedParts,
      'totalPrice': build.totalPrice,
      'estimatedWattage': build.estimatedWattage,
      'publishedAt': FieldValue.serverTimestamp(),
      'readOnly': readOnly,
      if (readOnly && senderName != null && senderName.isNotEmpty)
        'senderName': senderName,
    });
    return '$shareBaseUrl/build/${build.buildId}';
  }

  /// Reads a previously published build from the `publicBuilds` collection.
  Future<Map<String, dynamic>?> getPublicBuild(String buildId) async {
    final doc =
        await _firestore.collection('publicBuilds').doc(buildId).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}
