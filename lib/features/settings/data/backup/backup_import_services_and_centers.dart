import 'package:drift/drift.dart';

import '../../../../core/named_match.dart';
import '../../../../core/optional_string.dart';
import '../../../../shared/data/db/app_database.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Merges services (with iconKey) and service centers from a backup root.
class BackupImportServicesAndCenters {
  BackupImportServicesAndCenters(this._db);

  final AppDatabase _db;

  /// Returns backup-local service id → database id.
  Future<Map<int, int>> import(
    Map<String, dynamic> root, {
    required BackupImportCounters counters,
  }) async {
    final serviceIdMap = <int, int>{};
    final existingServices = await _db.select(_db.services).get();
    for (final item in BackupJsonCodec.list(root[BackupKeys.services])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final name = BackupJsonCodec.asString(item[BackupKeys.name])?.trim();
      if (oldId == null || name == null || name.isEmpty) continue;
      final iconKey = BackupJsonCodec.asString(item[BackupKeys.iconKey]);
      final isDeleted = item[BackupKeys.isDeleted] == true;

      // Match by name only (unique index / findNamedCatalogMatch); ignore iconKey.
      final match = matchNamedCatalogRow(
        rows: existingServices,
        nameOf: (row) => row.name,
        isDeletedOf: (row) => row.isDeleted,
        rawName: name,
      );
      if (match != null) {
        serviceIdMap[oldId] = match.id;
        if (match.isDeleted && !isDeleted) {
          await (_db.update(_db.services)..where((t) => t.id.equals(match.id)))
              .write(
            ServicesCompanion(
              isDeleted: const Value(false),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.services).insert(
            ServicesCompanion.insert(
              name: name,
              iconKey: Value(iconKey),
              isDeleted: Value(isDeleted),
              createdAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
              ),
              updatedAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
              ),
            ),
          );
      serviceIdMap[oldId] = newId;
      existingServices.add(
        Service(
          id: newId,
          name: name,
          iconKey: iconKey,
          isDeleted: isDeleted,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;
    }

    final existingCenters = await _db.select(_db.serviceCenters).get();
    for (final item in BackupJsonCodec.list(root[BackupKeys.serviceCenters])) {
      final name = BackupJsonCodec.asString(item[BackupKeys.name])?.trim();
      if (name == null || name.isEmpty) continue;
      // Same empty→null rule as ServiceCenterRepositoryImpl create/update.
      final address = OptionalString.normalize(
        BackupJsonCodec.asString(item[BackupKeys.address]),
      );
      final isDeleted = item[BackupKeys.isDeleted] == true;

      // Match by name only (unique index / findNamedCatalogMatch).
      // Active match: keep runtime address (same policy as service iconKey).
      // Soft-deleted → active restore: apply backup address like runtime restore.
      final match = matchNamedCatalogRow(
        rows: existingCenters,
        nameOf: (row) => row.name,
        isDeletedOf: (row) => row.isDeleted,
        rawName: name,
      );
      if (match != null) {
        if (match.isDeleted && !isDeleted) {
          await (_db.update(_db.serviceCenters)
                ..where((t) => t.id.equals(match.id)))
              .write(
            ServiceCentersCompanion(
              isDeleted: const Value(false),
              address: Value(address),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.serviceCenters).insert(
            ServiceCentersCompanion.insert(
              name: name,
              address: Value(address),
              isDeleted: Value(isDeleted),
              createdAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
              ),
              updatedAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
              ),
            ),
          );
      existingCenters.add(
        ServiceCenter(
          id: newId,
          name: name,
          address: address,
          isDeleted: isDeleted,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;
    }

    return serviceIdMap;
  }
}
