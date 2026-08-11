import '../../../../core/name_normalizer.dart';
import '../../../../core/named_match.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Shared merge helpers for backup import (name-keyed catalogs).
///
/// Keeps catalog merge rules in one place so BackupImporter and future sync
/// paths do not diverge.
class ImportCoordinator {
  const ImportCoordinator._();

  /// Merges named catalog rows by case-insensitive name.
  ///
  /// Returns a map of backup-local id → database id.
  ///
  /// Existing rows are matched with [matchNamedCatalogRow] (active over
  /// soft-deleted). After each insert the in-memory pending index is updated
  /// so duplicate names inside one backup file merge instead of hitting the
  /// unique index.
  static Future<Map<int, int>> mergeNamedCatalog<T>({
    required List<Map<String, dynamic>> items,
    required Future<List<T>> Function() selectAll,
    required String Function(T) nameOf,
    required int Function(T) idOf,
    required bool Function(T) isDeletedOf,
    required Future<int> Function(
      String name,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt,
    ) insert,
    required Future<void> Function(int id) undelete,
    required void Function() onAdded,
    required void Function() onSkipped,
  }) async {
    final idMap = <int, int>{};
    final existing = await selectAll();
    // Inserts / undeletes within this merge pass (normalized name → row).
    final pendingByName = <String, ({int id, bool isDeleted})>{};

    for (final item in items) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final name = BackupJsonCodec.asString(item[BackupKeys.name])?.trim();
      if (oldId == null || name == null || name.isEmpty) continue;
      final isDeleted = item[BackupKeys.isDeleted] == true;
      final key = NameNormalizer.normalize(name);

      final pending = pendingByName[key];
      int? matchId;
      var matchDeleted = false;
      if (pending != null) {
        matchId = pending.id;
        matchDeleted = pending.isDeleted;
      } else {
        final match = matchNamedCatalogRow(
          rows: existing,
          nameOf: nameOf,
          isDeletedOf: isDeletedOf,
          rawName: name,
        );
        if (match != null) {
          matchId = idOf(match);
          matchDeleted = isDeletedOf(match);
        }
      }

      if (matchId != null) {
        idMap[oldId] = matchId;
        if (matchDeleted && !isDeleted) {
          await undelete(matchId);
          pendingByName[key] = (id: matchId, isDeleted: false);
        }
        onSkipped();
        continue;
      }

      final now = DateTime.now();
      final createdAt =
          BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now;
      final updatedAt =
          BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now;
      final newId = await insert(name, isDeleted, createdAt, updatedAt);
      idMap[oldId] = newId;
      pendingByName[key] = (id: newId, isDeleted: isDeleted);
      onAdded();
    }
    return idMap;
  }
}
