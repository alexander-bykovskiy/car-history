import 'package:car_history/core/units.dart';
import 'package:car_history/shared/domain/odometer_repository.dart';
import 'package:car_history/shared/presentation/reminder_odometer_prefill.dart';
import 'package:car_history/shared/presentation/reminder_trigger_form.dart';
import 'package:car_history/core/odometer_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReminderOdometerPrefill', () {
    test('resolveBaselineKm prefers display text over repository', () async {
      final baseline = await ReminderOdometerPrefill.resolveBaselineKm(
        odometer: _FakeOdometer(maxKm: 100000),
        carId: 1,
        preferredDisplayText: '180572',
      );
      expect(baseline, 180572);
    });

    test('resolveBaselineKm falls back to maxOdometerKm', () async {
      final baseline = await ReminderOdometerPrefill.resolveBaselineKm(
        odometer: _FakeOdometer(maxKm: 42100),
        carId: 1,
      );
      expect(baseline, 42100);
    });

    test('absoluteFieldText fills only for absolute mode when empty', () {
      expect(
        ReminderOdometerPrefill.absoluteFieldText(
          baselineKm: 1000,
          mode: ReminderOdometerInputMode.after,
          distanceUnit: DistanceUnit.kilometers,
          currentText: '',
        ),
        isNull,
      );
      expect(
        ReminderOdometerPrefill.absoluteFieldText(
          baselineKm: 1000,
          mode: ReminderOdometerInputMode.absolute,
          distanceUnit: DistanceUnit.kilometers,
          currentText: '500',
        ),
        isNull,
      );
      expect(
        ReminderOdometerPrefill.absoluteFieldText(
          baselineKm: 1000,
          mode: ReminderOdometerInputMode.absolute,
          distanceUnit: DistanceUnit.kilometers,
          currentText: '',
        ),
        '1000',
      );
    });
  });
}

class _FakeOdometer implements OdometerRepository {
  _FakeOdometer({this.maxKm});

  final double? maxKm;

  @override
  Future<double?> maxOdometerKm(
    int carId, {
    int? excludingFuelingId,
    int? excludingMaintenanceId,
  }) async =>
      maxKm;

  @override
  Future<OdometerNeighbors> odometerNeighbors({
    required int carId,
    required DateTime at,
    OdometerEventSource? editingSource,
    int? excludingId,
  }) {
    throw UnimplementedError();
  }
}
