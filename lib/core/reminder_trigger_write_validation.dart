/// Domain trigger / remind-before rules shared by form prepare, repository,
/// and backup import (via [validateReminderWrite] in the reminders feature).
enum ReminderTriggerWriteInvalid {
  emptyTrigger,
  invalidRemindBefore,
  invalidOdometer,
}

/// Validates persisted reminder trigger fields (no title — title is feature-owned).
ReminderTriggerWriteInvalid? validateReminderTriggerWrite({
  DateTime? dueAt,
  double? dueOdometerKm,
  int? remindBeforeDays,
  double? remindBeforeKm,
}) {
  if (dueOdometerKm != null && dueOdometerKm < 0) {
    return ReminderTriggerWriteInvalid.invalidOdometer;
  }
  if (dueAt == null && dueOdometerKm == null) {
    return ReminderTriggerWriteInvalid.emptyTrigger;
  }
  if (remindBeforeDays != null &&
      (dueAt == null || remindBeforeDays < 0)) {
    return ReminderTriggerWriteInvalid.invalidRemindBefore;
  }
  if (remindBeforeKm != null &&
      (dueOdometerKm == null || remindBeforeKm < 0)) {
    return ReminderTriggerWriteInvalid.invalidRemindBefore;
  }
  return null;
}
