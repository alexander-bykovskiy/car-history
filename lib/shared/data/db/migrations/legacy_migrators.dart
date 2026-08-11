part of '../app_database.dart';

/// Speeds up paged history queries ordered by fueled_at/id per car.
Future<void> _ensureFuelingsListIndex(AppDatabase db) async {
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_fuelings_car_fueled_at_id '
    'ON fuelings (car_id, fueled_at, id)',
  );
}

/// Speeds up paged history queries ordered by serviced_at/id per car.
Future<void> _ensureMaintenancesListIndex(AppDatabase db) async {
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_maintenances_car_serviced_at_id '
    'ON maintenances (car_id, serviced_at, id)',
  );
}

Future<void> _ensureMaintenancesReminderIdColumn(
  AppDatabase db,
  Migrator m,
) async {
  final cols =
      await db.customSelect("PRAGMA table_info('maintenances')").get();
  if (cols.isEmpty) return;
  final hasReminderId = cols.any(
    (row) => row.read<String>('name') == 'reminder_id',
  );
  if (!hasReminderId) {
    await m.addColumn(db.maintenances, db.maintenances.reminderId);
  }
}

/// Adds currency_code snapshots and backfills from [AppDatabase.defaultCurrencyCode].
Future<void> _migrateAddCurrencyCodeColumns(
  AppDatabase db,
  Migrator m,
) async {
  final escaped = db.defaultCurrencyCode.replaceAll("'", "''");

  Future<void> ensureFuelings() async {
    final cols = await db.customSelect("PRAGMA table_info('fuelings')").get();
    if (cols.isEmpty) return;
    final has = cols.any((row) => row.read<String>('name') == 'currency_code');
    if (!has) {
      await m.addColumn(db.fuelings, db.fuelings.currencyCode);
      await db.customStatement(
        "UPDATE fuelings SET currency_code = '$escaped'",
      );
    }
  }

  Future<void> ensureMaintenances() async {
    final cols =
        await db.customSelect("PRAGMA table_info('maintenances')").get();
    if (cols.isEmpty) return;
    final has = cols.any((row) => row.read<String>('name') == 'currency_code');
    if (!has) {
      await m.addColumn(db.maintenances, db.maintenances.currencyCode);
      await db.customStatement(
        "UPDATE maintenances SET currency_code = '$escaped'",
      );
    }
  }

  await ensureFuelings();
  await ensureMaintenances();
}

/// Makes total_amount nullable (SQLite cannot ALTER nullability in place).
Future<void> _migrateMaintenancesTotalAmountNullable(AppDatabase db) async {
  final tableCheck = await db.customSelect(
    "SELECT name FROM sqlite_master "
    "WHERE type = 'table' AND name = 'maintenances'",
  ).get();
  if (tableCheck.isEmpty) {
    final m = Migrator(db);
    await m.createTable(db.maintenances);
    await _ensureMaintenancesListIndex(db);
    return;
  }

  await db.customStatement('''
CREATE TABLE IF NOT EXISTS maintenances_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  car_id INTEGER NOT NULL REFERENCES cars (id) ON DELETE CASCADE,
  service_id INTEGER NULL REFERENCES services (id) ON DELETE SET NULL,
  serviced_at INTEGER NOT NULL,
  total_amount REAL NULL,
  odometer_km REAL NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');
  await db.customStatement('''
INSERT INTO maintenances_new (
  id, car_id, service_id, serviced_at, total_amount, odometer_km,
  created_at, updated_at
)
SELECT
  id, car_id, service_id, serviced_at, total_amount, odometer_km,
  created_at, updated_at
FROM maintenances
''');
  await db.customStatement('DROP TABLE maintenances');
  await db.customStatement(
    'ALTER TABLE maintenances_new RENAME TO maintenances',
  );
  await _ensureMaintenancesListIndex(db);
}

Future<void> _migrateGasStationsToChains(AppDatabase db) async {
  // Table may be missing if a previous partial upgrade already dropped it.
  final tableCheck = await db.customSelect(
    "SELECT name FROM sqlite_master "
    "WHERE type = 'table' AND name = 'gas_stations'",
  ).get();
  if (tableCheck.isEmpty) return;

  final legacy = await db.customSelect(
    'SELECT id, name, address, is_deleted, created_at, updated_at '
    'FROM gas_stations',
  ).get();

  final chainIdByKey = <String, int>{};
  // chainId -> normalized address key ('' for bare) -> new location id
  final locationIdByChainAddress = <int, Map<String, int>>{};
  final locationIdByOldStationId = <int, int>{};

  DateTime readLegacyDate(QueryRow row, String column) {
    final raw = row.read<int>(column);
    // Drift/SQLite legacy rows use unix seconds; some may already be ms.
    final millis = raw > 9999999999 ? raw : raw * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  for (final row in legacy) {
    final oldId = row.read<int>('id');
    final name = row.read<String>('name').trim();
    final addressRaw = row.read<String?>('address')?.trim();
    final address =
        addressRaw == null || addressRaw.isEmpty ? null : addressRaw;
    final isDeleted = row.read<int>('is_deleted') != 0;
    final createdAt = readLegacyDate(row, 'created_at');
    final updatedAt = readLegacyDate(row, 'updated_at');
    final key = name.toLowerCase();

    var chainId = chainIdByKey[key];
    if (chainId == null) {
      chainId = await db.into(db.gasStationChains).insert(
            GasStationChainsCompanion.insert(
              name: name,
              isDeleted: Value(isDeleted),
              createdAt: Value(createdAt),
              updatedAt: Value(updatedAt),
            ),
          );
      chainIdByKey[key] = chainId;
      locationIdByChainAddress[chainId] = {};
    } else if (!isDeleted) {
      await (db.update(db.gasStationChains)
            ..where((t) => t.id.equals(chainId!)))
          .write(
        GasStationChainsCompanion(
          isDeleted: const Value(false),
          updatedAt: Value(updatedAt),
        ),
      );
    }

    final addressKey = address?.toLowerCase() ?? '';
    final existingLocationId = locationIdByChainAddress[chainId]![addressKey];
    if (existingLocationId != null) {
      locationIdByOldStationId[oldId] = existingLocationId;
      if (!isDeleted) {
        await (db.update(db.gasStationLocations)
              ..where((t) => t.id.equals(existingLocationId)))
            .write(
          GasStationLocationsCompanion(
            isDeleted: const Value(false),
            updatedAt: Value(updatedAt),
          ),
        );
      }
      continue;
    }

    final locationId = await db.into(db.gasStationLocations).insert(
          GasStationLocationsCompanion.insert(
            chainId: chainId,
            address: Value(address),
            isDeleted: Value(isDeleted),
            createdAt: Value(createdAt),
            updatedAt: Value(updatedAt),
          ),
        );
    locationIdByChainAddress[chainId]![addressKey] = locationId;
    locationIdByOldStationId[oldId] = locationId;
  }

  for (final entry in locationIdByOldStationId.entries) {
    await db.customStatement(
      'UPDATE fuelings SET gas_station_id = ${entry.value} '
      'WHERE gas_station_id = ${entry.key}',
    );
  }

  await db.customStatement('DROP TABLE IF EXISTS gas_stations');
}

Future<void> _migrateDropIsDefaultColumns(AppDatabase db) async {
  // SQLite: recreate cars without is_default.
  await db.customStatement('''
CREATE TABLE IF NOT EXISTS cars_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  brand_id INTEGER NOT NULL REFERENCES car_brands (id),
  model TEXT NULL,
  year INTEGER NULL,
  photo BLOB NULL,
  color_argb INTEGER NULL,
  created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
  updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER))
)
''');
  await db.customStatement('''
INSERT INTO cars_new (id, brand_id, model, year, photo, color_argb, created_at, updated_at)
SELECT id, brand_id, model, year, photo, color_argb, created_at, updated_at FROM cars
''');
  await db.customStatement('DROP TABLE cars');
  await db.customStatement('ALTER TABLE cars_new RENAME TO cars');

  await db.customStatement('''
CREATE TABLE IF NOT EXISTS fuel_types_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
  updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER))
)
''');
  await db.customStatement('''
INSERT INTO fuel_types_new (id, name, is_deleted, created_at, updated_at)
SELECT id, name, is_deleted, created_at, updated_at FROM fuel_types
''');
  await db.customStatement('DROP TABLE fuel_types');
  await db.customStatement('ALTER TABLE fuel_types_new RENAME TO fuel_types');
}

/// Keeps the earliest brand id per normalized name and re-points cars to it.
Future<void> _dedupeCarBrands(AppDatabase db) async {
  final all = await db.select(db.carBrands).get();
  final groups = <String, List<CarBrand>>{};
  for (final brand in all) {
    final key = brand.name.trim().toLowerCase();
    groups.putIfAbsent(key, () => []).add(brand);
  }

  for (final group in groups.values) {
    if (group.length < 2) continue;
    group.sort((a, b) => a.id.compareTo(b.id));
    final keep = group.first;
    for (final duplicate in group.skip(1)) {
      await (db.update(db.cars)..where((t) => t.brandId.equals(duplicate.id)))
          .write(CarsCompanion(brandId: Value(keep.id)));
      await (db.delete(db.carBrands)..where((t) => t.id.equals(duplicate.id)))
          .go();
    }
  }
}

/// Soft-deletes active named-catalog duplicates after re-pointing FKs.
Future<void> _dedupeActiveNamedCatalogs(AppDatabase db) async {
  await _dedupeActiveNamedRows(
    db,
    table: 'fuel_types',
    repoint: (keepId, dupId) async {
      await db.customStatement(
        'UPDATE fuelings SET fuel_type_id = $keepId '
        'WHERE fuel_type_id = $dupId',
      );
      await db.customStatement(
        'INSERT OR IGNORE INTO fuel_type_cars (fuel_type_id, car_id) '
        'SELECT $keepId, car_id FROM fuel_type_cars WHERE fuel_type_id = $dupId',
      );
      await db.customStatement(
        'DELETE FROM fuel_type_cars WHERE fuel_type_id = $dupId',
      );
    },
  );
  await _dedupeActiveNamedRows(
    db,
    table: 'parts',
    repoint: (keepId, dupId) async {
      await db.customStatement(
        'UPDATE maintenance_parts SET part_id = $keepId '
        'WHERE part_id = $dupId',
      );
      await db.customStatement(
        'INSERT OR IGNORE INTO part_cars (part_id, car_id) '
        'SELECT $keepId, car_id FROM part_cars WHERE part_id = $dupId',
      );
      await db.customStatement(
        'DELETE FROM part_cars WHERE part_id = $dupId',
      );
    },
  );
  await _dedupeActiveNamedRows(
    db,
    table: 'part_units',
    repoint: (keepId, dupId) async {
      await db.customStatement(
        'UPDATE maintenance_parts SET unit_id = $keepId '
        'WHERE unit_id = $dupId',
      );
    },
  );
  await _dedupeActiveNamedRows(
    db,
    table: 'services',
    repoint: (keepId, dupId) async {
      await db.customStatement(
        'UPDATE maintenances SET service_id = $keepId '
        'WHERE service_id = $dupId',
      );
    },
  );
  await _dedupeActiveNamedRows(
    db,
    table: 'service_centers',
    repoint: (keepId, dupId) async {},
  );
  await _dedupeActiveNamedRows(
    db,
    table: 'gas_station_chains',
    repoint: (keepId, dupId) async {
      await db.customStatement(
        'UPDATE gas_station_locations SET chain_id = $keepId '
        'WHERE chain_id = $dupId',
      );
    },
  );
  await _dedupeActiveGasStationLocations(db);
}

Future<void> _dedupeActiveNamedRows(
  AppDatabase db, {
  required String table,
  required Future<void> Function(int keepId, int dupId) repoint,
}) async {
  final rows = await db.customSelect(
    'SELECT id, name FROM $table WHERE is_deleted = 0',
  ).get();
  final groups = <String, List<int>>{};
  for (final row in rows) {
    final key = row.read<String>('name').trim().toLowerCase();
    groups.putIfAbsent(key, () => []).add(row.read<int>('id'));
  }

  for (final ids in groups.values) {
    if (ids.length < 2) continue;
    ids.sort();
    final keepId = ids.first;
    for (final dupId in ids.skip(1)) {
      await repoint(keepId, dupId);
      await db.customStatement(
        'UPDATE $table SET is_deleted = 1, '
        "updated_at = CAST(strftime('%s','now') AS INTEGER) "
        'WHERE id = $dupId',
      );
    }
  }
}

Future<void> _dedupeActiveGasStationLocations(AppDatabase db) async {
  final rows = await db.customSelect(
    'SELECT id, chain_id, address FROM gas_station_locations '
    'WHERE is_deleted = 0',
  ).get();
  final groups = <String, List<int>>{};
  for (final row in rows) {
    final chainId = row.read<int>('chain_id');
    final address = (row.read<String?>('address') ?? '').trim().toLowerCase();
    final key = '$chainId|$address';
    groups.putIfAbsent(key, () => []).add(row.read<int>('id'));
  }

  for (final ids in groups.values) {
    if (ids.length < 2) continue;
    ids.sort();
    final keepId = ids.first;
    for (final dupId in ids.skip(1)) {
      await db.customStatement(
        'UPDATE fuelings SET gas_station_id = $keepId '
        'WHERE gas_station_id = $dupId',
      );
      await db.customStatement(
        'UPDATE gas_station_locations SET is_deleted = 1, '
        "updated_at = CAST(strftime('%s','now') AS INTEGER) "
        'WHERE id = $dupId',
      );
    }
  }
}

Future<void> _ensureActiveNamedCatalogUniqueIndexes(AppDatabase db) async {
  const namedTables = <String>[
    'fuel_types',
    'parts',
    'part_units',
    'services',
    'service_centers',
    'gas_station_chains',
  ];
  for (final table in namedTables) {
    await db.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_${table}_active_name '
      'ON $table (lower(trim(name))) WHERE is_deleted = 0',
    );
  }
  await db.customStatement(
    'CREATE UNIQUE INDEX IF NOT EXISTS '
    'idx_gas_station_locations_active_chain_address '
    'ON gas_station_locations (chain_id, lower(trim(coalesce(address, \'\')))) '
    'WHERE is_deleted = 0',
  );
}
