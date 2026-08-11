import 'package:car_history/core/units.dart';
import 'package:car_history/features/maintenance/domain/usecases/save_maintenance.dart';
import 'package:car_history/features/maintenance/presentation/controllers/maintenance_form_prepare.dart';
import 'package:car_history/features/maintenance/presentation/models/draft_part_line.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prepareMaintenanceSave', () {
    test('rejects empty service', () {
      final result = prepareMaintenanceSave(
        carId: 1,
        serviceName: '',
        servicedAt: DateTime(2024, 1, 1),
        totalText: '100',
        odometerText: '',
        currencyCode: 'EUR',
        distanceUnit: DistanceUnit.kilometers,
        parts: const [],
      );
      expect(result.error, SaveMaintenanceFailure.emptyService);
    });

    test('accepts empty total and builds input', () {
      final result = prepareMaintenanceSave(
        carId: 1,
        serviceName: 'Oil change',
        servicedAt: DateTime(2024, 1, 1),
        totalText: '',
        odometerText: '12',
        currencyCode: 'EUR',
        distanceUnit: DistanceUnit.kilometers,
        parts: const [],
      );
      expect(result.isReady, isTrue);
      expect(result.input!.serviceName, 'Oil change');
      expect(result.input!.totalAmount, isNull);
      expect(result.input!.odometerKm, 12);
    });

    test('rejects invalid total', () {
      final result = prepareMaintenanceSave(
        carId: 1,
        serviceName: 'Oil change',
        servicedAt: DateTime(2024, 1, 1),
        totalText: '0',
        odometerText: '',
        currencyCode: 'EUR',
        distanceUnit: DistanceUnit.kilometers,
        parts: const [],
      );
      expect(result.error, SaveMaintenanceFailure.invalidTotal);
    });

    test('rejects invalid part quantity via shared write validation', () {
      final result = prepareMaintenanceSave(
        carId: 1,
        serviceName: 'Oil change',
        servicedAt: DateTime(2024, 1, 1),
        totalText: '',
        odometerText: '',
        currencyCode: 'EUR',
        distanceUnit: DistanceUnit.kilometers,
        parts: const [
          DraftPartLine(localId: 1, name: 'Filter', quantity: 0),
        ],
      );
      expect(result.error, SaveMaintenanceFailure.invalidPartQuantity);
    });
  });
}
