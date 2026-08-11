import '../../../core/reminder_alert_policy.dart';
import 'entities/reminder.dart';

/// due (red) → soon (orange) → far (gray) → completed → deleted.
///
/// Within the same bucket, sorts by title. Used by the reminders list (and any
/// future surface that needs the same priority order).
int compareRemindersByAlertPriority(
  ReminderListItem a,
  ReminderListItem b, {
  required DateTime now,
  required Map<int, double?> odometersByCar,
}) {
  final aRem = a.reminder;
  final bRem = b.reminder;
  final aInactive = aRem.isCompleted || aRem.isDeleted;
  final bInactive = bRem.isCompleted || bRem.isDeleted;
  if (aInactive != bInactive) {
    return aInactive ? 1 : -1;
  }
  if (aInactive) {
    if (aRem.isDeleted != bRem.isDeleted) {
      return aRem.isDeleted ? 1 : -1;
    }
    return aRem.title.compareTo(bRem.title);
  }

  final aLevel = reminderAlertLevelFor(
    reminder: aRem.toAlertInput(),
    now: now,
    currentOdometerKm: odometersByCar[aRem.carId],
  );
  final bLevel = reminderAlertLevelFor(
    reminder: bRem.toAlertInput(),
    now: now,
    currentOdometerKm: odometersByCar[bRem.carId],
  );
  final byLevel = bLevel.index.compareTo(aLevel.index);
  if (byLevel != 0) return byLevel;
  return aRem.title.compareTo(bRem.title);
}
