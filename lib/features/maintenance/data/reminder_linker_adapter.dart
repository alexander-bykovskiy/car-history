import '../../reminders/domain/entities/reminder.dart';
import '../../reminders/domain/repositories/reminder_repository.dart';
import '../domain/entities/reminder_draft.dart';
import '../domain/repositories/reminder_linker.dart';

class ReminderLinkerAdapter implements ReminderLinker {
  ReminderLinkerAdapter(this._reminders);

  final ReminderRepository _reminders;

  @override
  Future<ReminderSyncResult> sync({
    required int carId,
    required String title,
    required ReminderDraft? draft,
    required int? linkedReminderId,
  }) async {
    if (draft == null) {
      if (linkedReminderId != null) {
        final existing = await _reminders.getById(linkedReminderId);
        if (existing != null) {
          await _reminders.delete(existing.id);
        }
      }
      return const ReminderSyncResult.ok();
    }

    final targetId = draft.reminderId ?? linkedReminderId;
    if (targetId != null) {
      final existing = await _reminders.getById(targetId);
      if (existing != null && !existing.isDeleted) {
        final reminderInput = ReminderInput(
          carId: carId,
          title: title,
          dueAt: draft.dueAt,
          dueOdometerKm: draft.dueOdometerKm,
          remindBeforeDays: draft.remindBeforeDays,
          remindBeforeKm: draft.remindBeforeKm,
          // Maintenance UI does not own completion — preserve existing status.
          isCompleted: existing.isCompleted,
        );
        final outcome = await _reminders.update(existing.id, reminderInput);
        final id = outcome.reminder?.id;
        if (id == null) return const ReminderSyncResult.failed();
        return ReminderSyncResult.ok(id);
      }
    }

    final reminderInput = ReminderInput(
      carId: carId,
      title: title,
      dueAt: draft.dueAt,
      dueOdometerKm: draft.dueOdometerKm,
      remindBeforeDays: draft.remindBeforeDays,
      remindBeforeKm: draft.remindBeforeKm,
    );
    final outcome = await _reminders.create(reminderInput);
    final id = outcome.reminder?.id;
    if (id == null) return const ReminderSyncResult.failed();
    return ReminderSyncResult.ok(id);
  }

  @override
  Future<void> delete(int reminderId) => _reminders.delete(reminderId);
}
