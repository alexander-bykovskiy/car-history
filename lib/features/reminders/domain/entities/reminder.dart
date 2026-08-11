import '../../../../core/reminder_alert_policy.dart';

export '../../../../core/reminder_alert_policy.dart' show ReminderAlertLevel;

class ReminderRecord {
  const ReminderRecord({
    required this.id,
    required this.carId,
    required this.title,
    required this.isCompleted,
    required this.isDeleted,
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
  });

  final int id;
  final int carId;
  final String title;
  final DateTime? dueAt;
  final double? dueOdometerKm;
  final int? remindBeforeDays;
  final double? remindBeforeKm;
  final bool isCompleted;
  final bool isDeleted;

  ReminderAlertInput toAlertInput() {
    return ReminderAlertInput(
      isCompleted: isCompleted,
      isDeleted: isDeleted,
      dueAt: dueAt,
      dueOdometerKm: dueOdometerKm,
      remindBeforeDays: remindBeforeDays,
      remindBeforeKm: remindBeforeKm,
    );
  }
}

class ReminderListItem {
  const ReminderListItem({
    required this.reminder,
    required this.carLabel,
  });

  final ReminderRecord reminder;
  final String carLabel;
}

class ReminderInput {
  const ReminderInput({
    required this.carId,
    required this.title,
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
    this.isCompleted = false,
  });

  final int carId;
  final String title;
  final DateTime? dueAt;
  final double? dueOdometerKm;
  final int? remindBeforeDays;
  final double? remindBeforeKm;
  final bool isCompleted;
}

enum ReminderSaveResult {
  created,
  updated,
  emptyTitle,
  emptyTrigger,
  invalidRemindBefore,
  invalidOdometer,
}

class ReminderSaveOutcome {
  const ReminderSaveOutcome(this.result, {this.reminder});

  final ReminderSaveResult result;
  final ReminderRecord? reminder;
}
