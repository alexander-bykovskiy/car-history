import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../data/catalog_ensurer_adapters.dart';
import '../data/reminder_linker_adapter.dart';
import '../domain/repositories/catalog_ports.dart';
import '../domain/repositories/reminder_linker.dart';
import '../domain/usecases/delete_maintenance.dart';
import '../domain/usecases/save_maintenance.dart';

export '../../../app/di/app_providers.dart'
    show
        maintenanceRepositoryProvider,
        odometerRepositoryProvider,
        partRepositoryProvider,
        partUnitRepositoryProvider,
        reminderRepositoryProvider,
        serviceRepositoryProvider;

final serviceEnsurerProvider = Provider<ServiceEnsurer>((ref) {
  return ServiceEnsurerAdapter(ref.watch(serviceRepositoryProvider));
});

final partEnsurerProvider = Provider<PartEnsurer>((ref) {
  return PartEnsurerAdapter(ref.watch(partRepositoryProvider));
});

final reminderLinkerProvider = Provider<ReminderLinker>((ref) {
  return ReminderLinkerAdapter(ref.watch(reminderRepositoryProvider));
});

final saveMaintenanceUseCaseProvider = Provider<SaveMaintenanceUseCase>((ref) {
  return SaveMaintenanceUseCase(
    maintenanceRepository: ref.watch(maintenanceRepositoryProvider),
    serviceEnsurer: ref.watch(serviceEnsurerProvider),
    partEnsurer: ref.watch(partEnsurerProvider),
    reminderLinker: ref.watch(reminderLinkerProvider),
    transactionRunner: ref.watch(transactionRunnerProvider),
  );
});

final deleteMaintenanceUseCaseProvider =
    Provider<DeleteMaintenanceUseCase>((ref) {
  return DeleteMaintenanceUseCase(
    maintenanceRepository: ref.watch(maintenanceRepositoryProvider),
    reminderLinker: ref.watch(reminderLinkerProvider),
    transactionRunner: ref.watch(transactionRunnerProvider),
  );
});
