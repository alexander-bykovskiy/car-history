import 'package:car_history/shared/data/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('in-memory database opens at current schemaVersion', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final version = await db
        .customSelect('PRAGMA user_version')
        .getSingle()
        .then((row) => row.read<int>('user_version'));
    expect(version, db.schemaVersion);
  });

  test('current schema has core event tables', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    Future<bool> hasTable(String name) async {
      final rows = await db.customSelect(
        'SELECT name FROM sqlite_master WHERE type = ? AND name = ?',
        variables: [
          Variable.withString('table'),
          Variable.withString(name),
        ],
      ).get();
      return rows.isNotEmpty;
    }

    expect(await hasTable('cars'), isTrue);
    expect(await hasTable('fuelings'), isTrue);
    expect(await hasTable('maintenances'), isTrue);
    expect(await hasTable('reminders'), isTrue);
  });

  test('active named catalog unique indexes exist', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    Future<bool> hasIndex(String name) async {
      final rows = await db.customSelect(
        'SELECT name FROM sqlite_master WHERE type = ? AND name = ?',
        variables: [
          Variable.withString('index'),
          Variable.withString(name),
        ],
      ).get();
      return rows.isNotEmpty;
    }

    expect(await hasIndex('idx_fuel_types_active_name'), isTrue);
    expect(await hasIndex('idx_gas_station_chains_active_name'), isTrue);
    expect(
      await hasIndex('idx_gas_station_locations_active_chain_address'),
      isTrue,
    );
  });

  test('active fuel type duplicate name is rejected by unique index', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    await db.into(db.fuelTypes).insert(
          FuelTypesCompanion.insert(
            name: 'UniquePetrol',
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );

    await expectLater(
      () => db.into(db.fuelTypes).insert(
            FuelTypesCompanion.insert(
              name: 'uniquepetrol',
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });
}
