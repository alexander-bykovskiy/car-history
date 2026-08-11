import 'package:car_history/features/settings/di/backup_providers.dart';
import 'package:car_history/features/settings/domain/repositories/backup_repository.dart';
import 'package:car_history/features/settings/domain/usecases/backup_usecases.dart';
import 'package:car_history/features/settings/presentation/pages/backup_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubBackupRepository implements BackupRepository {
  @override
  Future<Map<String, Object?>> buildExportMap() async => {};

  @override
  Future<BackupExportResult> exportToFile() async =>
      const BackupExportResult.failure(BackupFailure.io);

  @override
  Future<BackupExportResult> exportToShare() async =>
      const BackupExportResult.success();

  @override
  Future<BackupImportResult> importFromFile() async =>
      const BackupImportResult.failure(BackupFailure.invalid);

  @override
  Future<BackupImportResult> importMap(Map<String, dynamic> root) async =>
      const BackupImportResult.success();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BackupPage shows localized import failure SnackBar',
      (tester) async {
    final repo = _StubBackupRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          importBackupUseCaseProvider
              .overrideWithValue(ImportBackupUseCase(repo)),
          exportBackupUseCaseProvider
              .overrideWithValue(ExportBackupUseCase(repo)),
          shareBackupUseCaseProvider
              .overrideWithValue(ShareBackupUseCase(repo)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const BackupPage(),
        ),
      ),
    );

    await tester.tap(find.text('Import from JSON'));
    await tester.pump(); // start async
    await tester.pumpAndSettle();

    expect(find.text('Backup file is not valid JSON'), findsOneWidget);
  });

  testWidgets('BackupPage shows localized export failure SnackBar',
      (tester) async {
    final repo = _StubBackupRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          importBackupUseCaseProvider
              .overrideWithValue(ImportBackupUseCase(repo)),
          exportBackupUseCaseProvider
              .overrideWithValue(ExportBackupUseCase(repo)),
          shareBackupUseCaseProvider
              .overrideWithValue(ShareBackupUseCase(repo)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const BackupPage(),
        ),
      ),
    );

    await tester.tap(find.text('Export to JSON'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Could not export backup'), findsOneWidget);
  });
}
