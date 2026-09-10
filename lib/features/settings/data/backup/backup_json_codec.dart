import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/report_caught_error.dart';

/// Pure JSON helpers for backup export/import (no DB / Flutter UI deps).
abstract final class BackupJsonCodec {
  static String dt(DateTime value) => value.toUtc().toIso8601String();

  static DateTime? parseDt(Object? raw) {
    if (raw is! String || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }

  static List<Map<String, dynamic>> list(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) item,
    ];
  }

  static int? asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return null;
  }

  static double? asDouble(Object? raw) {
    if (raw is double) return raw;
    if (raw is num) return raw.toDouble();
    return null;
  }

  static String? asString(Object? raw) {
    if (raw is! String) return null;
    final trimmed = raw.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static bool sameStr(String? a, String? b) {
    final na = a?.trim();
    final nb = b?.trim();
    final ca = (na == null || na.isEmpty) ? null : na;
    final cb = (nb == null || nb.isEmpty) ? null : nb;
    return ca == cb;
  }

  static bool sameDouble(double? a, double? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return (a - b).abs() < 1e-9;
  }

  static bool sameDt(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.toUtc().millisecondsSinceEpoch == b.toUtc().millisecondsSinceEpoch;
  }

  static bool sameBytes(Uint8List? a, Uint8List? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static Uint8List? decodePhoto(Object? raw) {
    if (raw is! String || raw.isEmpty) return null;
    try {
      return Uint8List.fromList(base64Decode(raw));
    } catch (e, st) {
      reportCaughtError(e, st, context: 'BackupJsonCodec.decodePhoto');
      return null;
    }
  }

  static int? mapNullable(int? oldId, Map<int, int> map) {
    if (oldId == null) return null;
    return map[oldId];
  }

  /// Required FK: [oldId] must be non-null and present in [map].
  static int? mapRequired(int? oldId, Map<int, int> map) {
    if (oldId == null) return null;
    return map[oldId];
  }

  /// Optional FK: null [oldId] is OK; non-null must resolve in [map].
  ///
  /// Returns `(id: mapped, unresolved: false)` on success, or
  /// `(id: null, unresolved: true)` when [oldId] was set but missing from [map].
  static ({int? id, bool unresolved}) mapOptionalFk(
    int? oldId,
    Map<int, int> map,
  ) {
    if (oldId == null) return (id: null, unresolved: false);
    final mapped = map[oldId];
    if (mapped == null) return (id: null, unresolved: true);
    return (id: mapped, unresolved: false);
  }
}
