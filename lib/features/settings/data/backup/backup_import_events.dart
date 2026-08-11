import '../../../../shared/data/db/app_database.dart';
import 'backup_import_fuelings.dart';
import 'backup_import_maintenances.dart';
import 'backup_import_models.dart';
import 'backup_import_reminders.dart';

/// Facade: merges reminders, fuelings, maintenances and maintenance parts.
///
/// Split implementations live in `backup_import_{reminders,fuelings,maintenances}.dart`.
class BackupImportEvents {
  BackupImportEvents(AppDatabase db)
      : _reminders = BackupImportReminders(db),
        _fuelings = BackupImportFuelings(db),
        _maintenances = BackupImportMaintenances(db);

  final BackupImportReminders _reminders;
  final BackupImportFuelings _fuelings;
  final BackupImportMaintenances _maintenances;

  Future<void> import(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupCatalogIdMaps catalogs,
    required BackupImportCounters counters,
  }) async {
    final reminderIdMap = await _reminders.import(
      root,
      carIdMap: carIdMap,
      counters: counters,
    );
    await _fuelings.import(
      root,
      carIdMap: carIdMap,
      catalogs: catalogs,
      counters: counters,
    );
    await _maintenances.import(
      root,
      carIdMap: carIdMap,
      reminderIdMap: reminderIdMap,
      catalogs: catalogs,
      counters: counters,
    );
  }
}
