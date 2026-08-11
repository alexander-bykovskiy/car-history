import '../../../../core/number_parsing.dart';
import '../models/draft_part_line.dart';
import 'maintenance_form_loader.dart';

/// Editable parts draft for the maintenance form session.
class MaintenancePartsDraft {
  final List<DraftPartLine> _parts = [];
  int _nextPartLocalId = 1;

  List<DraftPartLine> get parts => List.unmodifiable(_parts);
  int get nextPartLocalId => _nextPartLocalId;

  double get partsTotal {
    var sum = 0.0;
    for (final line in _parts) {
      final total = line.lineTotal;
      if (total != null) sum += total;
    }
    return sum;
  }

  void upsert(DraftPartLine line, {DraftPartLine? replacing}) {
    if (replacing == null) {
      _nextPartLocalId = line.localId + 1;
      _parts.add(line);
    } else {
      final index =
          _parts.indexWhere((item) => item.localId == replacing.localId);
      if (index >= 0) {
        _parts[index] = line;
      }
    }
  }

  void remove(int localId) {
    _parts.removeWhere((item) => item.localId == localId);
  }

  void hydrateFromSeeds(Iterable<MaintenancePartSeed> seeds) {
    _parts
      ..clear()
      ..addAll(seeds.map((seed) => seed.toDraft(_nextPartLocalId++)));
  }

  static double laborTotal(String totalText) {
    final raw = totalText.trim();
    if (raw.isEmpty) return 0;
    return parseFlexibleDouble(raw) ?? 0;
  }

  static double grandTotal({
    required double partsTotal,
    required String totalText,
  }) {
    return partsTotal + laborTotal(totalText);
  }
}
