import '../../../../shared/domain/transaction_abort.dart';
import '../../../../shared/domain/transaction_runner.dart';
import '../entities/maintenance.dart';
import '../entities/maintenance_save.dart';
import '../entities/reminder_draft.dart';
import '../repositories/catalog_ports.dart';
import '../repositories/maintenance_repository.dart';
import '../repositories/reminder_linker.dart';

class SaveMaintenancePartDraft {
  const SaveMaintenancePartDraft({
    required this.name,
    required this.quantity,
    this.unitId,
    this.amount,
    this.comment,
  });

  final String name;
  final double quantity;
  final int? unitId;
  final double? amount;
  final String? comment;
}

class SaveMaintenanceInput {
  const SaveMaintenanceInput({
    required this.carId,
    required this.serviceName,
    required this.servicedAt,
    required this.currencyCode,
    this.totalAmount,
    this.odometerKm,
    this.parts = const [],
    this.reminderDraft,
    this.linkedReminderId,
    this.existingId,
  });

  final int carId;
  final String serviceName;
  final DateTime servicedAt;
  final String currencyCode;
  final double? totalAmount;
  final double? odometerKm;
  final List<SaveMaintenancePartDraft> parts;
  final ReminderDraft? reminderDraft;
  final int? linkedReminderId;
  final int? existingId;

  bool get isEditing => existingId != null;
}

enum SaveMaintenanceFailure {
  emptyService,
  emptyPart,
  invalidTotal,
  invalidOdometer,
  invalidPartAmount,
  invalidPartQuantity,
  reminderSyncFailed,
}

/// Maps repository validation codes to use-case failures (null = success).
SaveMaintenanceFailure? mapMaintenanceSaveResultToFailure(
  MaintenanceSaveResult result,
) {
  return switch (result) {
    MaintenanceSaveResult.created || MaintenanceSaveResult.updated => null,
    MaintenanceSaveResult.invalidTotal => SaveMaintenanceFailure.invalidTotal,
    MaintenanceSaveResult.invalidOdometer =>
      SaveMaintenanceFailure.invalidOdometer,
    MaintenanceSaveResult.invalidPartAmount =>
      SaveMaintenanceFailure.invalidPartAmount,
    MaintenanceSaveResult.invalidPartQuantity =>
      SaveMaintenanceFailure.invalidPartQuantity,
  };
}

class SaveMaintenanceResult {
  const SaveMaintenanceResult._({this.failure, this.outcome});

  const SaveMaintenanceResult.ok(MaintenanceSaveOutcome outcome)
      : this._(outcome: outcome);

  const SaveMaintenanceResult.fail(SaveMaintenanceFailure failure)
      : this._(failure: failure);

  final SaveMaintenanceFailure? failure;
  final MaintenanceSaveOutcome? outcome;

  bool get isSuccess =>
      outcome != null &&
      (outcome!.result == MaintenanceSaveResult.created ||
          outcome!.result == MaintenanceSaveResult.updated);
}

class SaveMaintenanceUseCase {
  SaveMaintenanceUseCase({
    required MaintenanceRepository maintenanceRepository,
    required ServiceEnsurer serviceEnsurer,
    required PartEnsurer partEnsurer,
    required ReminderLinker reminderLinker,
    required TransactionRunner transactionRunner,
  })  : _maintenances = maintenanceRepository,
        _services = serviceEnsurer,
        _parts = partEnsurer,
        _reminders = reminderLinker,
        _tx = transactionRunner;

  final MaintenanceRepository _maintenances;
  final ServiceEnsurer _services;
  final PartEnsurer _parts;
  final ReminderLinker _reminders;
  final TransactionRunner _tx;

  Future<SaveMaintenanceResult> call(SaveMaintenanceInput input) async {
    final serviceName = input.serviceName.trim();
    if (serviceName.isEmpty) {
      return const SaveMaintenanceResult.fail(
        SaveMaintenanceFailure.emptyService,
      );
    }

    try {
      return await _tx.runInTransaction(() async {
        final service = await _services.ensure(serviceName);
        if (service == null) {
          throw TransactionAbort<SaveMaintenanceResult>(
            const SaveMaintenanceResult.fail(
              SaveMaintenanceFailure.emptyService,
            ),
          );
        }

        final partInputs = <MaintenancePartInput>[];
        for (final line in input.parts) {
          final part = await _parts.ensureForCar(line.name, input.carId);
          if (part == null) {
            throw TransactionAbort<SaveMaintenanceResult>(
              const SaveMaintenanceResult.fail(
                SaveMaintenanceFailure.emptyPart,
              ),
            );
          }
          partInputs.add(
            MaintenancePartInput(
              partId: part.id,
              quantity: line.quantity,
              unitId: line.unitId,
              amount: line.amount,
              comment: line.comment,
            ),
          );
        }

        final reminderSync = await _reminders.sync(
          carId: input.carId,
          title: service.name,
          draft: input.reminderDraft,
          linkedReminderId: input.linkedReminderId,
        );
        if (reminderSync.failed) {
          throw TransactionAbort<SaveMaintenanceResult>(
            const SaveMaintenanceResult.fail(
              SaveMaintenanceFailure.reminderSyncFailed,
            ),
          );
        }
        final reminderId = reminderSync.reminderId;

        final outcome = input.isEditing
            ? await _maintenances.update(
                id: input.existingId!,
                serviceId: service.id,
                servicedAt: input.servicedAt,
                totalAmount: input.totalAmount,
                currencyCode: input.currencyCode,
                odometerKm: input.odometerKm,
                reminderId: reminderId,
                parts: partInputs,
              )
            : await _maintenances.create(
                carId: input.carId,
                serviceId: service.id,
                servicedAt: input.servicedAt,
                totalAmount: input.totalAmount,
                currencyCode: input.currencyCode,
                odometerKm: input.odometerKm,
                reminderId: reminderId,
                parts: partInputs,
              );

        final failure = mapMaintenanceSaveResultToFailure(outcome.result);
        if (failure == null) {
          return SaveMaintenanceResult.ok(outcome);
        }
        throw TransactionAbort<SaveMaintenanceResult>(
          SaveMaintenanceResult.fail(failure),
        );
      });
    } on TransactionAbort<SaveMaintenanceResult> catch (abort) {
      return abort.result;
    }
  }
}
