import '../../../../shared/data/db/app_database.dart';
import '../../domain/repositories/currency_preferences_store.dart';
import '../../domain/repositories/unit_preferences_store.dart';
import 'backup_exporter.dart';
import 'backup_import_sections.dart';
import 'backup_keys.dart';
import 'backup_results.dart';

/// Merges a versioned backup JSON map into the local database.
///
/// **Architectural exception:** import opens a single `_db.transaction` and writes
/// via Drift `into` helpers in `backup_import_*.dart`, bypassing feature
/// repositories and `TransactionRunner`.
///
/// **Dual-path checklist (required on every schema / write-rule change):**
/// 1. Update the runtime feature repository / use case under `features/*/data`.
/// 2. Update the matching section in `backup_import_*.dart` (this folder).
/// 3. Keep shared caps/helpers shared — do not copy magic numbers or
///    normalize/match loops into the importer:
///    `kMaxCars`, `isCarPhotoTooLarge` (`kMaxCarPhotoBytes`),
///    `NameNormalizer` / `matchNamedCatalogRow`,
///    `OptionalString.normalize`, `GasStationAddress.*`
///    (`backup_import_gas_stations.dart`),
///    `validateFuelingWrite` / `validateMaintenanceWrite` /
///    `validateReminderWrite`.
/// 4. Add/adjust contract tests for **both** paths
///    (`test/features/settings/backup_importer_test.dart` + feature write tests).
///    See also `.cursor/rules/backup-runtime-dual-path.mdc` (runtime ↔ backup
///    pairing table).
///
/// Invariants that must stay aligned: active named-catalog unique names,
/// `Fuelings.gasStationId` = location id, car count cap, car photo soft limit,
/// and required catalog FKs on event import (`fuelTypeId` / `serviceId` /
/// `partId`; optional FKs skip when present-but-unmapped).
/// soft-delete / restore conflict handling. See ARCHITECTURE.md →
/// "Backup ↔ runtime write checklist".
class BackupImporter {
  BackupImporter(this._db, this._units, this._currency);

  final AppDatabase _db;
  final UnitPreferencesStore _units;
  final CurrencyPreferencesStore _currency;

  static const currentVersion = BackupExporter.currentVersion;

  Future<BackupImportResult> importMap(Map<String, dynamic> root) async {
    final version = root[BackupKeys.version];
    if (version is! int || version < 1 || version > currentVersion) {
      return const BackupImportResult.failure(BackupFailure.unsupportedVersion);
    }

    final counters = BackupImportCounters();
    final sections = BackupImportSections(_db);
    final prefs = root[BackupKeys.preferences];

    try {
      await _db.transaction(() async {
        final carIdMap = await sections.importBrandsAndCars(root, counters);
        final catalogs = await sections.importNamedCatalogs(
          root,
          carIdMap: carIdMap,
          counters: counters,
        );
        await sections.importEvents(
          root,
          carIdMap: carIdMap,
          catalogs: catalogs,
          counters: counters,
        );
      });
    } catch (e) {
      return BackupImportResult.failure(BackupFailure.io, detail: e.toString());
    }

    var preferencesApplied = true;
    try {
      await BackupImportSections.applyPreferences(prefs, _units, _currency);
    } catch (e) {
      preferencesApplied = false;
    }

    return BackupImportResult.success(
      added: counters.added,
      skipped: counters.skipped,
      preferencesApplied: preferencesApplied,
    );
  }
}
