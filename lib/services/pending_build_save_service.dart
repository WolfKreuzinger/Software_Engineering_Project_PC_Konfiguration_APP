import 'package:firebase_auth/firebase_auth.dart';

import '../models/saved_build.dart';
import 'builds_repository.dart';

class PendingBuildSave {
  const PendingBuildSave({
    required this.selectedParts,
    required this.totalPrice,
    required this.estimatedWattage,
    required this.status,
    required this.title,
    this.existingBuildId,
    this.existingTitle,
    this.existingCreatedAt,
  });

  final Map<String, dynamic> selectedParts;
  final double totalPrice;
  final int estimatedWattage;
  final BuildStatus status;
  final String title;
  final String? existingBuildId;
  final String? existingTitle;
  final DateTime? existingCreatedAt;
}

class PendingBuildSaveService {
  PendingBuildSaveService._();
  static final PendingBuildSaveService instance = PendingBuildSaveService._();

  final BuildsRepository _repo = BuildsRepository();
  PendingBuildSave? _pending;
  bool _isFlushing = false;

  void setPending(PendingBuildSave pending) {
    _pending = pending;
  }

  PendingBuildSave? take() {
    final current = _pending;
    _pending = null;
    return current;
  }

  bool get hasPending => _pending != null;

  Future<void> flushForUser(User? user) async {
    if (_isFlushing) return;
    if (user == null || user.isAnonymous) return;
    final pending = take();
    if (pending == null) return;

    _isFlushing = true;
    try {
      await _repo.saveBuild(
        uid: user.uid,
        selectedParts: _deepCopyMap(pending.selectedParts),
        totalPrice: pending.totalPrice,
        estimatedWattage: pending.estimatedWattage,
        status: pending.status,
        title: pending.title,
        existingBuildId: pending.existingBuildId,
        existingTitle: pending.existingTitle,
        existingCreatedAt: pending.existingCreatedAt,
      );
    } catch (_) {
      // Keep pending payload to retry on next auth state change.
      _pending = pending;
    } finally {
      _isFlushing = false;
    }
  }

  Map<String, dynamic> _deepCopyMap(Map<String, dynamic> source) {
    final out = <String, dynamic>{};
    for (final entry in source.entries) {
      out[entry.key] = _deepCopyValue(entry.value);
    }
    return out;
  }

  dynamic _deepCopyValue(dynamic value) {
    if (value is Map) {
      final out = <String, dynamic>{};
      for (final e in value.entries) {
        out[e.key.toString()] = _deepCopyValue(e.value);
      }
      return out;
    }
    if (value is List) {
      return value.map(_deepCopyValue).toList(growable: false);
    }
    return value;
  }
}
