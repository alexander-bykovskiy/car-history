import 'package:car_history/features/cars/data/car_brand_repository_impl.dart';
import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/cars/data/car_selection_preferences.dart';
import 'package:car_history/features/cars/domain/entities/car.dart';
import 'package:car_history/features/cars/domain/repositories/car_repository.dart';
import 'package:car_history/features/cars/domain/selected_car_service.dart';
import 'package:car_history/features/cars/domain/usecases/car_write_usecases.dart';
import 'package:car_history/features/catalog/data/fuel_type_repository_impl.dart';
import 'package:car_history/features/catalog/data/gas_station_repository_impl.dart';
import 'package:car_history/features/catalog/data/part_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/features/catalog/domain/entities/gas_station.dart';
import 'package:car_history/features/catalog/domain/usecases/gas_station_write_usecases.dart';
import 'package:car_history/features/fueling/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/fueling/domain/entities/fueling_save.dart';
import 'package:car_history/features/fueling/domain/usecases/delete_fueling.dart';
import 'package:car_history/features/fueling/domain/usecases/save_fueling.dart';
import 'package:car_history/features/maintenance/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/maintenance/data/reminder_linker_adapter.dart';
import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/features/maintenance/domain/entities/reminder_draft.dart';
import 'package:car_history/features/maintenance/domain/usecases/delete_maintenance.dart';
import 'package:car_history/features/maintenance/domain/usecases/save_maintenance.dart';
import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeleteFuelingUseCase', () {
    late AppDatabase db;
    late DeleteFuelingUseCase deleteFueling;
    late SaveFuelingUseCase saveFueling;
    late int carId;

    setUp(() async {
      db = await openInMemoryDatabase();
      carId = (await db.select(db.cars).getSingle()).id;
      final fuelings = FuelingRepositoryImpl(db);
      deleteFueling = DeleteFuelingUseCase(fuelings);
      saveFueling = SaveFuelingUseCase(
        fuelingRepository: fuelings,
        fuelTypeEnsurer: FuelTypeEnsurerAdapter(FuelTypeRepositoryImpl(db)),
        gasStationEnsurer:
            GasStationEnsurerAdapter(GasStationRepositoryImpl(db)),
        transactionRunner: DriftTransactionRunner(db),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('removes fueling row', () async {
      final created = await saveFueling(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: 'Delete Fuel',
          fueledAt: DateTime(2024, 3, 1),
          pricePerLiter: 2,
          liters: 10,
          totalAmount: 20,
          currencyCode: 'EUR',
        ),
      );
      expect(created.isSuccess, isTrue);
      final id = created.outcome!.item!.id;

      await deleteFueling(id);

      final rows = await db.select(db.fuelings).get();
      expect(rows.any((row) => row.id == id), isFalse);
    });
  });

  group('DeleteMaintenanceUseCase', () {
    late AppDatabase db;
    late DeleteMaintenanceUseCase deleteMaintenance;
    late SaveMaintenanceUseCase saveMaintenance;
    late int carId;

    setUp(() async {
      db = await openInMemoryDatabase();
      carId = (await db.select(db.cars).getSingle()).id;
      final maintenances = MaintenanceRepositoryImpl(db);
      final reminderLinker = ReminderLinkerAdapter(
        ReminderRepositoryImpl(db, odometerRepository: OdometerRepositoryImpl(db)),
      );
      deleteMaintenance = DeleteMaintenanceUseCase(
        maintenanceRepository: maintenances,
        reminderLinker: reminderLinker,
        transactionRunner: DriftTransactionRunner(db),
      );
      saveMaintenance = SaveMaintenanceUseCase(
        maintenanceRepository: maintenances,
        serviceEnsurer: ServiceEnsurerAdapter(ServiceRepositoryImpl(db)),
        partEnsurer: PartEnsurerAdapter(PartRepositoryImpl(db)),
        reminderLinker: reminderLinker,
        transactionRunner: DriftTransactionRunner(db),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('deletes maintenance and soft-deletes linked reminder', () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Delete With Reminder',
          servicedAt: DateTime(2024, 4, 1),
          totalAmount: 40,
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(dueAt: DateTime(2024, 10, 1)),
        ),
      );
      expect(created.isSuccess, isTrue);
      final maintenanceId = created.outcome!.item!.id;
      final reminderId = created.outcome!.item!.reminderId!;

      await deleteMaintenance(maintenanceId);

      expect(
        await (db.select(db.maintenances)
              ..where((t) => t.id.equals(maintenanceId)))
            .getSingleOrNull(),
        isNull,
      );
      final reminder = await (db.select(db.reminders)
            ..where((t) => t.id.equals(reminderId)))
          .getSingle();
      expect(reminder.isDeleted, isTrue);
    });

    test('rolls back reminder soft-delete when delete aborts', () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Abort Delete Service',
          servicedAt: DateTime(2024, 4, 2),
          totalAmount: 55,
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(dueAt: DateTime(2024, 11, 1)),
        ),
      );
      expect(created.isSuccess, isTrue);
      final maintenanceId = created.outcome!.item!.id;
      final reminderId = created.outcome!.item!.reminderId!;

      final aborting = DeleteMaintenanceUseCase(
        maintenanceRepository: _AbortingMaintenanceRepository(db),
        reminderLinker: ReminderLinkerAdapter(
          ReminderRepositoryImpl(db, odometerRepository: OdometerRepositoryImpl(db)),
        ),
        transactionRunner: DriftTransactionRunner(db),
      );

      await expectLater(
        aborting(maintenanceId),
        throwsA(isA<StateError>()),
      );

      expect(
        await (db.select(db.maintenances)
              ..where((t) => t.id.equals(maintenanceId)))
            .getSingleOrNull(),
        isNotNull,
      );
      final reminder = await (db.select(db.reminders)
            ..where((t) => t.id.equals(reminderId)))
          .getSingle();
      expect(reminder.isDeleted, isFalse);
    });
  });

  group('DeleteGasStationChainUseCase', () {
    late AppDatabase db;
    late GasStationRepositoryImpl stations;
    late DeleteGasStationChainUseCase deleteChain;
    late int carId;
    late int fuelTypeId;

    setUp(() async {
      db = await openInMemoryDatabase();
      stations = GasStationRepositoryImpl(db);
      deleteChain = DeleteGasStationChainUseCase(
        stations,
        DriftTransactionRunner(db),
      );
      carId = (await db.select(db.cars).getSingle()).id;
      fuelTypeId = (await (db.select(db.fuelTypes)..limit(1)).getSingle()).id;
    });

    tearDown(() async {
      await db.close();
    });

    test('hard-deletes chain and locations when unreferenced', () async {
      final chainOutcome = await stations.createChain('Hard Delete Chain');
      final chain = chainOutcome.chain!;
      final locationOutcome = await stations.ensureLocation(
        chainId: chain.id,
        address: 'Main St',
      );
      expect(locationOutcome.location, isNotNull);

      await deleteChain(chain);

      expect(
        await (db.select(db.gasStationChains)
              ..where((t) => t.id.equals(chain.id)))
            .getSingleOrNull(),
        isNull,
      );
      final locations = await (db.select(db.gasStationLocations)
            ..where((t) => t.chainId.equals(chain.id)))
          .get();
      expect(locations, isEmpty);
    });

    test('soft-deletes chain and locations when referenced by fueling', () async {
      final chainOutcome = await stations.createChain('Soft Delete Chain');
      final chain = chainOutcome.chain!;
      final locationOutcome = await stations.ensureLocation(
        chainId: chain.id,
        address: 'Ref St',
      );
      final locationId = locationOutcome.location!.id;

      final fuelings = FuelingRepositoryImpl(db);
      final created = await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 5, 1),
        pricePerLiter: 1.5,
        liters: 10,
        totalAmount: 15,
        currencyCode: 'EUR',
        gasStationId: locationId,
      );
      expect(created.result, FuelingSaveResult.created);

      await deleteChain(chain);

      final chainRow = await (db.select(db.gasStationChains)
            ..where((t) => t.id.equals(chain.id)))
          .getSingle();
      expect(chainRow.isDeleted, isTrue);
      final locationRow = await (db.select(db.gasStationLocations)
            ..where((t) => t.id.equals(locationId)))
          .getSingle();
      expect(locationRow.isDeleted, isTrue);
    });

    test('restoreChain undeletes cascade soft-deleted locations', () async {
      final chainOutcome = await stations.createChain('Restore Cascade Chain');
      final chain = chainOutcome.chain!;
      final addressed = await stations.ensureLocation(
        chainId: chain.id,
        address: 'Ref St',
      );
      final blank = await stations.ensureLocation(
        chainId: chain.id,
        address: null,
      );
      final addressedId = addressed.location!.id;
      final blankId = blank.location!.id;

      final fuelings = FuelingRepositoryImpl(db);
      await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 5, 3),
        pricePerLiter: 1.5,
        liters: 10,
        totalAmount: 15,
        currencyCode: 'EUR',
        gasStationId: addressedId,
      );

      await deleteChain(chain);

      final restore = RestoreGasStationChainUseCase(
        stations,
        DriftTransactionRunner(db),
      );
      await restore(chain);

      final chainRow = await (db.select(db.gasStationChains)
            ..where((t) => t.id.equals(chain.id)))
          .getSingle();
      expect(chainRow.isDeleted, isFalse);

      final addressedRow = await (db.select(db.gasStationLocations)
            ..where((t) => t.id.equals(addressedId)))
          .getSingle();
      expect(addressedRow.isDeleted, isFalse);

      final blankRow = await (db.select(db.gasStationLocations)
            ..where((t) => t.id.equals(blankId)))
          .getSingle();
      expect(blankRow.isDeleted, isFalse);
      expect(blankRow.address, isNull);
    });

    test('rolls back soft-delete when delete aborts mid-tx', () async {
      final chainOutcome = await stations.createChain('Abort Soft Chain');
      final chain = chainOutcome.chain!;
      final locationOutcome = await stations.ensureLocation(
        chainId: chain.id,
        address: 'Abort St',
      );
      final locationId = locationOutcome.location!.id;

      final fuelings = FuelingRepositoryImpl(db);
      await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 5, 2),
        pricePerLiter: 1.5,
        liters: 10,
        totalAmount: 15,
        currencyCode: 'EUR',
        gasStationId: locationId,
      );

      final aborting = DeleteGasStationChainUseCase(
        _AbortingGasStationRepository(db),
        DriftTransactionRunner(db),
      );

      await expectLater(
        aborting(chain),
        throwsA(isA<StateError>()),
      );

      final chainRow = await (db.select(db.gasStationChains)
            ..where((t) => t.id.equals(chain.id)))
          .getSingle();
      expect(chainRow.isDeleted, isFalse);
      final locationRow = await (db.select(db.gasStationLocations)
            ..where((t) => t.id.equals(locationId)))
          .getSingle();
      expect(locationRow.isDeleted, isFalse);
    });
  });

  group('DeleteCarUseCase', () {
    late AppDatabase db;
    late DeleteCarUseCase deleteCar;
    late SaveCarUseCase saveCar;
    late CarRepository cars;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = await openInMemoryDatabase();
      cars = CarRepositoryImpl(db);
      final brands = CarBrandRepositoryImpl(db);
      final selection = PrefsCarSelectionStore();
      final selected = SelectedCarService(
        carRepository: cars,
        selectionStore: selection,
      );
      deleteCar = DeleteCarUseCase(cars, selected);
      saveCar = SaveCarUseCase(
        carRepository: cars,
        brandRepository: brands,
        transactionRunner: DriftTransactionRunner(db),
        selectedCarService: selected,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('refuses to delete the last car', () async {
      final only = (await db.select(db.cars).getSingle()).id;
      final result = await deleteCar(only);
      expect(result, CarDeleteResult.lastCar);
      expect(await cars.count(), 1);
    });

    test('deletes a non-last car', () async {
      final created = await saveCar.create(
        rawBrandName: 'Toyota',
        model: 'Extra',
      );
      expect(created.isSuccess, isTrue);
      final id = created.createdId!;
      expect(await cars.count(), 2);

      final result = await deleteCar(id);
      expect(result, CarDeleteResult.deleted);
      expect(await cars.count(), 1);
    });
  });
}

class _AbortingMaintenanceRepository extends MaintenanceRepositoryImpl {
  _AbortingMaintenanceRepository(super.db);

  @override
  Future<int?> delete(int id) async {
    await super.delete(id);
    throw StateError('force rollback after maintenance delete');
  }
}

class _AbortingGasStationRepository extends GasStationRepositoryImpl {
  _AbortingGasStationRepository(super.db);

  @override
  Future<void> deleteChain(GasStationChainItem chain) async {
    await super.deleteChain(chain);
    throw StateError('force rollback after chain delete');
  }
}
