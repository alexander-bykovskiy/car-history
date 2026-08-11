import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../domain/entities/named_catalog_item.dart';
import '../domain/entities/named_place.dart';
import '../domain/entities/service_catalog_item.dart';
import 'named_catalog_simple_store.dart';

NamedCatalogItem _mapPartUnit(PartUnit row) {
  return NamedCatalogItem(
    id: row.id,
    name: row.name,
    isDeleted: row.isDeleted,
  );
}

ServiceCatalogItem _mapService(Service row) {
  return ServiceCatalogItem(
    id: row.id,
    name: row.name,
    isDeleted: row.isDeleted,
    iconKey: row.iconKey,
  );
}

PlaceCatalogItem _mapServiceCenter(ServiceCenter row) {
  return PlaceCatalogItem(
    id: row.id,
    name: row.name,
    isDeleted: row.isDeleted,
    address: row.address,
  );
}

NamedCatalogItem _serviceAsNamed(ServiceCatalogItem item) {
  return NamedCatalogItem(
    id: item.id,
    name: item.name,
    isDeleted: item.isDeleted,
  );
}

NamedCatalogItem _placeAsNamed(PlaceCatalogItem item) {
  return NamedCatalogItem(
    id: item.id,
    name: item.name,
    isDeleted: item.isDeleted,
  );
}

/// Drift wiring for [PartUnits].
NamedCatalogSimpleStore<NamedCatalogItem> buildPartUnitSimpleStore(
  AppDatabase db,
) {
  return buildNamedCatalogSimpleStore<NamedCatalogItem, PartUnit>(
    watchAllRowsOrdered: () {
      return (db.select(db.partUnits)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .watch();
    },
    listAllRowsOrdered: () {
      return (db.select(db.partUnits)
            ..where((t) => t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();
    },
    loadRowById: (id) {
      return (db.select(db.partUnits)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    },
    loadAllRowsForMatch: () => db.select(db.partUnits).get(),
    mapRow: _mapPartUnit,
    asNamed: (item) => item,
    nameOf: (row) => row.name,
    isDeletedOf: (row) => row.isDeleted,
    insertNamed: (name) async {
      final now = DateTime.now();
      return db.into(db.partUnits).insert(
            PartUnitsCompanion.insert(
              name: name,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    },
    writeName: (id, name) async {
      await (db.update(db.partUnits)..where((t) => t.id.equals(id))).write(
        PartUnitsCompanion(
          name: Value(name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    setDeleted: (id, isDeleted) async {
      await (db.update(db.partUnits)..where((t) => t.id.equals(id))).write(
        PartUnitsCompanion(
          isDeleted: Value(isDeleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    hardDelete: (id) async {
      await (db.delete(db.partUnits)..where((t) => t.id.equals(id))).go();
    },
    hasReferences: (id) async {
      final used = await (db.select(db.maintenanceParts)
            ..where((t) => t.unitId.equals(id))
            ..limit(1))
          .getSingleOrNull();
      return used != null;
    },
  );
}

/// Drift wiring for [Services] (iconKey stays on repository write overrides).
NamedCatalogSimpleStore<ServiceCatalogItem> buildServiceSimpleStore(
  AppDatabase db,
) {
  return buildNamedCatalogSimpleStore<ServiceCatalogItem, Service>(
    watchAllRowsOrdered: () {
      return (db.select(db.services)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .watch();
    },
    listAllRowsOrdered: () {
      return (db.select(db.services)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .get();
    },
    loadRowById: (id) {
      return (db.select(db.services)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    },
    loadAllRowsForMatch: () => db.select(db.services).get(),
    mapRow: _mapService,
    asNamed: _serviceAsNamed,
    nameOf: (row) => row.name,
    isDeletedOf: (row) => row.isDeleted,
    insertNamed: (name) async {
      final now = DateTime.now();
      return db.into(db.services).insert(
            ServicesCompanion.insert(
              name: name,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    },
    writeName: (id, name) async {
      await (db.update(db.services)..where((t) => t.id.equals(id))).write(
        ServicesCompanion(
          name: Value(name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    setDeleted: (id, isDeleted) async {
      await (db.update(db.services)..where((t) => t.id.equals(id))).write(
        ServicesCompanion(
          isDeleted: Value(isDeleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    hardDelete: (id) async {
      await (db.delete(db.services)..where((t) => t.id.equals(id))).go();
    },
    hasReferences: (id) async {
      final maintenance = await (db.select(db.maintenances)
            ..where((t) => t.serviceId.equals(id))
            ..limit(1))
          .getSingleOrNull();
      return maintenance != null;
    },
  );
}

/// Drift wiring for [ServiceCenters].
///
/// Address must be supplied via repository create/update/restore overrides;
/// [requireWriteOverrides] makes name-only store paths throw.
NamedCatalogSimpleStore<PlaceCatalogItem> buildServiceCenterSimpleStore(
  AppDatabase db,
) {
  return buildNamedCatalogSimpleStore<PlaceCatalogItem, ServiceCenter>(
    watchAllRowsOrdered: () {
      return (db.select(db.serviceCenters)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .watch();
    },
    listAllRowsOrdered: () {
      return (db.select(db.serviceCenters)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isDeleted),
              (t) => OrderingTerm(expression: t.name),
            ]))
          .get();
    },
    loadRowById: (id) {
      return (db.select(db.serviceCenters)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    },
    loadAllRowsForMatch: () => db.select(db.serviceCenters).get(),
    mapRow: _mapServiceCenter,
    asNamed: _placeAsNamed,
    nameOf: (row) => row.name,
    isDeletedOf: (row) => row.isDeleted,
    // Unreachable while requireWriteOverrides is true; kept for factory shape.
    insertNamed: (_) async {
      throw StateError('ServiceCenter create must pass insertNamed with address');
    },
    writeName: (_, _) async {
      throw StateError('ServiceCenter update must pass writeName with address');
    },
    setDeleted: (id, isDeleted) async {
      await (db.update(db.serviceCenters)..where((t) => t.id.equals(id))).write(
        ServiceCentersCompanion(
          isDeleted: Value(isDeleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    hardDelete: (id) async {
      await (db.delete(db.serviceCenters)..where((t) => t.id.equals(id))).go();
    },
    // Service centers are not referenced by events (no FK). Always hard-delete.
    // Soft-deleted rows appear only via backup import; UI restore covers that.
    hasReferences: (_) async => false,
    requireWriteOverrides: true,
  );
}
