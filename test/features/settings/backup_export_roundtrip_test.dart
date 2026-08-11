import 'package:car_history/features/settings/data/backup/backup_exporter.dart';
import 'package:car_history/features/settings/data/backup/backup_importer.dart';
import 'package:car_history/features/settings/data/backup/backup_keys.dart';
import 'package:car_history/features/settings/data/currency_preferences.dart';
import 'package:car_history/features/settings/data/unit_preferences.dart';
import 'package:car_history/features/settings/domain/repositories/backup_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('BackupExporter map re-imports cleanly', () async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final units = PrefsUnitPreferencesStore();
    final currency = PrefsCurrencyPreferencesStore();
    final exporter = BackupExporter(db, units, currency);
    final map = await exporter.buildExportMap();

    expect(map[BackupKeys.version], BackupExporter.currentVersion);
    expect(map[BackupKeys.exportedAt], isA<String>());
    for (final key in BackupKeys.rootSections) {
      expect(map.containsKey(key), isTrue, reason: 'missing root key $key');
    }
    expect(map[BackupKeys.cars], isA<List>());
    expect(map[BackupKeys.preferences], isA<Map>());

    final prefs = map[BackupKeys.preferences]! as Map;
    expect(prefs.containsKey(BackupKeys.fuelVolumeUnit), isTrue);
    expect(prefs.containsKey(BackupKeys.distanceUnit), isTrue);
    expect(prefs.containsKey(BackupKeys.currencyCode), isTrue);
    expect(prefs.containsKey(BackupKeys.currencyCodes), isTrue);

    final importer = BackupImporter(db, units, currency);
    final result = await importer.importMap(
      Map<String, dynamic>.from(
        map.map((key, value) => MapEntry(key, value)),
      ),
    );
    expect(result.ok, isTrue);
    expect(result.failure, isNull);
  });

  test('BackupImporter rejects unsupported version', () async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final units = PrefsUnitPreferencesStore();
    final currency = PrefsCurrencyPreferencesStore();
    final importer = BackupImporter(db, units, currency);
    final result = await importer.importMap({
      BackupKeys.version: BackupExporter.currentVersion + 1,
      BackupKeys.preferences: <String, Object?>{},
    });
    expect(result.ok, isFalse);
    expect(result.failure, BackupFailure.unsupportedVersion);
  });
}
