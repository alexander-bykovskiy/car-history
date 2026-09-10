import 'package:car_history/features/fueling/domain/entities/fueling_save.dart';
import 'package:car_history/features/fueling/domain/fueling_write_validation.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance_save.dart';
import 'package:car_history/features/maintenance/domain/maintenance_write_validation.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/domain/reminder_write_validation.dart';
import 'package:car_history/features/settings/data/backup/backup_importer.dart';
import 'package:car_history/features/settings/data/backup/backup_keys.dart';
import 'package:car_history/features/settings/data/currency_preferences.dart';
import 'package:car_history/features/settings/data/unit_preferences.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';

/// Behavior parity: cases rejected by domain write validators must also be
/// skipped by backup import (not inserted). Complements import-hygiene checks
/// in [backup_dual_path_test.dart].
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

  Map<String, dynamic> root({
    List<Map<String, dynamic>> carBrands = const [],
    List<Map<String, dynamic>> cars = const [],
    List<Map<String, dynamic>> fuelTypes = const [],
    List<Map<String, dynamic>> services = const [],
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
      BackupKeys.fuelTypeCars: const <Map<String, dynamic>>[],
      BackupKeys.parts: const <Map<String, dynamic>>[],
      BackupKeys.partCars: const <Map<String, dynamic>>[],
      BackupKeys.partUnits: const <Map<String, dynamic>>[],
      BackupKeys.services: services,
      BackupKeys.serviceCenters: const <Map<String, dynamic>>[],
      BackupKeys.gasStationChains: const <Map<String, dynamic>>[],
      BackupKeys.gasStationLocations: const <Map<String, dynamic>>[],
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

  group('fueling write rules: domain ↔ backup', () {
    test('domain rejects non-positive price / liters / negative odometer', () {
      expect(
        validateFuelingWrite(
          pricePerLiter: 0,
          liters: 40,
          totalAmount: 80,
        ),
        FuelingSaveResult.invalidPrice,
      );
      expect(
        validateFuelingWrite(
          pricePerLiter: 2,
          liters: 0,
          totalAmount: 80,
        ),
        FuelingSaveResult.invalidQuantityOrTotal,
      );
      expect(
        validateFuelingWrite(
          pricePerLiter: 2,
          liters: 40,
          totalAmount: 80,
          odometerKm: -1,
        ),
        FuelingSaveResult.invalidOdometer,
      );
    });

    test('backup skips rows that fail the same numeric rules', () async {
      final before = await db.select(db.fuelings).get();

      final result = await importer.importMap(
        root(
          carBrands: [
            {
              BackupKeys.id: 101,
              BackupKeys.name: 'ParityBrand',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            },
          ],
          cars: [
            {
              BackupKeys.id: 102,
              BackupKeys.brandId: 101,
              BackupKeys.model: 'ParityCar',
              BackupKeys.year: 2020,
              BackupKeys.colorArgb: 0xFF000000,
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          fuelTypes: [
            {
              BackupKeys.id: 103,
              BackupKeys.name: 'ParityFuel',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          fuelings: [
            {
              BackupKeys.carId: 102,
              BackupKeys.fuelTypeId: 103,
              BackupKeys.fueledAt: '2024-06-01T12:00:00.000',
              BackupKeys.pricePerLiter: 0,
              BackupKeys.liters: 40,
              BackupKeys.totalAmount: 80,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-01T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-01T12:00:00.000',
            },
            {
              BackupKeys.carId: 102,
              BackupKeys.fuelTypeId: 103,
              BackupKeys.fueledAt: '2024-06-02T12:00:00.000',
              BackupKeys.pricePerLiter: 2,
              BackupKeys.liters: 40,
              BackupKeys.totalAmount: 80,
              BackupKeys.odometerKm: -5,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-02T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-02T12:00:00.000',
            },
            {
              BackupKeys.carId: 102,
              BackupKeys.fuelTypeId: 103,
              BackupKeys.fueledAt: '2024-06-03T12:00:00.000',
              BackupKeys.pricePerLiter: 2,
              BackupKeys.liters: 40,
              BackupKeys.totalAmount: 80,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-03T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-03T12:00:00.000',
            },
          ],
        ),
      );

      expect(result.ok, isTrue);
      expect(result.skipped, greaterThanOrEqualTo(2));
      final after = await db.select(db.fuelings).get();
      expect(after, hasLength(before.length + 1));
    });
  });

  group('maintenance write rules: domain ↔ backup', () {
    test('domain rejects invalid total / odometer / part quantity', () {
      expect(
        validateMaintenanceWrite(totalAmount: 0),
        MaintenanceSaveResult.invalidTotal,
      );
      expect(
        validateMaintenanceWrite(odometerKm: -1),
        MaintenanceSaveResult.invalidOdometer,
      );
      expect(
        validateMaintenanceWrite(
          parts: const [
            MaintenancePartInput(partId: 1, quantity: 0, amount: 10),
          ],
        ),
        MaintenanceSaveResult.invalidPartQuantity,
      );
    });

    test('backup skips rows that fail the same numeric rules', () async {
      final beforeMaint = await db.select(db.maintenances).get();

      final result = await importer.importMap(
        root(
          carBrands: [
            {
              BackupKeys.id: 201,
              BackupKeys.name: 'MaintParityBrand',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            },
          ],
          cars: [
            {
              BackupKeys.id: 202,
              BackupKeys.brandId: 201,
              BackupKeys.model: 'MaintParityCar',
              BackupKeys.year: 2020,
              BackupKeys.colorArgb: 0xFF000000,
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          services: [
            {
              BackupKeys.id: 203,
              BackupKeys.name: 'ParityService',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          maintenances: [
            {
              BackupKeys.id: 301,
              BackupKeys.carId: 202,
              BackupKeys.serviceId: 203,
              BackupKeys.servicedAt: '2024-06-01T12:00:00.000',
              BackupKeys.totalAmount: 0,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-01T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-01T12:00:00.000',
            },
            {
              BackupKeys.id: 302,
              BackupKeys.carId: 202,
              BackupKeys.serviceId: 203,
              BackupKeys.servicedAt: '2024-06-02T12:00:00.000',
              BackupKeys.totalAmount: 100,
              BackupKeys.odometerKm: -10,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-02T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-02T12:00:00.000',
            },
            {
              BackupKeys.id: 303,
              BackupKeys.carId: 202,
              BackupKeys.serviceId: 203,
              BackupKeys.servicedAt: '2024-06-03T12:00:00.000',
              BackupKeys.totalAmount: 100,
              BackupKeys.currencyCode: 'EUR',
              BackupKeys.createdAt: '2024-06-03T12:00:00.000',
              BackupKeys.updatedAt: '2024-06-03T12:00:00.000',
            },
          ],
        ),
      );

      expect(result.ok, isTrue);
      expect(result.skipped, greaterThanOrEqualTo(2));
      final after = await db.select(db.maintenances).get();
      expect(after, hasLength(beforeMaint.length + 1));
    });
  });

  group('reminder write rules: domain ↔ backup', () {
    test('domain rejects empty title / trigger / invalid remind-before / odometer',
        () {
      expect(
        validateReminderWrite(title: '  ', dueAt: DateTime(2024)),
        ReminderSaveResult.emptyTitle,
      );
      expect(
        validateReminderWrite(title: 'Oil'),
        ReminderSaveResult.emptyTrigger,
      );
      expect(
        validateReminderWrite(
          title: 'Oil',
          dueOdometerKm: 1000,
          remindBeforeDays: 7,
        ),
        ReminderSaveResult.invalidRemindBefore,
      );
      expect(
        validateReminderWrite(title: 'Oil', dueOdometerKm: -1),
        ReminderSaveResult.invalidOdometer,
      );
    });

    test('backup skips remind-before without matching due field', () async {
      final before = await db.select(db.reminders).get();

      final result = await importer.importMap(
        root(
          carBrands: [
            {
              BackupKeys.id: 401,
              BackupKeys.name: 'RemParityBrand',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            },
          ],
          cars: [
            {
              BackupKeys.id: 402,
              BackupKeys.brandId: 401,
              BackupKeys.model: 'RemParityCar',
              BackupKeys.year: 2020,
              BackupKeys.colorArgb: 0xFF000000,
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          reminders: [
            {
              BackupKeys.id: 501,
              BackupKeys.carId: 402,
              BackupKeys.title: 'Bad remind-before',
              BackupKeys.dueOdometerKm: 10000,
              BackupKeys.remindBeforeDays: 7,
              BackupKeys.isCompleted: false,
              BackupKeys.isDeleted: false,
              BackupKeys.createdAt: '2024-06-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
            },
            {
              BackupKeys.id: 502,
              BackupKeys.carId: 402,
              BackupKeys.title: 'Valid parity',
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
      expect(result.skipped, greaterThanOrEqualTo(1));
      final after = await db.select(db.reminders).get();
      expect(after, hasLength(before.length + 1));
      expect(after.any((r) => r.title == 'Valid parity'), isTrue);
      expect(after.any((r) => r.title == 'Bad remind-before'), isFalse);
    });

    test('backup skips negative due odometer that runtime rejects', () async {
      final before = await db.select(db.reminders).get();

      final result = await importer.importMap(
        root(
          carBrands: [
            {
              BackupKeys.id: 601,
              BackupKeys.name: 'OdoParityBrand',
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
            },
          ],
          cars: [
            {
              BackupKeys.id: 602,
              BackupKeys.brandId: 601,
              BackupKeys.model: 'OdoParityCar',
              BackupKeys.year: 2020,
              BackupKeys.colorArgb: 0xFF000000,
              BackupKeys.createdAt: '2024-01-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-01-01T00:00:00.000',
            },
          ],
          reminders: [
            {
              BackupKeys.id: 701,
              BackupKeys.carId: 602,
              BackupKeys.title: 'Negative odo',
              BackupKeys.dueOdometerKm: -50,
              BackupKeys.isCompleted: false,
              BackupKeys.isDeleted: false,
              BackupKeys.createdAt: '2024-06-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
            },
            {
              BackupKeys.id: 702,
              BackupKeys.carId: 602,
              BackupKeys.title: 'Valid odo',
              BackupKeys.dueOdometerKm: 12000,
              BackupKeys.isCompleted: false,
              BackupKeys.isDeleted: false,
              BackupKeys.createdAt: '2024-06-01T00:00:00.000',
              BackupKeys.updatedAt: '2024-06-01T00:00:00.000',
            },
          ],
        ),
      );

      expect(result.ok, isTrue);
      expect(result.skipped, greaterThanOrEqualTo(1));
      final after = await db.select(db.reminders).get();
      expect(after, hasLength(before.length + 1));
      expect(after.any((r) => r.title == 'Valid odo'), isTrue);
      expect(after.any((r) => r.title == 'Negative odo'), isFalse);
    });
  });
}
