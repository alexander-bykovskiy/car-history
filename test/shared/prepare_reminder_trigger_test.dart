import 'package:car_history/core/units.dart';
import 'package:car_history/shared/presentation/reminder_trigger_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prepareReminderTrigger', () {
    test('requires at least one trigger', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: false,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '',
        remindBeforeKmText: '',
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors!.triggerError,
        ReminderTriggerErrorCode.triggerRequired,
      );
    });

    test('accepts date trigger', () {
      final due = DateTime(2024, 6, 1);
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: true,
        useOdometer: false,
        dueAt: due,
        remindBeforeDaysText: '3',
        odometerText: '',
        remindBeforeKmText: '',
      );
      expect(result.isValid, isTrue);
      expect(result.values!.dueAt, due);
      expect(result.values!.remindBeforeDays, 3);
    });

    test('accepts odometer trigger', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: true,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '50000',
        remindBeforeKmText: '500',
      );
      expect(result.isValid, isTrue);
      expect(result.values!.dueOdometerKm, 50000);
      expect(result.values!.remindBeforeKm, 500);
    });

    test('rejects negative remind-before via domain write rules', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: true,
        useOdometer: false,
        dueAt: DateTime(2024, 6, 1),
        remindBeforeDaysText: '-1',
        odometerText: '',
        remindBeforeKmText: '',
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors!.remindBeforeDaysError,
        ReminderTriggerErrorCode.remindBeforeInvalid,
      );
    });

    test('rejects negative odometer via domain write rules', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: true,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '-10',
        remindBeforeKmText: '',
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors!.odometerError,
        ReminderTriggerErrorCode.odometerInvalid,
      );
    });

    test('accepts relative odometer offset from baseline', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: true,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '9000',
        remindBeforeKmText: '',
        odometerInputMode: ReminderOdometerInputMode.after,
        baselineOdometerKm: 180572,
      );
      expect(result.isValid, isTrue);
      expect(result.values!.dueOdometerKm, 189572);
    });

    test('rejects relative odometer without baseline', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: true,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '9000',
        remindBeforeKmText: '',
        odometerInputMode: ReminderOdometerInputMode.after,
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors!.odometerError,
        ReminderTriggerErrorCode.odometerBaselineMissing,
      );
    });

    test('rejects non-positive relative odometer offset', () {
      final result = prepareReminderTrigger(
        distanceUnit: DistanceUnit.kilometers,
        useDate: false,
        useOdometer: true,
        dueAt: null,
        remindBeforeDaysText: '',
        odometerText: '0',
        remindBeforeKmText: '',
        odometerInputMode: ReminderOdometerInputMode.after,
        baselineOdometerKm: 1000,
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors!.odometerError,
        ReminderTriggerErrorCode.odometerInvalid,
      );
    });
  });
}
