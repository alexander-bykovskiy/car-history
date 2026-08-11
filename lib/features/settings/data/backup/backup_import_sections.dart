import '../../../../core/units.dart';
import '../../../../shared/data/db/app_database.dart';
import '../../domain/repositories/currency_preferences_store.dart';
import '../../domain/repositories/unit_preferences_store.dart';
import 'backup_import_brands_cars.dart';
import 'backup_import_events.dart';
import 'backup_import_models.dart';
import 'backup_import_named_catalogs.dart';
import 'backup_keys.dart';

export 'backup_import_models.dart';

/// Logical sections of [BackupImporter.importMap], extracted for readability.
///
/// Callers must invoke DB-touching methods inside an existing transaction.
///
/// These sections bypass feature repositories. When changing merge / uniqueness
/// / soft-delete rules here, update the matching runtime write path and contract
/// tests (see [BackupImporter] dual-path checklist).
class BackupImportSections {
  BackupImportSections(AppDatabase db)
      : _brandsCars = BackupImportBrandsCars(db),
        _namedCatalogs = BackupImportNamedCatalogs(db),
        _events = BackupImportEvents(db);

  final BackupImportBrandsCars _brandsCars;
  final BackupImportNamedCatalogs _namedCatalogs;
  final BackupImportEvents _events;

  Future<Map<int, int>> importBrandsAndCars(
    Map<String, dynamic> root,
    BackupImportCounters counters,
  ) =>
      _brandsCars.import(root, counters);

  /// Merges named catalogs, gas stations, and car-restricted link tables.
  Future<BackupCatalogIdMaps> importNamedCatalogs(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupImportCounters counters,
  }) =>
      _namedCatalogs.import(
        root,
        carIdMap: carIdMap,
        counters: counters,
      );

  /// Merges reminders, fuelings, maintenances and related maintenance parts.
  Future<void> importEvents(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupCatalogIdMaps catalogs,
    required BackupImportCounters counters,
  }) =>
      _events.import(
        root,
        carIdMap: carIdMap,
        catalogs: catalogs,
        counters: counters,
      );

  /// Applies units/currency preferences from the backup root (outside DB tx).
  static Future<void> applyPreferences(
    Object? prefs,
    UnitPreferencesStore units,
    CurrencyPreferencesStore currency,
  ) async {
    if (prefs is! Map<String, dynamic>) return;

    final fuel = prefs[BackupKeys.fuelVolumeUnit];
    if (fuel is String) {
      final match =
          FuelVolumeUnit.values.where((u) => u.name == fuel).firstOrNull;
      if (match != null) await units.setFuelVolumeUnit(match);
    }
    final distance = prefs[BackupKeys.distanceUnit];
    if (distance is String) {
      final match =
          DistanceUnit.values.where((u) => u.name == distance).firstOrNull;
      if (match != null) await units.setDistanceUnit(match);
    }
    final currencyCode = prefs[BackupKeys.currencyCode];
    if (currencyCode is String) {
      await currency.setCurrencyCode(currencyCode);
    }
    final codesRaw = prefs[BackupKeys.currencyCodes];
    if (codesRaw is List) {
      await currency.setCurrencyCodes(
        [
          for (final item in codesRaw)
            if (item is String) item,
        ],
      );
    }
  }
}
