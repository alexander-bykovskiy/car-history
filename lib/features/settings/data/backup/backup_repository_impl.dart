import 'dart:convert';

import '../../../../shared/data/db/app_database.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/currency_preferences_store.dart';
import '../../domain/repositories/unit_preferences_store.dart';
import 'backup_exporter.dart';
import 'backup_file_io.dart';
import 'backup_importer.dart';

export '../../domain/repositories/backup_repository.dart'
    show
        BackupExportResult,
        BackupFailure,
        BackupImportResult,
        BackupRepository;

/// Exports and imports app data as a versioned JSON backup.
class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(
    AppDatabase db, {
    required UnitPreferencesStore units,
    required CurrencyPreferencesStore currency,
  })  : _exporter = BackupExporter(db, units, currency),
        _importer = BackupImporter(db, units, currency),
        _fileIo = const BackupFileIo();

  final BackupExporter _exporter;
  final BackupImporter _importer;
  final BackupFileIo _fileIo;

  static const currentVersion = BackupExporter.currentVersion;

  @override
  Future<Map<String, Object?>> buildExportMap() => _exporter.buildExportMap();

  @override
  Future<BackupExportResult> exportToFile() async {
    try {
      final prepared = await _prepareExportJson();
      return _fileIo.saveJsonFile(json: prepared.json, fileName: prepared.fileName);
    } catch (e) {
      return BackupExportResult.failure(BackupFailure.io, detail: e.toString());
    }
  }

  @override
  Future<BackupExportResult> exportToShare() async {
    try {
      final prepared = await _prepareExportJson();
      return _fileIo.shareJsonFile(json: prepared.json, fileName: prepared.fileName);
    } catch (e) {
      return BackupExportResult.failure(BackupFailure.io, detail: e.toString());
    }
  }

  Future<({String json, String fileName})> _prepareExportJson() async {
    final map = await buildExportMap();
    final json = const JsonEncoder.withIndent('  ').convert(map);
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    return (json: json, fileName: 'car_history_backup_$stamp.json');
  }

  @override
  Future<BackupImportResult> importFromFile() async {
    final picked = await _fileIo.pickAndDecodeJson();
    if (picked.error != null) return picked.error!;
    return importMap(picked.map!);
  }

  @override
  Future<BackupImportResult> importMap(Map<String, dynamic> root) =>
      _importer.importMap(root);
}
