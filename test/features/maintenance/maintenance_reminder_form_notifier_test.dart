import 'package:car_history/core/units.dart';
import 'package:car_history/features/maintenance/domain/entities/reminder_draft.dart';
import 'package:car_history/features/maintenance/presentation/controllers/maintenance_reminder_form_notifier.dart';
import 'package:car_history/shared/presentation/reminder_trigger_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaintenanceReminderFormNotifier', () {
    test('submit saves date trigger draft', () {
      final form = MaintenanceReminderFormNotifier(
        distanceUnit: DistanceUnit.kilometers,
      );
      final due = DateTime(2024, 6, 1);
      form.setDueAt(due);

      final outcome = form.submit(
        remindBeforeDaysText: '2',
        odometerText: '',
        remindBeforeKmText: '',
      );

      expect(outcome, isA<MaintenanceReminderFormSaved>());
      final draft = (outcome as MaintenanceReminderFormSaved).draft;
      expect(draft.dueAt, due);
      expect(draft.remindBeforeDays, 2);
    });

    test('submit returns fieldError without trigger', () {
      final form = MaintenanceReminderFormNotifier(
        distanceUnit: DistanceUnit.kilometers,
        initial: const ReminderDraft(),
      );
      form.setUseDate(false);
      form.setUseOdometer(false);

      final outcome = form.submit(
        remindBeforeDaysText: '',
        odometerText: '',
        remindBeforeKmText: '',
      );

      expect(outcome, isA<MaintenanceReminderFormFieldError>());
      expect(form.triggerError, ReminderTriggerErrorCode.triggerRequired);
    });
  });
}
