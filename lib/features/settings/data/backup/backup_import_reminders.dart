import 'package:drift/drift.dart';

import '../../../../shared/data/db/app_database.dart';
import '../../../reminders/domain/reminder_write_validation.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Merges reminder rows from a backup root.
class BackupImportReminders {
  BackupImportReminders(this._db);

  final AppDatabase _db;

  /// Returns backup-local reminder id → database id.
  Future<Map<int, int>> import(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupImportCounters counters,
  }) async {
    final reminderIdMap = <int, int>{};
    final existingReminders = await _db.select(_db.reminders).get();
    for (final item in BackupJsonCodec.list(root[BackupKeys.reminders])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final oldCarId = BackupJsonCodec.asInt(item[BackupKeys.carId]);
      if (oldId == null || oldCarId == null) continue;
      final carId = carIdMap[oldCarId];
      if (carId == null) continue;

      final title =
          BackupJsonCodec.asString(item[BackupKeys.title])?.trim() ?? '';
      final dueAt = BackupJsonCodec.parseDt(item[BackupKeys.dueAt]);
      final dueOdometerKm =
          BackupJsonCodec.asDouble(item[BackupKeys.dueOdometerKm]);
      final remindBeforeDays =
          BackupJsonCodec.asInt(item[BackupKeys.remindBeforeDays]);
      final remindBeforeKm =
          BackupJsonCodec.asDouble(item[BackupKeys.remindBeforeKm]);
      final isCompleted = item[BackupKeys.isCompleted] == true;
      final isDeleted = item[BackupKeys.isDeleted] == true;

      // Keep import aligned with runtime ReminderRepository write rules.
      if (validateReminderWrite(
            title: title,
            dueAt: dueAt,
            dueOdometerKm: dueOdometerKm,
            remindBeforeDays: remindBeforeDays,
            remindBeforeKm: remindBeforeKm,
          ) !=
          null) {
        counters.skipped++;
        continue;
      }

      Reminder? match;
      for (final row in existingReminders) {
        if (row.carId == carId &&
            row.title.trim() == title &&
            BackupJsonCodec.sameDt(row.dueAt, dueAt) &&
            BackupJsonCodec.sameDouble(row.dueOdometerKm, dueOdometerKm) &&
            row.remindBeforeDays == remindBeforeDays &&
            BackupJsonCodec.sameDouble(row.remindBeforeKm, remindBeforeKm) &&
            row.isCompleted == isCompleted &&
            row.isDeleted == isDeleted) {
          match = row;
          break;
        }
      }
      if (match != null) {
        reminderIdMap[oldId] = match.id;
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.reminders).insert(
            RemindersCompanion.insert(
              carId: carId,
              title: title,
              dueAt: Value(dueAt),
              dueOdometerKm: Value(dueOdometerKm),
              remindBeforeDays: Value(remindBeforeDays),
              remindBeforeKm: Value(remindBeforeKm),
              isCompleted: Value(isCompleted),
              isDeleted: Value(isDeleted),
              createdAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
              ),
              updatedAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
              ),
            ),
          );
      reminderIdMap[oldId] = newId;
      existingReminders.add(
        Reminder(
          id: newId,
          carId: carId,
          title: title,
          dueAt: dueAt,
          dueOdometerKm: dueOdometerKm,
          remindBeforeDays: remindBeforeDays,
          remindBeforeKm: remindBeforeKm,
          isCompleted: isCompleted,
          isDeleted: isDeleted,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;
    }
    return reminderIdMap;
  }
}
