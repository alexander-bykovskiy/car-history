import 'package:drift/drift.dart';

import '../../../../core/gas_station_address.dart';
import '../../../../shared/data/db/app_database.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';
import 'import_coordinator.dart';

/// Merges gas-station chains and locations from a backup root.
class BackupImportGasStations {
  BackupImportGasStations(this._db);

  final AppDatabase _db;

  /// Returns old→new location id map (chains are remapped only internally).
  Future<Map<int, int>> import(
    Map<String, dynamic> root, {
    required BackupImportCounters counters,
  }) async {
    final chainIdMap = await ImportCoordinator.mergeNamedCatalog(
      items: BackupJsonCodec.list(root[BackupKeys.gasStationChains]),
      selectAll: () => _db.select(_db.gasStationChains).get(),
      nameOf: (GasStationChain row) => row.name,
      idOf: (GasStationChain row) => row.id,
      isDeletedOf: (GasStationChain row) => row.isDeleted,
      insert: (name, isDeleted, createdAt, updatedAt) {
        return _db.into(_db.gasStationChains).insert(
              GasStationChainsCompanion.insert(
                name: name,
                isDeleted: Value(isDeleted),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
              ),
            );
      },
      undelete: (id) async {
        await (_db.update(_db.gasStationChains)..where((t) => t.id.equals(id)))
            .write(
          GasStationChainsCompanion(
            isDeleted: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
      onAdded: () => counters.added++,
      onSkipped: () => counters.skipped++,
    );

    final locationIdMap = <int, int>{};
    final existingLocations =
        await _db.select(_db.gasStationLocations).get();
    for (final item
        in BackupJsonCodec.list(root[BackupKeys.gasStationLocations])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final oldChainId = BackupJsonCodec.asInt(item[BackupKeys.chainId]);
      if (oldId == null || oldChainId == null) continue;
      final chainId = chainIdMap[oldChainId];
      if (chainId == null) continue;
      final address = GasStationAddress.normalize(
        BackupJsonCodec.asString(item[BackupKeys.address]),
      );
      final isDeleted = item[BackupKeys.isDeleted] == true;

      final match = GasStationAddress.findLocationIn(
        rows: existingLocations,
        chainIdOf: (row) => row.chainId,
        addressOf: (row) => row.address,
        isDeletedOf: (row) => row.isDeleted,
        chainId: chainId,
        address: address,
      );
      if (match != null) {
        locationIdMap[oldId] = match.id;
        if (match.isDeleted && !isDeleted) {
          await (_db.update(_db.gasStationLocations)
                ..where((t) => t.id.equals(match.id)))
              .write(
            GasStationLocationsCompanion(
              isDeleted: const Value(false),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.gasStationLocations).insert(
            GasStationLocationsCompanion.insert(
              chainId: chainId,
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
      locationIdMap[oldId] = newId;
      existingLocations.add(
        GasStationLocation(
          id: newId,
          chainId: chainId,
          address: address,
          isDeleted: isDeleted,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;
    }

    return locationIdMap;
  }
}
