/// Alert severity for a car reminder (date and/or odometer trigger).
enum ReminderAlertLevel { none, soon, due }

/// Fields needed to evaluate reminder alerts — no persistence types.
class ReminderAlertInput {
  const ReminderAlertInput({
    required this.isCompleted,
    required this.isDeleted,
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
  });

  final bool isCompleted;
  final bool isDeleted;
  final DateTime? dueAt;
  final double? dueOdometerKm;
  final int? remindBeforeDays;
  final double? remindBeforeKm;
}

/// Picks the strongest alert across reminders: [due] > [soon] > [none].
/// A single due (red) reminder wins over any number of soon/far ones,
/// regardless of which date or mileage is nearer.
ReminderAlertLevel highestReminderAlertLevel({
  required List<ReminderAlertInput> reminders,
  required DateTime now,
  required double? currentOdometerKm,
}) {
  var highest = ReminderAlertLevel.none;
  for (final reminder in reminders) {
    final level = reminderAlertLevelFor(
      reminder: reminder,
      now: now,
      currentOdometerKm: currentOdometerKm,
    );
    if (level == ReminderAlertLevel.due) {
      return ReminderAlertLevel.due;
    }
    if (level.index > highest.index) {
      highest = level;
    }
  }
  return highest;
}

/// Per-reminder level: either axis (date or odometer) can raise severity;
/// due on one axis is not diluted by soon/far on the other.
ReminderAlertLevel reminderAlertLevelFor({
  required ReminderAlertInput reminder,
  required DateTime now,
  required double? currentOdometerKm,
}) {
  if (reminder.isCompleted || reminder.isDeleted) {
    return ReminderAlertLevel.none;
  }

  var level = ReminderAlertLevel.none;

  final dueAt = reminder.dueAt;
  if (dueAt != null) {
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueAt.year, dueAt.month, dueAt.day);
    if (!today.isBefore(dueDay)) {
      level = ReminderAlertLevel.due;
    } else if (reminder.remindBeforeDays != null) {
      final soonStart =
          dueDay.subtract(Duration(days: reminder.remindBeforeDays!));
      if (!today.isBefore(soonStart)) {
        level = ReminderAlertLevel.soon;
      }
    }
  }

  final dueKm = reminder.dueOdometerKm;
  if (dueKm != null && currentOdometerKm != null) {
    if (currentOdometerKm >= dueKm) {
      return ReminderAlertLevel.due;
    }
    if (level != ReminderAlertLevel.due && reminder.remindBeforeKm != null) {
      final soonStart = dueKm - reminder.remindBeforeKm!;
      if (currentOdometerKm >= soonStart) {
        level = ReminderAlertLevel.soon;
      }
    }
  }

  return level;
}
