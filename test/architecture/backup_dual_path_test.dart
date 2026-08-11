import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards ARCHITECTURE.md "Backup ↔ runtime write checklist".
///
/// Bulk import bypasses feature repositories, so shared write helpers must stay
/// imported (and used) on the backup path. If a helper import disappears, the
/// importer is likely inventing a third copy of the rule.
void main() {
  final backupRoot = Directory('lib/features/settings/data/backup');

  test('backup events import reuses domain write validators', () {
    final facade = _read('backup_import_events.dart');
    expect(facade, contains('backup_import_reminders.dart'));
    expect(facade, contains('backup_import_fuelings.dart'));
    expect(facade, contains('backup_import_maintenances.dart'));

    final reminders = _read('backup_import_reminders.dart');
    final fuelings = _read('backup_import_fuelings.dart');
    final maintenances = _read('backup_import_maintenances.dart');
    expect(reminders, contains('reminder_write_validation.dart'));
    expect(fuelings, contains('fueling_write_validation.dart'));
    expect(maintenances, contains('maintenance_write_validation.dart'));
    expect(reminders, contains('validateReminderWrite('));
    expect(fuelings, contains('validateFuelingWrite('));
    expect(maintenances, contains('validateMaintenanceWrite('));
  });

  test('backup cars import reuses car caps / photo limit', () {
    final source = _read('backup_import_brands_cars.dart');
    expect(source, contains('car_limits.dart'));
    expect(source, contains('car_write_validation.dart'));
    expect(source, contains('kMaxCars'));
    expect(source, contains('isCarPhotoTooLarge('));
    expect(source, contains('NameNormalizer'));
  });

  test('backup named catalogs reuse match / optional helpers', () {
    final source = _read('backup_import_named_catalogs.dart');
    expect(source, contains('backup_import_gas_stations.dart'));
    expect(source, contains('backup_import_services_and_centers.dart'));
    expect(source, contains('ImportCoordinator.mergeNamedCatalog'));

    final services = _read('backup_import_services_and_centers.dart');
    expect(services, contains('named_match.dart'));
    expect(services, contains('matchNamedCatalogRow('));
    expect(services, contains('OptionalString.normalize('));
  });

  test('backup gas stations reuse address helpers', () {
    final source = _read('backup_import_gas_stations.dart');
    expect(source, contains('gas_station_address.dart'));
    expect(source, contains('GasStationAddress.normalize('));
    expect(source, contains('GasStationAddress.findLocationIn('));
  });

  test('import coordinator calls matchNamedCatalogRow for merge policy', () {
    final source = _read('import_coordinator.dart');
    expect(source, contains('named_match.dart'));
    expect(source, contains('name_normalizer.dart'));
    expect(source, contains('NameNormalizer.normalize('));
    expect(
      source,
      contains('matchNamedCatalogRow('),
      reason:
          'Coordinator must call matchNamedCatalogRow (not only mention it) '
          'so active-over-soft-deleted stays shared with runtime',
    );
  });

  test('GasStationAddress.same stays the equality primitive for findLocationIn',
      () {
    final source = File('lib/core/gas_station_address.dart').readAsStringSync();
    expect(source, contains('static bool same('));
    expect(
      source,
      contains('same('),
      reason: 'findLocationIn must keep using GasStationAddress.same',
    );
    // Ensure findLocationIn still calls same(...) — not a hand-rolled compare.
    expect(source.contains('if (!same('), isTrue);
  });

  test('backup sections facade still wires brands/catalogs/events', () {
    final source = _read('backup_import_sections.dart');
    expect(source, contains('backup_import_brands_cars.dart'));
    expect(source, contains('backup_import_named_catalogs.dart'));
    expect(source, contains('backup_import_events.dart'));
    expect(source, contains('BackupImportBrandsCars'));
    expect(source, contains('BackupImportNamedCatalogs'));
    expect(source, contains('BackupImportEvents'));
  });

  test('runtime event repos still share the same write validators', () {
    final fueling = File(
      'lib/features/fueling/data/fueling_repository_impl.dart',
    ).readAsStringSync();
    final maintenance = File(
      'lib/features/maintenance/data/maintenance_write_store.dart',
    ).readAsStringSync();
    final reminder = File(
      'lib/features/reminders/data/reminder_repository_impl.dart',
    ).readAsStringSync();

    expect(fueling, contains('validateFuelingWrite('));
    expect(maintenance, contains('validateMaintenanceWrite('));
    expect(reminder, contains('validateReminderWrite('));
  });

  test('fueling gasStationId stays a location id on both paths', () {
    final runtime = File(
      'lib/features/fueling/data/fueling_repository_impl.dart',
    ).readAsStringSync();
    final backup = _read('backup_import_fuelings.dart');

    expect(
      runtime,
      contains('gasStationLocations.id.equalsExp(_db.fuelings.gasStationId)'),
      reason: 'Runtime joins Fuelings.gasStationId to GasStationLocations',
    );
    expect(backup, contains('BackupKeys.gasStationId'));
    expect(
      _read('backup_import_named_catalogs.dart'),
      contains('locationIdMap'),
      reason: 'Import must remap location ids for fueling gasStationId',
    );
  });

  test('runtime car repo enforces photo limit via shared helper', () {
    final source = File(
      'lib/features/cars/data/car_repository_impl.dart',
    ).readAsStringSync();
    expect(source, contains('car_write_validation.dart'));
    expect(source, contains('isCarPhotoTooLarge('));
    expect(source, contains('kMaxCars'));
  });

  test('runtime car brand matching stays on shared named-match helpers', () {
    final source = File(
      'lib/features/cars/data/car_brand_repository_impl.dart',
    ).readAsStringSync();
    expect(source, contains('named_match.dart'));
    expect(source, contains('findNamedCatalogMatch('));
    expect(source, contains('NameNormalizer'));
  });

  test('runtime catalog writes reuse match / address / optional helpers', () {
    final gasStation = File(
      'lib/features/catalog/data/gas_station_write_store.dart',
    ).readAsStringSync();
    final gasEnsure = File(
      'lib/features/catalog/data/gas_station_ensure.dart',
    ).readAsStringSync();
    final serviceCenter = File(
      'lib/features/catalog/data/service_center_repository_impl.dart',
    ).readAsStringSync();
    final simpleStore = File(
      'lib/features/catalog/data/named_catalog_simple_store.dart',
    ).readAsStringSync();
    final simpleDrift = File(
      'lib/features/catalog/data/named_catalog_simple_drift.dart',
    ).readAsStringSync();
    final namedScoped = File(
      'lib/features/catalog/data/named_catalog_car_scoped_store.dart',
    ).readAsStringSync();

    expect(gasStation, contains('GasStationAddress.normalize('));
    expect(gasStation, contains('GasStationAddress.findLocationIn('));
    expect(gasStation, contains('findNamedCatalogMatch('));
    expect(gasEnsure, contains('GasStationAddress.normalize('));
    // Ensure matches via write-store findLocationMatching (which calls
    // GasStationAddress.findLocationIn) — do not require a direct call here.
    expect(gasEnsure, contains('findLocationMatching('));
    expect(serviceCenter, contains('OptionalString.normalize('));
    expect(simpleStore, contains('findNamedCatalogMatch('));
    expect(simpleDrift, contains('buildPartUnitSimpleStore'));
    expect(simpleDrift, contains('buildServiceSimpleStore'));
    expect(simpleDrift, contains('buildServiceCenterSimpleStore'));
    expect(namedScoped, contains('findNamedCatalogMatch('));
  });

  test('backup importer documents dual-path checklist', () {
    final source = File(
      '${backupRoot.path}/backup_importer.dart',
    ).readAsStringSync();
    expect(source, contains('dual-path'));
    expect(source, contains('validateFuelingWrite'));
    expect(source, contains('validateMaintenanceWrite'));
    expect(source, contains('validateReminderWrite'));
    expect(source, contains('kMaxCars'));
    expect(source, contains('isCarPhotoTooLarge'));
    expect(source, contains('NameNormalizer'));
    expect(source, contains('GasStationAddress'));
    expect(source, contains('OptionalString.normalize'));
  });

  test('runtime ↔ backup pairing files exist and stay documented', () {
    const backupSections = [
      'backup_import_events.dart',
      'backup_import_brands_cars.dart',
      'backup_import_named_catalogs.dart',
      'backup_import_gas_stations.dart',
    ];
    for (final name in backupSections) {
      expect(
        File('${backupRoot.path}/$name').existsSync(),
        isTrue,
        reason: 'Missing backup section $name',
      );
    }

    const runtimePaths = [
      'lib/features/fueling/data/fueling_repository_impl.dart',
      'lib/features/maintenance/data/maintenance_repository_impl.dart',
      'lib/features/maintenance/data/maintenance_write_store.dart',
      'lib/features/reminders/data/reminder_repository_impl.dart',
      'lib/features/cars/data/car_repository_impl.dart',
      'lib/features/cars/data/car_brand_repository_impl.dart',
      'lib/features/catalog/data/named_catalog_car_scoped_store.dart',
      'lib/features/catalog/data/named_catalog_simple_store.dart',
      'lib/features/catalog/data/named_catalog_simple_drift.dart',
      'lib/features/catalog/data/part_unit_repository_impl.dart',
      'lib/features/catalog/data/service_repository_impl.dart',
      'lib/features/catalog/data/service_center_repository_impl.dart',
      'lib/features/catalog/data/gas_station_write_store.dart',
      'lib/features/catalog/data/gas_station_ensure.dart',
    ];
    for (final path in runtimePaths) {
      expect(File(path).existsSync(), isTrue, reason: 'Missing runtime $path');
    }

    final rule = File(
      '.cursor/rules/backup-runtime-dual-path.mdc',
    ).readAsStringSync();
    final prTemplate = File('.github/PULL_REQUEST_TEMPLATE.md').readAsStringSync();
    for (final name in backupSections) {
      expect(rule, contains(name));
    }
    expect(prTemplate, contains('Backup ↔ runtime dual-path'));
    expect(prTemplate, contains('backup_import_*.dart'));
    expect(prTemplate, contains('backup_dual_path_test.dart'));
  });
}

String _read(String relativeName) {
  return File(
    'lib/features/settings/data/backup/$relativeName',
  ).readAsStringSync();
}
