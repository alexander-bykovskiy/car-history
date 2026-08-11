import '../../../core/reminder_trigger_write_validation.dart';
import 'entities/reminder.dart';

/// Domain write checks for persisted reminders.
///
/// Shared by repository `_validate` and backup reminder import so title /
/// trigger / remind-before rules stay in one place. Form prepare closes the
/// same trigger rules via [validateReminderTriggerWrite] in `core/`.
ReminderSaveResult? validateReminderWrite({
  required String title,
  DateTime? dueAt,
  double? dueOdometerKm,
  int? remindBeforeDays,
  double? remindBeforeKm,
}) {
  if (title.trim().isEmpty) {
    return ReminderSaveResult.emptyTitle;
  }
  final triggerInvalid = validateReminderTriggerWrite(
    dueAt: dueAt,
    dueOdometerKm: dueOdometerKm,
    remindBeforeDays: remindBeforeDays,
    remindBeforeKm: remindBeforeKm,
  );
  return switch (triggerInvalid) {
    ReminderTriggerWriteInvalid.emptyTrigger => ReminderSaveResult.emptyTrigger,
    ReminderTriggerWriteInvalid.invalidRemindBefore =>
      ReminderSaveResult.invalidRemindBefore,
    ReminderTriggerWriteInvalid.invalidOdometer =>
      ReminderSaveResult.invalidOdometer,
    null => null,
  };
}
