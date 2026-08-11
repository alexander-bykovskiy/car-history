/// Syncs / clears a reminder linked to a maintenance record.
library;

import '../entities/reminder_draft.dart';

/// Result of syncing / clearing a reminder linked to a maintenance record.
class ReminderSyncResult {
  const ReminderSyncResult.ok([this.reminderId]) : failed = false;

  const ReminderSyncResult.failed()
      : reminderId = null,
        failed = true;

  final int? reminderId;
  final bool failed;
}

/// Syncs / clears a reminder linked to a maintenance record.
abstract class ReminderLinker {
  Future<ReminderSyncResult> sync({
    required int carId,
    required String title,
    required ReminderDraft? draft,
    required int? linkedReminderId,
  });

  /// Soft-deletes a linked reminder (e.g. when the maintenance is deleted).
  Future<void> delete(int reminderId);
}
