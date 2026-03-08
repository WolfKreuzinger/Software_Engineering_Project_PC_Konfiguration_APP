import '../screens/parts_screen.dart';

enum CompatIssueLevel { ok, warning, error }

class CompatIssue {
  const CompatIssue(this.message, this.level);

  final String message;
  final CompatIssueLevel level;
}

class CompatibilityResult {
  const CompatibilityResult(this.issues);

  final List<CompatIssue> issues;

  CompatIssueLevel get overallLevel {
    if (issues.any((i) => i.level == CompatIssueLevel.error)) {
      return CompatIssueLevel.error;
    }
    if (issues.any((i) => i.level == CompatIssueLevel.warning)) {
      return CompatIssueLevel.warning;
    }
    return CompatIssueLevel.ok;
  }

  bool get hasIssues => overallLevel != CompatIssueLevel.ok;
}

class CompatibilityChecker {
  CompatibilityChecker._();

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  /// Returns true when the case form factor supports the given motherboard form factor.
  static bool _caseSupportsFormFactor(String caseType, String mbFormFactor) {
    final ct = caseType.toLowerCase();
    final ff = mbFormFactor.toLowerCase().replaceAll('-', '').replaceAll(' ', '');

    // Full Tower / Mid Tower / Mini Tower (ATX-labelled) → everything up to EATX
    if (ct.contains('atx full tower') ||
        ct.contains('atx mid tower') ||
        ct.contains('atx mini tower') ||
        ct.contains('atx desktop') ||
        ct.contains('atx test bench')) {
      const supported = {
        'atx', 'eatx', 'microatx', 'miniitx', 'minidtx', 'flexatx',
        'thinminiitx',
      };
      return supported.contains(ff);
    }

    // MicroATX cases → Micro ATX and smaller
    if (ct.contains('microatx') || ct.contains('micro atx')) {
      const supported = {'microatx', 'miniitx', 'minidtx', 'flexatx', 'thinminiitx'};
      return supported.contains(ff);
    }

    // Mini ITX cases → only Mini ITX / Mini DTX / Thin Mini ITX
    if (ct.contains('mini itx') || ct.contains('mini-itx')) {
      const supported = {'miniitx', 'minidtx', 'thinminiitx'};
      return supported.contains(ff);
    }

    // HTPC / HTPC Desktop → typically Micro ATX / Mini ITX
    if (ct.contains('htpc')) {
      const supported = {'microatx', 'miniitx', 'minidtx', 'flexatx', 'thinminiitx'};
      return supported.contains(ff);
    }

    // Unknown case type → don't block
    return true;
  }

  static CompatibilityResult check({
    required Map<String, PartSelection> parts,
    required int estimatedWatts,
  }) {
    final issues = <CompatIssue>[];

    final cpu = parts['cpu'];
    final mb  = parts['motherboard'];
    final ram = parts['ram'];
    final psu = parts['psu'];
    final pcCase = parts['case'];

    // ── 0. Pflichtteile vollständig? ─────────────────────────────────────────
    const requiredSlots = <String, String>{
      'cpu':         'CPU',
      'cpuCooler':   'CPU-Kühler',
      'motherboard': 'Mainboard',
      'ram':         'RAM',
      'storage':     'Speicher (SSD/HDD)',
      'case':        'Gehäuse',
      'psu':         'Netzteil',
    };
    final missing = requiredSlots.entries
        .where((e) => parts[e.key] == null)
        .map((e) => e.value)
        .toList();
    if (missing.isNotEmpty) {
      issues.add(CompatIssue(
        'Fehlende Pflichtteile: ${missing.join(', ')}',
        CompatIssueLevel.warning,
      ));
    }

    // ── A. CPU ↔ Motherboard socket ─────────────────────────────────────────
    if (cpu != null && mb != null) {
      final cpuSocket = cpu.rawData['socket']?.toString().trim();
      final mbSocket  = mb.rawData['socket']?.toString().trim();

      if (cpuSocket != null && cpuSocket.isNotEmpty &&
          mbSocket  != null && mbSocket.isNotEmpty) {
        if (cpuSocket != mbSocket) {
          issues.add(CompatIssue(
            'CPU-Sockel $cpuSocket ≠ Mainboard-Sockel $mbSocket',
            CompatIssueLevel.error,
          ));
        } else {
          issues.add(CompatIssue(
            'CPU-Sockel: $cpuSocket ✓',
            CompatIssueLevel.ok,
          ));
        }
      }
    }

    // ── B. RAM DDR generation ↔ Motherboard (partial: AM5 requires DDR5) ───
    if (ram != null && mb != null) {
      final speedRaw = ram.rawData['speed'];
      int? ddrGen;
      if (speedRaw is List && speedRaw.isNotEmpty) {
        ddrGen = _toInt(speedRaw.first);
      }

      final mbSocket = mb.rawData['socket']?.toString().trim() ?? '';

      if (ddrGen != null && ddrGen > 0) {
        if (mbSocket == 'AM5' && ddrGen != 5) {
          issues.add(CompatIssue(
            'AM5-Mainboard benötigt DDR5, ausgewählt: DDR$ddrGen',
            CompatIssueLevel.error,
          ));
        } else if (mbSocket == 'AM4' && ddrGen != 4) {
          issues.add(CompatIssue(
            'AM4-Mainboard benötigt DDR4, ausgewählt: DDR$ddrGen',
            CompatIssueLevel.error,
          ));
        } else if (mbSocket == 'LGA1700' || mbSocket == 'LGA1200') {
          // Intel 10th-gen+ boards can be DDR4 or DDR5 depending on model — skip
        } else if (mbSocket.isNotEmpty && (ddrGen == 4 || ddrGen == 5)) {
          issues.add(CompatIssue(
            'RAM DDR$ddrGen ✓',
            CompatIssueLevel.ok,
          ));
        }
      }
    }

    // ── C. Motherboard form factor ↔ Case ───────────────────────────────────
    if (mb != null && pcCase != null) {
      final ff       = mb.rawData['form_factor']?.toString().trim() ?? '';
      final caseType = pcCase.rawData['type']?.toString().trim() ?? '';

      if (ff.isNotEmpty && caseType.isNotEmpty) {
        if (!_caseSupportsFormFactor(caseType, ff)) {
          issues.add(CompatIssue(
            'Gehäuse ($caseType) unterstützt $ff-Mainboard nicht',
            CompatIssueLevel.error,
          ));
        } else {
          issues.add(CompatIssue(
            'Formfaktor $ff im Gehäuse ✓',
            CompatIssueLevel.ok,
          ));
        }
      }
    }

    // ── D. PSU wattage vs. estimated system draw ─────────────────────────────
    if (psu != null && estimatedWatts > 0) {
      final psuW = _toInt(psu.rawData['wattage']);
      if (psuW > 0) {
        if (psuW < estimatedWatts) {
          issues.add(CompatIssue(
            'Netzteil zu schwach: ${psuW}W < ~${estimatedWatts}W',
            CompatIssueLevel.error,
          ));
        } else if (psuW < (estimatedWatts * 1.2).ceil()) {
          issues.add(CompatIssue(
            'Netzteil-Puffer niedrig: ${psuW}W für ~${estimatedWatts}W',
            CompatIssueLevel.warning,
          ));
        } else {
          issues.add(CompatIssue(
            'Netzteil ausreichend: ${psuW}W ✓',
            CompatIssueLevel.ok,
          ));
        }
      }
    }

    // ── E. BIOS-Update ggf. nötig (CPU-Generation > Board-Generation) ────────
    if (cpu != null && mb != null) {
      final cpuName = cpu.rawData['name']?.toString().toLowerCase() ?? '';
      final mbName  = mb.rawData['name']?.toString().toLowerCase() ?? '';
      final mbSocket = mb.rawData['socket']?.toString().trim() ?? '';

      // AMD: Ryzen 9000-series on AM5 boards that are not X870/X870E
      if (mbSocket == 'AM5') {
        final cpuModelMatch = RegExp(r'ryzen\s+\d+\s+(?:pro\s+)?(\d{4,5})').firstMatch(cpuName);
        if (cpuModelMatch != null) {
          final modelNum = int.tryParse(cpuModelMatch.group(1)!) ?? 0;
          final isRyzen9000 = modelNum >= 9000 && modelNum < 10000;
          final boardIsX870 = mbName.contains('x870');
          if (isRyzen9000 && !boardIsX870) {
            issues.add(const CompatIssue(
              'Ryzen 9000 ggf. BIOS-Update nötig (kein X870-Board)',
              CompatIssueLevel.warning,
            ));
          }
        }
      }

      // Intel: 14th-gen CPUs on 600-series boards (Z690/B660/H670/H610)
      if (mbSocket == 'LGA1700') {
        final cpuModelMatch = RegExp(r'i[3579]-?(\d{5})').firstMatch(cpuName);
        if (cpuModelMatch != null) {
          final modelNum = int.tryParse(cpuModelMatch.group(1)!) ?? 0;
          final is14thGen = modelNum >= 14000 && modelNum < 15000;
          final is600Series = RegExp(r'[zbh]6[6-9]0').hasMatch(mbName);
          if (is14thGen && is600Series) {
            issues.add(const CompatIssue(
              'Intel 14. Gen auf 600er-Board: BIOS-Update nötig',
              CompatIssueLevel.warning,
            ));
          }
        }
      }
    }

    // ── F. RAM MHz > JEDEC-Spezifikation → XMP/EXPO nötig ───────────────────
    if (ram != null) {
      final speedRaw = ram.rawData['speed'];
      if (speedRaw is List && speedRaw.length >= 2) {
        final ddrGen = _toInt(speedRaw[0]);
        final ramMhz = _toInt(speedRaw[1]);
        if (ramMhz > 0) {
          final jedec = ddrGen == 5 ? 4800 : 3200; // DDR5: 4800, DDR4: 3200
          if (ramMhz > jedec) {
            issues.add(CompatIssue(
              'RAM ${ramMhz}MHz > JEDEC ${jedec}MHz: läuft ggf. nur mit XMP/EXPO',
              CompatIssueLevel.warning,
            ));
          }
        }
      }
    }

    // ── G. DDR5 auf Einstiegs-Board → Stabilitätswarnung ────────────────────
    if (ram != null && mb != null) {
      final speedRaw = ram.rawData['speed'];
      int? ddrGen;
      if (speedRaw is List && speedRaw.isNotEmpty) {
        ddrGen = _toInt(speedRaw.first);
      }
      if (ddrGen == 5) {
        final mbName = mb.rawData['name']?.toString().toLowerCase() ?? '';
        // Budget chipsets: B650, B660, B760, B460, H670, H770, A620
        final isBudgetBoard = RegExp(r'\b(b650|b660|b760|b460|h670|h770|a620)\b').hasMatch(mbName);
        if (isBudgetBoard) {
          issues.add(const CompatIssue(
            'DDR5 auf Einstiegs-Board: Stabilität vom Memory Controller abhängig',
            CompatIssueLevel.warning,
          ));
        }
      }
    }

    return CompatibilityResult(issues);
  }
}
