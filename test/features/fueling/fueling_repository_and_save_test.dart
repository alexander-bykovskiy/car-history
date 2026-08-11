import 'package:car_history/features/catalog/data/fuel_type_repository_impl.dart';
import 'package:car_history/features/catalog/data/gas_station_repository_impl.dart';
import 'package:car_history/features/fueling/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/fueling/domain/entities/fueling_save.dart';
import 'package:car_history/features/fueling/domain/repositories/catalog_ports.dart';
import 'package:car_history/features/fueling/domain/usecases/save_fueling.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FuelingRepositoryImpl', () {
    late AppDatabase db;
    late FuelingRepositoryImpl fuelings;
    late int carId;
    late int fuelTypeId;

    setUp(() async {
      db = await openInMemoryDatabase();
      fuelings = FuelingRepositoryImpl(db);
      final car = await db.select(db.cars).getSingle();
      carId = car.id;
      final fuelType = await (db.select(db.fuelTypes)..limit(1)).getSingle();
      fuelTypeId = fuelType.id;
    });

    tearDown(() async {
      await db.close();
    });

    test('create validates price and persists', () async {
      final invalid = await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 1, 1),
        pricePerLiter: 0,
        liters: 10,
        totalAmount: 10,
        currencyCode: 'EUR',
      );
      expect(invalid.result, FuelingSaveResult.invalidPrice);

      final ok = await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 1, 2),
        pricePerLiter: 1.5,
        liters: 40,
        totalAmount: 60,
        currencyCode: 'EUR',
        odometerKm: 1000,
      );
      expect(ok.result, FuelingSaveResult.created);
      expect(ok.item?.totalAmount, 60);
      expect(ok.item?.currencyCode, 'EUR');

      final totals = await fuelings.monthTotalsForCar(carId);
      expect(totals[(2024, 1)], {'EUR': 60});
    });
  });

  group('SaveFuelingUseCase', () {
    late AppDatabase db;
    late SaveFuelingUseCase saveFueling;
    late int carId;

    setUp(() async {
      db = await openInMemoryDatabase();
      carId = (await db.select(db.cars).getSingle()).id;
      saveFueling = SaveFuelingUseCase(
        fuelingRepository: FuelingRepositoryImpl(db),
        fuelTypeEnsurer: FuelTypeEnsurerAdapter(FuelTypeRepositoryImpl(db)),
        gasStationEnsurer: GasStationEnsurerAdapter(GasStationRepositoryImpl(db)),
        transactionRunner: DriftTransactionRunner(db),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('creates fueling and ensures fuel type', () async {
      final result = await saveFueling(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: 'Test Fuel',
          fueledAt: DateTime(2024, 5, 1),
          pricePerLiter: 2,
          liters: 10,
          totalAmount: 20,
          currencyCode: 'EUR',
        ),
      );
      expect(result.isSuccess, isTrue);
      expect(result.outcome?.result, FuelingSaveResult.created);
    });

    test('fails on empty fuel type', () async {
      final result = await saveFueling(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: '  ',
          fueledAt: DateTime(2024, 5, 1),
          pricePerLiter: 2,
          liters: 10,
          totalAmount: 20,
          currencyCode: 'EUR',
        ),
      );
      expect(result.failure, SaveFuelingFailure.emptyFuelType);
    });

    test('ensures gas station together with fueling', () async {
      final result = await saveFueling(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: 'Diesel TX',
          gasStationName: 'Shell · Downtown',
          fueledAt: DateTime(2024, 5, 2),
          pricePerLiter: 1.8,
          liters: 20,
          totalAmount: 36,
          currencyCode: 'EUR',
        ),
      );
      expect(result.isSuccess, isTrue);
      expect(result.outcome?.item?.gasStationId, isNotNull);

      final chains = await db.select(db.gasStationChains).get();
      expect(
        chains.any((c) => c.name.toLowerCase().contains('shell')),
        isTrue,
      );
    });

    test('aborts when gas station ensure fails for non-empty name', () async {
      final save = SaveFuelingUseCase(
        fuelingRepository: FuelingRepositoryImpl(db),
        fuelTypeEnsurer: FuelTypeEnsurerAdapter(FuelTypeRepositoryImpl(db)),
        gasStationEnsurer: _FailingGasStationEnsurer(),
        transactionRunner: DriftTransactionRunner(db),
      );

      final beforeFuelings = await db.select(db.fuelings).get();
      final result = await save(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: 'Diesel Fail GS',
          gasStationName: 'Broken Station',
          fueledAt: DateTime(2024, 5, 4),
          pricePerLiter: 2,
          liters: 10,
          totalAmount: 20,
          currencyCode: 'EUR',
        ),
      );

      expect(result.failure, SaveFuelingFailure.gasStationEnsureFailed);
      final afterFuelings = await db.select(db.fuelings).get();
      expect(afterFuelings.length, beforeFuelings.length);
      expect(
        (await db.select(db.fuelTypes).get())
            .any((t) => t.name == 'Diesel Fail GS'),
        isFalse,
      );
    });

    test('rolls back catalog ensure when fueling validation fails', () async {
      final beforeChains = await db.select(db.gasStationChains).get();
      final beforeFuelTypes = await db.select(db.fuelTypes).get();

      final result = await saveFueling(
        SaveFuelingInput(
          carId: carId,
          fuelTypeName: 'Abort Fuel Type Unique',
          gasStationName: 'Abort Station Unique',
          fueledAt: DateTime(2024, 5, 3),
          pricePerLiter: 0,
          liters: 10,
          totalAmount: 10,
          currencyCode: 'EUR',
        ),
      );
      expect(result.failure, SaveFuelingFailure.invalidPrice);

      final afterChains = await db.select(db.gasStationChains).get();
      final afterFuelTypes = await db.select(db.fuelTypes).get();
      expect(afterChains.length, beforeChains.length);
      expect(afterFuelTypes.length, beforeFuelTypes.length);
      expect(
        afterFuelTypes.any((t) => t.name == 'Abort Fuel Type Unique'),
        isFalse,
      );
    });
  });
}

class _FailingGasStationEnsurer implements GasStationEnsurer {
  @override
  Future<int?> ensureFromInput(String rawName) async => null;
}
