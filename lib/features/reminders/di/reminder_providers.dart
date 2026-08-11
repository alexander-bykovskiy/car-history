import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../domain/usecases/reminder_write_usecases.dart';

export '../../../app/di/app_providers.dart'
    show reminderRepositoryProvider, odometerRepositoryProvider;

final saveReminderUseCaseProvider = Provider<SaveReminderUseCase>((ref) {
  return SaveReminderUseCase(ref.watch(reminderRepositoryProvider));
});

final deleteReminderUseCaseProvider = Provider<DeleteReminderUseCase>((ref) {
  return DeleteReminderUseCase(ref.watch(reminderRepositoryProvider));
});

final restoreReminderUseCaseProvider = Provider<RestoreReminderUseCase>((ref) {
  return RestoreReminderUseCase(ref.watch(reminderRepositoryProvider));
});
