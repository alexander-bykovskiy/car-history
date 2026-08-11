/// Export/import of app data as a versioned JSON backup.
abstract class BackupRepository {
  Future<Map<String, Object?>> buildExportMap();
  Future<BackupExportResult> exportToFile();
  Future<BackupExportResult> exportToShare();
  Future<BackupImportResult> importFromFile();
  Future<BackupImportResult> importMap(Map<String, dynamic> root);
}

/// Typed backup failure (no stringly error codes).
enum BackupFailure {
  cancelled,
  empty,
  invalid,
  unsupportedVersion,
  io,
}

class BackupExportResult {
  const BackupExportResult({
    required this.ok,
    this.failure,
    this.detail,
  });

  const BackupExportResult.success() : this(ok: true);

  const BackupExportResult.failure(
    this.failure, {
    this.detail,
  }) : ok = false;

  final bool ok;
  final BackupFailure? failure;
  final String? detail;
}

class BackupImportResult {
  const BackupImportResult({
    required this.ok,
    this.failure,
    this.detail,
    this.added = 0,
    this.skipped = 0,
    this.preferencesApplied = true,
  });

  const BackupImportResult.success({
    this.added = 0,
    this.skipped = 0,
    this.preferencesApplied = true,
  })  : ok = true,
        failure = null,
        detail = null;

  const BackupImportResult.failure(
    this.failure, {
    this.detail,
  })  : ok = false,
        added = 0,
        skipped = 0,
        preferencesApplied = true;

  final bool ok;
  final BackupFailure? failure;
  final String? detail;
  final int added;
  final int skipped;

  /// False when DB merge succeeded but SharedPreferences apply threw.
  final bool preferencesApplied;
}
