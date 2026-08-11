import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_results.dart';

/// Platform file dialogs and share sheet for backup JSON.
class BackupFileIo {
  const BackupFileIo();

  Future<BackupExportResult> saveJsonFile({
    required String json,
    required String fileName,
  }) async {
    try {
      final bytes = Uint8List.fromList(utf8.encode(json));
      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          data: bytes,
          fileName: fileName,
          mimeTypesFilter: const ['application/json'],
        ),
      );
      if (savedPath == null) {
        return const BackupExportResult.failure(BackupFailure.cancelled);
      }
      return const BackupExportResult.success();
    } catch (e) {
      return BackupExportResult.failure(BackupFailure.io, detail: e.toString());
    }
  }

  /// Writes [json] to a temp file and opens the system share sheet.
  Future<BackupExportResult> shareJsonFile({
    required String json,
    required String fileName,
  }) async {
    File? tempFile;
    try {
      final dir = await getTemporaryDirectory();
      tempFile = File('${dir.path}/$fileName');
      await tempFile.writeAsString(json, encoding: utf8);

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              tempFile.path,
              mimeType: 'application/json',
              name: fileName,
            ),
          ],
        ),
      );

      return switch (result.status) {
        ShareResultStatus.dismissed =>
          const BackupExportResult.failure(BackupFailure.cancelled),
        ShareResultStatus.success || ShareResultStatus.unavailable =>
          const BackupExportResult.success(),
      };
    } catch (e) {
      return BackupExportResult.failure(BackupFailure.io, detail: e.toString());
    } finally {
      try {
        if (tempFile != null && await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {
        // Best-effort cleanup; ignore secondary IO errors.
      }
    }
  }

  /// Returns decoded JSON root map, or an error result if the user cancels /
  /// the file is empty/invalid. On success [error] is null and [map] is set.
  Future<({BackupImportResult? error, Map<String, dynamic>? map})>
      pickAndDecodeJson() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'JSON',
        extensions: <String>['json'],
      );
      final file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (file == null) {
        return (
          error: const BackupImportResult.failure(BackupFailure.cancelled),
          map: null,
        );
      }

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        return (
          error: const BackupImportResult.failure(BackupFailure.empty),
          map: null,
        );
      }

      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is! Map<String, dynamic>) {
        return (
          error: const BackupImportResult.failure(BackupFailure.invalid),
          map: null,
        );
      }

      return (error: null, map: decoded);
    } catch (e) {
      return (
        error: BackupImportResult.failure(
          BackupFailure.io,
          detail: e.toString(),
        ),
        map: null,
      );
    }
  }
}
