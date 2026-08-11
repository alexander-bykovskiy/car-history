import 'package:car_history/core/units.dart';
import 'package:car_history/features/catalog/data/fuel_type_repository_impl.dart';
import 'package:car_history/features/catalog/data/gas_station_repository_impl.dart';
import 'package:car_history/features/fueling/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/fueling/domain/repositories/fueling_repository.dart';
import 'package:car_history/features/fueling/domain/usecases/delete_fueling.dart';
import 'package:car_history/features/fueling/domain/usecases/save_fueling.dart';
import 'package:car_history/features/fueling/presentation/controllers/fueling_form_notifier.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

class _ThrowingDeleteFuelings extends Fake implements FuelingRepository {
  @override
  Future<void> delete(int id) => throw StateError('delete failed');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FuelingFormNotifier', () {
    test('submit returns fieldError for empty fuel type without writing',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final carId = (await db.select(db.cars).getSingle()).id;
      final save = SaveFuelingUseCase(
        fuelingRepository: FuelingRepositoryImpl(db),
        fuelTypeEnsurer: FuelTypeEnsurerAdapter(FuelTypeRepositoryImpl(db)),
        gasStationEnsurer:
            GasStationEnsurerAdapter(GasStationRepositoryImpl(db)),
        transactionRunner: DriftTransactionRunner(db),
      );
      final form = FuelingFormNotifier(
        carId: carId,
        volumeUnit: FuelVolumeUnit.liters,
        distanceUnit: DistanceUnit.kilometers,
        currencyCode: 'EUR',
        existing: null,
        deleteId: null,
      );
      final quantity = TextEditingController();
      final total = TextEditingController();
      addTearDown(quantity.dispose);
      addTearDown(total.dispose);
      addTearDown(form.dispose);

      final outcome = await form.submit(
        save: save,
        odometer: OdometerRepositoryImpl(db),
        fuelTypeName: '',
        gasStationName: '',
        priceText: '1.5',
        quantityText: '10',
        totalText: '15',
        odometerText: '',
        quantityController: quantity,
        totalController: total,
        confirmOdometer: (_) async => true,
      );

      expect(outcome, isA<FuelingFormSubmitFieldError>());
      expect(
        (outcome as FuelingFormSubmitFieldError).error,
        SaveFuelingFailure.emptyFuelType,
      );
      expect(form.fuelTypeError, SaveFuelingFailure.emptyFuelType);
      expect(await db.select(db.fuelings).get(), isEmpty);
    });

    test('delete returns unexpected when repository throws', () async {
      final form = FuelingFormNotifier(
        carId: 1,
        volumeUnit: FuelVolumeUnit.liters,
        distanceUnit: DistanceUnit.kilometers,
        currencyCode: 'EUR',
        existing: null,
        deleteId: 42,
      );
      addTearDown(form.dispose);

      final outcome = await form.delete(
        DeleteFuelingUseCase(_ThrowingDeleteFuelings()),
      );

      expect(outcome, isA<FuelingFormSubmitUnexpected>());
      expect(form.saving, isFalse);
    });
  });
}
