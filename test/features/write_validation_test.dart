import 'package:car_history/features/fueling/domain/entities/fueling_save.dart';
import 'package:car_history/features/fueling/domain/fueling_write_validation.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance_save.dart';
import 'package:car_history/features/maintenance/domain/maintenance_write_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateFuelingWrite', () {
    test('accepts positive price, liters, and total', () {
      expect(
        validateFuelingWrite(
          pricePerLiter: 1.5,
          liters: 40,
          totalAmount: 60,
        ),
        isNull,
      );
    });

    test('rejects non-positive price / amounts / odometer', () {
      expect(
        validateFuelingWrite(
          pricePerLiter: 0,
          liters: 40,
          totalAmount: 60,
        ),
        FuelingSaveResult.invalidPrice,
      );
      expect(
        validateFuelingWrite(
          pricePerLiter: 1.5,
          liters: 0,
          totalAmount: 60,
        ),
        FuelingSaveResult.invalidQuantityOrTotal,
      );
      expect(
        validateFuelingWrite(
          pricePerLiter: 1.5,
          liters: 40,
          totalAmount: 60,
          odometerKm: -1,
        ),
        FuelingSaveResult.invalidOdometer,
      );
    });
  });

  group('validateMaintenanceWrite', () {
    test('accepts null total and non-negative odometer', () {
      expect(validateMaintenanceWrite(), isNull);
      expect(
        validateMaintenanceWrite(totalAmount: 100, odometerKm: 0),
        isNull,
      );
    });

    test('rejects invalid total, odometer, and parts', () {
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
            MaintenancePartInput(partId: 1, quantity: 0),
          ],
        ),
        MaintenanceSaveResult.invalidPartQuantity,
      );
      expect(
        validateMaintenanceWrite(
          parts: const [
            MaintenancePartInput(partId: 1, quantity: 1, amount: 0),
          ],
        ),
        MaintenanceSaveResult.invalidPartAmount,
      );
    });
  });
}
