part of '../app_database.dart';

Future<void> _runOnUpgrade(AppDatabase db, Migrator m, int from, int to) async {
  if (from < 2) {
    await m.deleteTable(db.fuelTypes.actualTableName);
    await m.createTable(db.fuelTypes);
    await _seedFuelTypes(db);
  }
  if (from < 3) {
    await m.createTable(db.carBrands);
    await m.createTable(db.cars);
    await _seedCarBrands(db);
  }
  if (from < 4) {
    // Legacy: is_default columns — removed in v6.
    await db.customStatement(
      'ALTER TABLE fuel_types ADD COLUMN is_default INTEGER '
      'NOT NULL DEFAULT 0',
    );
    await db.customStatement(
      'ALTER TABLE cars ADD COLUMN is_default INTEGER '
      'NOT NULL DEFAULT 0',
    );
  }
  if (from < 5) {
    await _dedupeCarBrands(db);
    await db.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_car_brands_name '
      'ON car_brands (name COLLATE NOCASE)',
    );
  }
  if (from < 6) {
    await m.createTable(db.fuelTypeCars);
    await _migrateDropIsDefaultColumns(db);
    await _seedPlaceholderCar(db);
  }
  if (from < 7) {
    await m.createTable(db.parts);
    await m.createTable(db.partCars);
  }
  if (from < 8) {
    await m.createTable(db.services);
  }
  if (from < 9) {
    await m.createTable(db.serviceCenters);
    // Legacy flat gas_stations — replaced by chains/locations in v14.
    await db.customStatement('''
CREATE TABLE IF NOT EXISTS gas_stations (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  address TEXT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
  updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER))
)
''');
  }
  if (from < 10) {
    await m.createTable(db.fuelings);
  }
  if (from < 11) {
    await m.addColumn(db.fuelings, db.fuelings.odometerKm);
  }
  if (from < 12) {
    await m.addColumn(db.fuelings, db.fuelings.fuelTypeId);
  }
  if (from < 13) {
    await db.customStatement(
      'ALTER TABLE fuelings ADD COLUMN gas_station_id INTEGER NULL',
    );
  }
  if (from < 14) {
    await m.createTable(db.gasStationChains);
    await m.createTable(db.gasStationLocations);
    await _migrateGasStationsToChains(db);
  }
  if (from < 15) {
    await _ensureFuelingsListIndex(db);
  }
  if (from < 22) {
    await m.createTable(db.reminders);
  }
  if (from < 16) {
    await m.createTable(db.maintenances);
    await _ensureMaintenancesListIndex(db);
  }
  if (from < 17) {
    await _migrateMaintenancesTotalAmountNullable(db);
  }
  if (from < 18) {
    await m.createTable(db.maintenanceParts);
  }
  if (from < 19) {
    await m.createTable(db.partUnits);
    await _seedPartUnits(db);
    if (from >= 18) {
      await m.addColumn(db.maintenanceParts, db.maintenanceParts.quantity);
      await m.addColumn(db.maintenanceParts, db.maintenanceParts.unitId);
    }
  }
  if (from < 20) {
    await m.addColumn(db.services, db.services.iconKey);
  }
  if (from < 21) {
    await m.addColumn(db.maintenanceParts, db.maintenanceParts.comment);
  }
  if (from < 23) {
    await _ensureMaintenancesReminderIdColumn(db, m);
  }
  if (from < 24) {
    await _migrateAddCurrencyCodeColumns(db, m);
  }
  if (from < 25) {
    await _dedupeActiveNamedCatalogs(db);
    await _ensureActiveNamedCatalogUniqueIndexes(db);
  }
}
