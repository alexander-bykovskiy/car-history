import 'dart:convert';
import 'dart:typed_data';

import 'package:car_history/core/car_limits.dart';
import 'package:car_history/core/car_photo_limits.dart';
import 'package:car_history/features/settings/data/backup/backup_importer.dart';
import 'package:car_history/features/settings/data/backup/backup_keys.dart';
import 'package:car_history/features/settings/data/currency_preferences.dart';
import 'package:car_history/features/settings/data/unit_preferences.dart';
import 'package:car_history/features/settings/domain/repositories/backup_repository.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late BackupImporter importer;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = await openInMemoryDatabase();
    importer = BackupImporter(
      db,
      PrefsUnitPreferencesStore(),
      PrefsCurrencyPreferencesStore(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  Map<String, dynamic> emptyCatalogRoot({
    List<Map<String, dynamic>> services = const [],
    List<Map<String, dynamic>> serviceCenters = const [],
    List<Map<String, dynamic>> gasStationChains = const [],
    List<Map<String, dynamic>> gasStationLocations = const [],
    List<Map<String, dynamic>> carBrands = const [],
    List<Map<String, dynamic>> cars = const [],
    List<Map<String, dynamic>> fuelTypes = const [],
    List<Map<String, dynamic>> fuelTypeCars = const [],
    List<Map<String, dynamic>> parts = const [],
    List<Map<String, dynamic>> partCars = const [],
    List<Map<String, dynamic>> reminders = const [],
    List<Map<String, dynamic>> fuelings = const [],
    List<Map<String, dynamic>> maintenances = const [],
    List<Map<String, dynamic>> maintenanceParts = const [],
  }) {
    return {
      BackupKeys.version: BackupImporter.currentVersion,
      BackupKeys.carBrands: carBrands,
      BackupKeys.cars: cars,
      BackupKeys.fuelTypes: fuelTypes,
      BackupKeys.fuelTypeCars: fuelTypeCars,
      BackupKeys.parts: parts,
      BackupKeys.partCars: partCars,
      BackupKeys.partUnits: <Map<String, dynamic>>[],
      BackupKeys.services: services,
      BackupKeys.serviceCenters: serviceCenters,
      BackupKeys.gasStationChains: gasStationChains,
      BackupKeys.gasStationLocations: gasStationLocations,
      BackupKeys.reminders: reminders,
      BackupKeys.fuelings: fuelings,
      BackupKeys.maintenances: maintenances,
      BackupKeys.maintenanceParts: maintenanceParts,
      BackupKeys.preferences: {
        BackupKeys.fuelVolumeUnit: 'liters',
        BackupKeys.distanceUnit: 'kilometers',
        BackupKeys.currencyCode: 'EUR',
        BackupKeys.currencyCodes: ['EUR', 'USD'],
      },
    };
  }

  test('BackupImporter merges a minimal valid map', () async {
    final beforeCars = await db.select(db.cars).get();
    expect(beforeCars, isNotEmpty);

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9001,
            BackupKeys.name: 'ImportBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9002,
            BackupKeys.brandId: 9001,
            BackupKeys.model: 'ImportModel',
            BackupKeys.year: 2020,
            BackupKeys.colorArgb: 0xFF000000,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final brands = await db.select(db.carBrands).get();
    expect(brands.any((b) => b.name == 'ImportBrand'), isTrue);
    final cars = await db.select(db.cars).get();
    expect(cars.any((c) => c.model == 'ImportModel'), isTrue);
  });

  test('BackupImporter rejects bad version', () async {
    final result = await importer.importMap({BackupKeys.version: 99});
    expect(result.ok, isFalse);
    expect(result.failure, BackupFailure.unsupportedVersion);
  });

  test('merges service by name even when iconKey differs', () async {
    final now = DateTime.utc(2024, 1, 1);
    final existingId = await db.into(db.services).insert(
          ServicesCompanion.insert(
            name: 'Oil',
            iconKey: const Value('oil_a'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        services: [
          {
            BackupKeys.id: 501,
            BackupKeys.name: 'Oil',
            BackupKeys.iconKey: 'oil_b',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final rows = await db.select(db.services).get();
    final oils = rows.where((r) => r.name.trim().toLowerCase() == 'oil');
    expect(oils.length, 1);
    expect(oils.single.id, existingId);
    expect(oils.single.iconKey, 'oil_a');
  });

  test('merges service center by name even when address differs', () async {
    final now = DateTime.utc(2024, 1, 1);
    await db.into(db.serviceCenters).insert(
          ServiceCentersCompanion.insert(
            name: 'QuickFix',
            address: const Value('Old Street 1'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        serviceCenters: [
          {
            BackupKeys.name: 'QuickFix',
            BackupKeys.address: 'New Street 99',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final rows = await db.select(db.serviceCenters).get();
    final matches =
        rows.where((r) => r.name.trim().toLowerCase() == 'quickfix');
    expect(matches.length, 1);
    expect(matches.single.address, 'Old Street 1');
  });

  test('restores soft-deleted service center with backup address', () async {
    final now = DateTime.utc(2024, 1, 1);
    await db.into(db.serviceCenters).insert(
          ServiceCentersCompanion.insert(
            name: 'SoftFix',
            address: const Value('Old Soft St'),
            isDeleted: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        serviceCenters: [
          {
            BackupKeys.name: 'SoftFix',
            BackupKeys.address: '  New Soft St  ',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final rows = await db.select(db.serviceCenters).get();
    final matches =
        rows.where((r) => r.name.trim().toLowerCase() == 'softfix');
    expect(matches.length, 1);
    expect(matches.single.isDeleted, isFalse);
    expect(matches.single.address, 'New Soft St');
  });

  test('imports fuelTypeCars and partCars with remapped catalog/car ids',
      () async {
    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9401,
            BackupKeys.name: 'LinkBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9402,
            BackupKeys.brandId: 9401,
            BackupKeys.model: 'LinkCar',
            BackupKeys.year: 2018,
            BackupKeys.colorArgb: 0xFFABCDEF,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelTypes: [
          {
            BackupKeys.id: 9501,
            BackupKeys.name: 'ImportPetrolLink',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelTypeCars: [
          {
            BackupKeys.fuelTypeId: 9501,
            BackupKeys.carId: 9402,
          },
        ],
        parts: [
          {
            BackupKeys.id: 9601,
            BackupKeys.name: 'ImportFilterLink',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        partCars: [
          {
            BackupKeys.partId: 9601,
            BackupKeys.carId: 9402,
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final car = await (db.select(db.cars)
          ..where((t) => t.model.equals('LinkCar')))
        .getSingle();
    final fuelType = await (db.select(db.fuelTypes)
          ..where((t) => t.name.equals('ImportPetrolLink')))
        .getSingle();
    final part = await (db.select(db.parts)
          ..where((t) => t.name.equals('ImportFilterLink')))
        .getSingle();

    final fuelLinks = await (db.select(db.fuelTypeCars)
          ..where((t) => t.fuelTypeId.equals(fuelType.id)))
        .get();
    expect(
      fuelLinks.where((row) => row.carId == car.id),
      hasLength(1),
    );

    final partLinks = await (db.select(db.partCars)
          ..where((t) => t.partId.equals(part.id)))
        .get();
    expect(
      partLinks.where((row) => row.carId == car.id),
      hasLength(1),
    );

    // Second import must skip already-linked pairs (no duplicates).
    final again = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9401,
            BackupKeys.name: 'LinkBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9402,
            BackupKeys.brandId: 9401,
            BackupKeys.model: 'LinkCar',
            BackupKeys.year: 2018,
            BackupKeys.colorArgb: 0xFFABCDEF,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelTypes: [
          {
            BackupKeys.id: 9501,
            BackupKeys.name: 'ImportPetrolLink',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelTypeCars: [
          {
            BackupKeys.fuelTypeId: 9501,
            BackupKeys.carId: 9402,
          },
        ],
        parts: [
          {
            BackupKeys.id: 9601,
            BackupKeys.name: 'ImportFilterLink',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        partCars: [
          {
            BackupKeys.partId: 9601,
            BackupKeys.carId: 9402,
          },
        ],
      ),
    );
    expect(again.ok, isTrue);

    expect(
      await (db.select(db.fuelTypeCars)
            ..where((t) => t.fuelTypeId.equals(fuelType.id)))
          .get(),
      hasLength(1),
    );
    expect(
      await (db.select(db.partCars)..where((t) => t.partId.equals(part.id)))
          .get(),
      hasLength(1),
    );
  });

  test('merges gas station location by case-insensitive address', () async {
    final now = DateTime.utc(2024, 1, 1);
    final chainId = await db.into(db.gasStationChains).insert(
          GasStationChainsCompanion.insert(
            name: 'Shell',
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final locationId = await db.into(db.gasStationLocations).insert(
          GasStationLocationsCompanion.insert(
            chainId: chainId,
            address: const Value('Main St'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        gasStationChains: [
          {
            BackupKeys.id: 701,
            BackupKeys.name: 'Shell',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        gasStationLocations: [
          {
            BackupKeys.id: 702,
            BackupKeys.chainId: 701,
            BackupKeys.address: 'main st',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final locations = await (db.select(db.gasStationLocations)
          ..where((t) => t.chainId.equals(chainId)))
        .get();
    expect(locations.length, 1);
    expect(locations.single.id, locationId);
    expect(locations.single.address, 'Main St');
  });

  test('normalizes blank gas station location address on import insert', () async {
    final result = await importer.importMap(
      emptyCatalogRoot(
        gasStationChains: [
          {
            BackupKeys.id: 801,
            BackupKeys.name: 'BlankAddr',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        gasStationLocations: [
          {
            BackupKeys.id: 802,
            BackupKeys.chainId: 801,
            BackupKeys.address: '   ',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final locations = await db.select(db.gasStationLocations).get();
    expect(locations, hasLength(1));
    expect(locations.single.address, isNull);
  });

  test('normalizes blank service center address on import insert', () async {
    final result = await importer.importMap(
      emptyCatalogRoot(
        serviceCenters: [
          {
            BackupKeys.name: 'BlankCenter',
            BackupKeys.address: '   ',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final centers = await db.select(db.serviceCenters).get();
    final imported = centers.where((c) => c.name == 'BlankCenter');
    expect(imported.length, 1);
    expect(imported.single.address, isNull);
  });

  test('strips oversized car photo on import', () async {
    final oversized = Uint8List(kMaxCarPhotoBytes + 1);
    final photoBase64 = base64Encode(oversized);

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 8001,
            BackupKeys.name: 'PhotoBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 8002,
            BackupKeys.brandId: 8001,
            BackupKeys.model: 'PhotoModel',
            BackupKeys.year: 2021,
            BackupKeys.colorArgb: 0xFF112233,
            BackupKeys.photoBase64: photoBase64,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.failure, isNull);

    final cars = await db.select(db.cars).get();
    final imported = cars.where((c) => c.model == 'PhotoModel');
    expect(imported.length, 1);
    expect(imported.single.photo, isNull);
  });

  test('skips new cars when runtime kMaxCars cap is already reached', () async {
    final existing = await db.select(db.cars).get();
    final brand = await (db.select(db.carBrands)..limit(1)).getSingle();
    for (var i = existing.length; i < kMaxCars; i++) {
      await db.into(db.cars).insert(
            CarsCompanion.insert(
              brandId: brand.id,
              model: Value('Fill-$i'),
              year: const Value(2019),
              colorArgb: const Value(0xFF000000),
              createdAt: Value(DateTime.utc(2024, 1, 1)),
              updatedAt: Value(DateTime.utc(2024, 1, 1)),
            ),
          );
    }
    expect(await db.select(db.cars).get(), hasLength(kMaxCars));

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9101,
            BackupKeys.name: 'CapBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9102,
            BackupKeys.brandId: 9101,
            BackupKeys.model: 'OverCap',
            BackupKeys.year: 2022,
            BackupKeys.colorArgb: 0xFFABCDEF,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    final cars = await db.select(db.cars).get();
    expect(cars, hasLength(kMaxCars));
    expect(cars.any((c) => c.model == 'OverCap'), isFalse);
  });

  test('skips fuelings that fail runtime numeric write validation', () async {
    final before = await db.select(db.fuelings).get();

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9201,
            BackupKeys.name: 'FuelBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9202,
            BackupKeys.brandId: 9201,
            BackupKeys.model: 'FuelCar',
            BackupKeys.year: 2020,
            BackupKeys.colorArgb: 0xFF000000,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelTypes: [
          {
            BackupKeys.id: 9210,
            BackupKeys.name: 'Diesel',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelings: [
          {
            BackupKeys.carId: 9202,
            BackupKeys.fuelTypeId: 9210,
            BackupKeys.fueledAt: '2024-06-01T12:00:00.000',
            BackupKeys.pricePerLiter: 0,
            BackupKeys.liters: 40,
            BackupKeys.totalAmount: 50,
            BackupKeys.currencyCode: 'EUR',
            BackupKeys.createdAt: '2024-06-01T12:00:00.000',
            BackupKeys.updatedAt: '2024-06-01T12:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.skipped, greaterThanOrEqualTo(1));
    final after = await db.select(db.fuelings).get();
    expect(after, hasLength(before.length));
  });

  test('skips fuelings with missing or unmapped fuelTypeId', () async {
    final before = await db.select(db.fuelings).get();

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9221,
            BackupKeys.name: 'FkBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9222,
            BackupKeys.brandId: 9221,
            BackupKeys.model: 'FkCar',
            BackupKeys.year: 2020,
            BackupKeys.colorArgb: 0xFF000000,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        fuelings: [
          {
            BackupKeys.carId: 9222,
            BackupKeys.fueledAt: '2024-06-01T12:00:00.000',
            BackupKeys.pricePerLiter: 2,
            BackupKeys.liters: 40,
            BackupKeys.totalAmount: 80,
            BackupKeys.currencyCode: 'EUR',
            BackupKeys.createdAt: '2024-06-01T12:00:00.000',
            BackupKeys.updatedAt: '2024-06-01T12:00:00.000',
          },
          {
            BackupKeys.carId: 9222,
            BackupKeys.fuelTypeId: 99999,
            BackupKeys.fueledAt: '2024-06-02T12:00:00.000',
            BackupKeys.pricePerLiter: 2,
            BackupKeys.liters: 40,
            BackupKeys.totalAmount: 80,
            BackupKeys.currencyCode: 'EUR',
            BackupKeys.createdAt: '2024-06-02T12:00:00.000',
            BackupKeys.updatedAt: '2024-06-02T12:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.skipped, greaterThanOrEqualTo(2));
    final after = await db.select(db.fuelings).get();
    expect(after, hasLength(before.length));
  });

  test('skips maintenances with invalid part quantity', () async {
    final beforeMaint = await db.select(db.maintenances).get();
    final beforeParts = await db.select(db.maintenanceParts).get();

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9301,
            BackupKeys.name: 'MaintBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9302,
            BackupKeys.brandId: 9301,
            BackupKeys.model: 'MaintCar',
            BackupKeys.year: 2020,
            BackupKeys.colorArgb: 0xFF000000,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        maintenances: [
          {
            BackupKeys.id: 9401,
            BackupKeys.carId: 9302,
            BackupKeys.servicedAt: '2024-06-02T12:00:00.000',
            BackupKeys.totalAmount: 100,
            BackupKeys.currencyCode: 'EUR',
            BackupKeys.createdAt: '2024-06-02T12:00:00.000',
            BackupKeys.updatedAt: '2024-06-02T12:00:00.000',
          },
        ],
        maintenanceParts: [
          {
            BackupKeys.maintenanceId: 9401,
            BackupKeys.quantity: 0,
            BackupKeys.amount: 10,
            BackupKeys.createdAt: '2024-06-02T12:00:00.000',
            BackupKeys.updatedAt: '2024-06-02T12:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.skipped, greaterThanOrEqualTo(2));
    expect(await db.select(db.maintenances).get(), hasLength(beforeMaint.length));
    expect(
      await db.select(db.maintenanceParts).get(),
      hasLength(beforeParts.length),
    );
  });

  test('skips invalid reminders that runtime write rules would reject', () async {
    final before = await db.select(db.reminders).get();

    final result = await importer.importMap(
      emptyCatalogRoot(
        carBrands: [
          {
            BackupKeys.id: 9501,
            BackupKeys.name: 'ReminderBrand',
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
          },
        ],
        cars: [
          {
            BackupKeys.id: 9502,
            BackupKeys.brandId: 9501,
            BackupKeys.model: 'ReminderCar',
            BackupKeys.year: 2020,
            BackupKeys.colorArgb: 0xFF000000,
            BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
          },
        ],
        reminders: [
          {
            BackupKeys.id: 9601,
            BackupKeys.carId: 9502,
            BackupKeys.title: '  ',
            BackupKeys.dueAt: '2024-07-01T00:00:00.000',
            BackupKeys.isCompleted: false,
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-06-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
          },
          {
            BackupKeys.id: 9602,
            BackupKeys.carId: 9502,
            BackupKeys.title: 'No trigger',
            BackupKeys.isCompleted: false,
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-06-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
          },
          {
            BackupKeys.id: 9603,
            BackupKeys.carId: 9502,
            BackupKeys.title: 'Valid oil change',
            BackupKeys.dueAt: '2024-08-01T00:00:00.000',
            BackupKeys.isCompleted: false,
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-06-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    expect(result.skipped, greaterThanOrEqualTo(2));
    final after = await db.select(db.reminders).get();
    expect(after.length, before.length + 1);
    expect(
      after.any((r) => r.title == 'Valid oil change'),
      isTrue,
    );
    expect(after.any((r) => r.title.trim().isEmpty), isFalse);
    expect(after.any((r) => r.title == 'No trigger'), isFalse);
  });

  test('undeletes soft-deleted fuel type when active backup row matches',
      () async {
    final now = DateTime.utc(2024, 1, 1);
    final softId = await db.into(db.fuelTypes).insert(
          FuelTypesCompanion.insert(
            name: 'SoftFuel',
            isDeleted: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        fuelTypes: [
          {
            BackupKeys.id: 9701,
            BackupKeys.name: 'softfuel',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-02-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-02-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    final row = await (db.select(db.fuelTypes)
          ..where((t) => t.id.equals(softId)))
        .getSingle();
    expect(row.isDeleted, isFalse);
    expect(
      (await db.select(db.fuelTypes).get())
          .where((t) => t.name.toLowerCase() == 'softfuel')
          .length,
      1,
    );
  });

  test('prefers active fuel type over soft-deleted twin on import', () async {
    final now = DateTime.utc(2024, 1, 1);
    final softId = await db.into(db.fuelTypes).insert(
          FuelTypesCompanion.insert(
            name: 'TwinFuel',
            isDeleted: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final activeId = await db.into(db.fuelTypes).insert(
          FuelTypesCompanion.insert(
            name: 'TwinFuel',
            isDeleted: const Value(false),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    final result = await importer.importMap(
      emptyCatalogRoot(
        fuelTypes: [
          {
            BackupKeys.id: 9801,
            BackupKeys.name: 'twinfuel',
            BackupKeys.isDeleted: false,
            BackupKeys.createdAt: '2024-02-01T00:00:00.000',
            BackupKeys.updatedAt: '2024-02-01T00:00:00.000',
          },
        ],
      ),
    );

    expect(result.ok, isTrue);
    final soft = await (db.select(db.fuelTypes)
          ..where((t) => t.id.equals(softId)))
        .getSingle();
    final active = await (db.select(db.fuelTypes)
          ..where((t) => t.id.equals(activeId)))
        .getSingle();
    expect(soft.isDeleted, isTrue);
    expect(active.isDeleted, isFalse);
    expect(
      (await db.select(db.fuelTypes).get())
          .where((t) => t.name == 'TwinFuel')
          .length,
      2,
    );
  });
}
