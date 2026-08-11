import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../domain/usecases/backup_usecases.dart';

final exportBackupUseCaseProvider = Provider<ExportBackupUseCase>((ref) {
  return ExportBackupUseCase(ref.watch(backupRepositoryProvider));
});

final shareBackupUseCaseProvider = Provider<ShareBackupUseCase>((ref) {
  return ShareBackupUseCase(ref.watch(backupRepositoryProvider));
});

final importBackupUseCaseProvider = Provider<ImportBackupUseCase>((ref) {
  return ImportBackupUseCase(ref.watch(backupRepositoryProvider));
});
