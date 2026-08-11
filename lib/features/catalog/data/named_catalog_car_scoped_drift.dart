import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import 'named_catalog_car_scoped_store.dart';

/// Soft-deletable named row shape shared by fuel types and parts.
typedef _NamedRow = ({int id, String name, bool isDeleted});

/// Drift wiring for [FuelTypes] + [FuelTypeCars].
NamedCatalogCarScopedStore buildFuelTypeCarScopedStore(AppDatabase db) {
  return _buildSoftDeleteNamedWithCars(
    loadActiveOrdered: () async {
      final rows = await (db.select(db.fuelTypes)
            ..where((t) => t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();
      return [for (final row in rows) _fuelTypeRow(row)];
    },
    loadAllOrdered: () async {
      final rows = await (db.select(db.fuelTypes)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .get();
      return [for (final row in rows) _fuelTypeRow(row)];
    },
    watchAllOrdered: () {
      return (db.select(db.fuelTypes)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .watch()
          .map((rows) => [for (final row in rows) _fuelTypeRow(row)]);
    },
    loadById: (id) async {
      final row = await (db.select(db.fuelTypes)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return row == null ? null : _fuelTypeRow(row);
    },
    loadAllForMatch: () async {
      final rows = await db.select(db.fuelTypes).get();
      return [for (final row in rows) _fuelTypeRow(row)];
    },
    insertNamed: (name) async {
      final now = DateTime.now();
      return db.into(db.fuelTypes).insert(
            FuelTypesCompanion.insert(
              name: name,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    },
    writeName: (id, name) async {
      await (db.update(db.fuelTypes)..where((t) => t.id.equals(id))).write(
        FuelTypesCompanion(
          name: Value(name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    setDeleted: (id, isDeleted) async {
      await (db.update(db.fuelTypes)..where((t) => t.id.equals(id))).write(
        FuelTypesCompanion(
          isDeleted: Value(isDeleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    hardDelete: (id) async {
      await (db.delete(db.fuelTypes)..where((t) => t.id.equals(id))).go();
    },
    loadAllLinks: () async {
      final rows = await db.select(db.fuelTypeCars).get();
      return [
        for (final row in rows) (itemId: row.fuelTypeId, carId: row.carId),
      ];
    },
    loadCarIdsForItem: (fuelTypeId) async {
      final rows = await (db.select(db.fuelTypeCars)
            ..where((t) => t.fuelTypeId.equals(fuelTypeId)))
          .get();
      return rows.map((row) => row.carId).toList();
    },
    clearLinksForItem: (fuelTypeId) async {
      await (db.delete(db.fuelTypeCars)
            ..where((t) => t.fuelTypeId.equals(fuelTypeId)))
          .go();
    },
    insertLinksForItem: (fuelTypeId, carIds) async {
      await db.batch((batch) {
        batch.insertAll(
          db.fuelTypeCars,
          [
            for (final carId in carIds)
              FuelTypeCarsCompanion.insert(
                fuelTypeId: fuelTypeId,
                carId: carId,
              ),
          ],
        );
      });
    },
    hasReferences: (id) async {
      final fueling = await (db.select(db.fuelings)
            ..where((t) => t.fuelTypeId.equals(id))
            ..limit(1))
          .getSingleOrNull();
      return fueling != null;
    },
  );
}

/// Drift wiring for [Parts] + [PartCars].
NamedCatalogCarScopedStore buildPartCarScopedStore(AppDatabase db) {
  return _buildSoftDeleteNamedWithCars(
    loadActiveOrdered: () async {
      final rows = await (db.select(db.parts)
            ..where((t) => t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();
      return [for (final row in rows) _partRow(row)];
    },
    loadAllOrdered: () async {
      final rows = await (db.select(db.parts)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .get();
      return [for (final row in rows) _partRow(row)];
    },
    watchAllOrdered: () {
      return (db.select(db.parts)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .watch()
          .map((rows) => [for (final row in rows) _partRow(row)]);
    },
    loadById: (id) async {
      final row = await (db.select(db.parts)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return row == null ? null : _partRow(row);
    },
    loadAllForMatch: () async {
      final rows = await db.select(db.parts).get();
      return [for (final row in rows) _partRow(row)];
    },
    insertNamed: (name) async {
      final now = DateTime.now();
      return db.into(db.parts).insert(
            PartsCompanion.insert(
              name: name,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    },
    writeName: (id, name) async {
      await (db.update(db.parts)..where((t) => t.id.equals(id))).write(
        PartsCompanion(
          name: Value(name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    setDeleted: (id, isDeleted) async {
      await (db.update(db.parts)..where((t) => t.id.equals(id))).write(
        PartsCompanion(
          isDeleted: Value(isDeleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    hardDelete: (id) async {
      await (db.delete(db.parts)..where((t) => t.id.equals(id))).go();
    },
    loadAllLinks: () async {
      final rows = await db.select(db.partCars).get();
      return [
        for (final row in rows) (itemId: row.partId, carId: row.carId),
      ];
    },
    loadCarIdsForItem: (partId) async {
      final rows = await (db.select(db.partCars)
            ..where((t) => t.partId.equals(partId)))
          .get();
      return rows.map((row) => row.carId).toList();
    },
    clearLinksForItem: (partId) async {
      await (db.delete(db.partCars)..where((t) => t.partId.equals(partId))).go();
    },
    insertLinksForItem: (partId, carIds) async {
      await db.batch((batch) {
        batch.insertAll(
          db.partCars,
          [
            for (final carId in carIds)
              PartCarsCompanion.insert(
                partId: partId,
                carId: carId,
              ),
          ],
        );
      });
    },
    hasReferences: (id) async {
      final used = await (db.select(db.maintenanceParts)
            ..where((t) => t.partId.equals(id))
            ..limit(1))
          .getSingleOrNull();
      return used != null;
    },
  );
}

_NamedRow _fuelTypeRow(FuelType row) => (
      id: row.id,
      name: row.name,
      isDeleted: row.isDeleted,
    );

_NamedRow _partRow(Part row) => (
      id: row.id,
      name: row.name,
      isDeleted: row.isDeleted,
    );

NamedCatalogCarScopedStore _buildSoftDeleteNamedWithCars({
  required Future<List<_NamedRow>> Function() loadActiveOrdered,
  required Future<List<_NamedRow>> Function() loadAllOrdered,
  required Stream<List<_NamedRow>> Function() watchAllOrdered,
  required Future<_NamedRow?> Function(int id) loadById,
  required Future<List<_NamedRow>> Function() loadAllForMatch,
  required Future<int> Function(String name) insertNamed,
  required Future<void> Function(int id, String name) writeName,
  required Future<void> Function(int id, bool isDeleted) setDeleted,
  required Future<void> Function(int id) hardDelete,
  required Future<List<({int itemId, int carId})>> Function() loadAllLinks,
  required Future<List<int>> Function(int itemId) loadCarIdsForItem,
  required Future<void> Function(int itemId) clearLinksForItem,
  required Future<void> Function(int itemId, List<int> carIds)
      insertLinksForItem,
  required Future<bool> Function(int id) hasReferences,
}) {
  return buildNamedCatalogCarScopedStore<_NamedRow>(
    loadActiveOrderedRows: loadActiveOrdered,
    loadAllRowsOrdered: loadAllOrdered,
    watchAllRowsOrdered: watchAllOrdered,
    loadRowById: loadById,
    loadAllRowsForMatch: loadAllForMatch,
    mapRow: (row) => mapNamedCatalogItem(
      id: row.id,
      name: row.name,
      isDeleted: row.isDeleted,
    ),
    nameOf: (row) => row.name,
    insertNamed: insertNamed,
    writeName: writeName,
    setDeleted: setDeleted,
    hardDelete: hardDelete,
    loadAllLinks: loadAllLinks,
    loadCarIdsForItem: loadCarIdsForItem,
    clearLinksForItem: clearLinksForItem,
    insertLinksForItem: insertLinksForItem,
    hasReferences: hasReferences,
  );
}
