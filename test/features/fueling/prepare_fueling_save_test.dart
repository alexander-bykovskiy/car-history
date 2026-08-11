import 'package:car_history/core/units.dart';
import 'package:car_history/features/fueling/domain/usecases/save_fueling.dart';
import 'package:car_history/features/fueling/presentation/controllers/fueling_form_prepare.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prepareFuelingSave', () {
    test('rejects empty fuel type', () {
      final result = prepareFuelingSave(
        carId: 1,
        fuelTypeName: '  ',
        gasStationName: null,
        fueledAt: DateTime(2024, 1, 1),
        priceText: '2',
        quantityText: '10',
        totalText: '',
        odometerText: '',
        currencyCode: 'EUR',
        volumeUnit: FuelVolumeUnit.liters,
        distanceUnit: DistanceUnit.kilometers,
        lastEdited: FuelingAmountField.quantity,
      );
      expect(result.error, SaveFuelingFailure.emptyFuelType);
      expect(result.isReady, isFalse);
    });

    test('computes total from quantity and price', () {
      final result = prepareFuelingSave(
        carId: 1,
        fuelTypeName: 'Diesel',
        gasStationName: 'Shell',
        fueledAt: DateTime(2024, 1, 1),
        priceText: '1.5',
        quantityText: '40',
        totalText: '',
        odometerText: '1000',
        currencyCode: 'EUR',
        volumeUnit: FuelVolumeUnit.liters,
        distanceUnit: DistanceUnit.kilometers,
        lastEdited: FuelingAmountField.quantity,
      );
      expect(result.isReady, isTrue);
      expect(result.quantity, 40);
      expect(result.total, 60);
      expect(result.input!.odometerKm, 1000);
      expect(result.input!.fuelTypeName, 'Diesel');
    });

    test('rejects invalid odometer', () {
      final result = prepareFuelingSave(
        carId: 1,
        fuelTypeName: 'Diesel',
        gasStationName: null,
        fueledAt: DateTime(2024, 1, 1),
        priceText: '1.5',
        quantityText: '10',
        totalText: '',
        odometerText: '-1',
        currencyCode: 'EUR',
        volumeUnit: FuelVolumeUnit.liters,
        distanceUnit: DistanceUnit.kilometers,
        lastEdited: FuelingAmountField.quantity,
      );
      expect(result.error, SaveFuelingFailure.invalidOdometer);
    });
  });
}
