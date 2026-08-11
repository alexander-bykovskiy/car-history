import '../repositories/backup_repository.dart';

class ExportBackupUseCase {
  ExportBackupUseCase(this._backup);

  final BackupRepository _backup;

  Future<BackupExportResult> call() => _backup.exportToFile();
}

class ShareBackupUseCase {
  ShareBackupUseCase(this._backup);

  final BackupRepository _backup;

  Future<BackupExportResult> call() => _backup.exportToShare();
}

class ImportBackupUseCase {
  ImportBackupUseCase(this._backup);

  final BackupRepository _backup;

  Future<BackupImportResult> call() => _backup.importFromFile();
}
