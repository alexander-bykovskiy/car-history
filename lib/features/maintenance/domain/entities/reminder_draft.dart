/// Draft reminder fields attached to a maintenance form (title from service).
class ReminderDraft {
  const ReminderDraft({
    this.reminderId,
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
  });

  final int? reminderId;
  final DateTime? dueAt;
  final double? dueOdometerKm;
  final int? remindBeforeDays;
  final double? remindBeforeKm;

  ReminderDraft copyWith({
    int? reminderId,
    DateTime? dueAt,
    double? dueOdometerKm,
    int? remindBeforeDays,
    double? remindBeforeKm,
  }) {
    return ReminderDraft(
      reminderId: reminderId ?? this.reminderId,
      dueAt: dueAt ?? this.dueAt,
      dueOdometerKm: dueOdometerKm ?? this.dueOdometerKm,
      remindBeforeDays: remindBeforeDays ?? this.remindBeforeDays,
      remindBeforeKm: remindBeforeKm ?? this.remindBeforeKm,
    );
  }
}
