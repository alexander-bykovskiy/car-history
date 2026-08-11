import 'package:drift/drift.dart';

import '../../../../shared/data/db/app_database.dart';
import 'backup_import_gas_stations.dart';
import 'backup_import_models.dart';
import 'backup_import_services_and_centers.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';
import 'import_coordinator.dart';

/// Merges named catalogs, gas stations, and car-restricted link tables.
class BackupImportNamedCatalogs {
  BackupImportNamedCatalogs(this._db);

  final AppDatabase _db;

  Future<BackupCatalogIdMaps> import(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupImportCounters counters,
  }) async {
    final fuelTypeIdMap = await _mergeNamedCatalog(
      items: BackupJsonCodec.list(root[BackupKeys.fuelTypes]),
      selectAll: () => _db.select(_db.fuelTypes).get(),
      nameOf: (FuelType row) => row.name,
      idOf: (FuelType row) => row.id,
      isDeletedOf: (FuelType row) => row.isDeleted,
      insert: (name, isDeleted, createdAt, updatedAt) {
        return _db.into(_db.fuelTypes).insert(
              FuelTypesCompanion.insert(
                name: name,
                isDeleted: Value(isDeleted),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
              ),
            );
      },
      undelete: (id) async {
        await (_db.update(_db.fuelTypes)..where((t) => t.id.equals(id))).write(
          FuelTypesCompanion(
            isDeleted: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
      counters: counters,
    );

    final partIdMap = await _mergeNamedCatalog(
      items: BackupJsonCodec.list(root[BackupKeys.parts]),
      selectAll: () => _db.select(_db.parts).get(),
      nameOf: (Part row) => row.name,
      idOf: (Part row) => row.id,
      isDeletedOf: (Part row) => row.isDeleted,
      insert: (name, isDeleted, createdAt, updatedAt) {
        return _db.into(_db.parts).insert(
              PartsCompanion.insert(
                name: name,
                isDeleted: Value(isDeleted),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
              ),
            );
      },
      undelete: (id) async {
        await (_db.update(_db.parts)..where((t) => t.id.equals(id))).write(
          PartsCompanion(
            isDeleted: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
      counters: counters,
    );

    final partUnitIdMap = await _mergeNamedCatalog(
      items: BackupJsonCodec.list(root[BackupKeys.partUnits]),
      selectAll: () => _db.select(_db.partUnits).get(),
      nameOf: (PartUnit row) => row.name,
      idOf: (PartUnit row) => row.id,
      isDeletedOf: (PartUnit row) => row.isDeleted,
      insert: (name, isDeleted, createdAt, updatedAt) {
        return _db.into(_db.partUnits).insert(
              PartUnitsCompanion.insert(
                name: name,
                isDeleted: Value(isDeleted),
                createdAt: Value(createdAt),
                updatedAt: Value(updatedAt),
              ),
            );
      },
      undelete: (id) async {
        await (_db.update(_db.partUnits)..where((t) => t.id.equals(id))).write(
          PartUnitsCompanion(
            isDeleted: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
      counters: counters,
    );

    final serviceIdMap = await BackupImportServicesAndCenters(_db).import(
      root,
      counters: counters,
    );

    final locationIdMap = await BackupImportGasStations(_db).import(
      root,
      counters: counters,
    );

    await _importCarLinks(
      items: BackupJsonCodec.list(root[BackupKeys.fuelTypeCars]),
      existingKeys: {
        for (final row in await _db.select(_db.fuelTypeCars).get())
          '${row.fuelTypeId}:${row.carId}',
      },
      catalogIdMap: fuelTypeIdMap,
      carIdMap: carIdMap,
      catalogKey: BackupKeys.fuelTypeId,
      insert: (catalogId, carId) {
        return _db.into(_db.fuelTypeCars).insert(
              FuelTypeCarsCompanion.insert(
                fuelTypeId: catalogId,
                carId: carId,
              ),
            );
      },
      counters: counters,
    );

    await _importCarLinks(
      items: BackupJsonCodec.list(root[BackupKeys.partCars]),
      existingKeys: {
        for (final row in await _db.select(_db.partCars).get())
          '${row.partId}:${row.carId}',
      },
      catalogIdMap: partIdMap,
      carIdMap: carIdMap,
      catalogKey: BackupKeys.partId,
      insert: (catalogId, carId) {
        return _db.into(_db.partCars).insert(
              PartCarsCompanion.insert(partId: catalogId, carId: carId),
            );
      },
      counters: counters,
    );

    return BackupCatalogIdMaps(
      fuelTypeIdMap: fuelTypeIdMap,
      partIdMap: partIdMap,
      partUnitIdMap: partUnitIdMap,
      serviceIdMap: serviceIdMap,
      locationIdMap: locationIdMap,
    );
  }

  Future<Map<int, int>> _mergeNamedCatalog<T>({
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
    required BackupImportCounters counters,
  }) {
    return ImportCoordinator.mergeNamedCatalog(
      items: items,
      selectAll: selectAll,
      nameOf: nameOf,
      idOf: idOf,
      isDeletedOf: isDeletedOf,
      insert: insert,
      undelete: undelete,
      onAdded: () => counters.added++,
      onSkipped: () => counters.skipped++,
    );
  }

  Future<void> _importCarLinks({
    required List<Map<String, dynamic>> items,
    required Set<String> existingKeys,
    required Map<int, int> catalogIdMap,
    required Map<int, int> carIdMap,
    required String catalogKey,
    required Future<void> Function(int catalogId, int carId) insert,
    required BackupImportCounters counters,
  }) async {
    for (final item in items) {
      final catalog =
          catalogIdMap[BackupJsonCodec.asInt(item[catalogKey]) ?? -1];
      final car = carIdMap[BackupJsonCodec.asInt(item[BackupKeys.carId]) ?? -1];
      if (catalog == null || car == null) continue;
      final key = '$catalog:$car';
      if (existingKeys.contains(key)) {
        counters.skipped++;
        continue;
      }
      await insert(catalog, car);
      existingKeys.add(key);
      counters.added++;
    }
  }
}
