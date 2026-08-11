import '../../../../core/number_parsing.dart';
import '../../../../core/units.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/reminder_draft.dart';
import '../../domain/maintenance_write_validation.dart';
import '../../domain/usecases/save_maintenance.dart';
import '../models/draft_part_line.dart';
import '../models/maintenance_form_data.dart';

/// Maps a maintenance list item into a form DTO.
MaintenanceFormData maintenanceFormDataFromView(MaintenanceListItem view) {
  return MaintenanceFormData(
    id: view.id,
    serviceId: view.serviceId,
    reminderId: view.reminderId,
    servicedAt: view.servicedAt,
    totalAmount: view.totalAmount,
    currencyCode: view.currencyCode,
    odometerKm: view.odometerKm,
    serviceName: view.serviceName,
    serviceIconKey: view.serviceIconKey,
  );
}

class MaintenanceFormPrepareResult {
  const MaintenanceFormPrepareResult._({this.error, this.input});

  const MaintenanceFormPrepareResult.error(SaveMaintenanceFailure error)
      : this._(error: error);

  const MaintenanceFormPrepareResult.ready(SaveMaintenanceInput input)
      : this._(input: input);

  final SaveMaintenanceFailure? error;
  final SaveMaintenanceInput? input;

  bool get isReady => input != null;
}

/// Parses and validates maintenance form fields into a [SaveMaintenanceInput].
MaintenanceFormPrepareResult prepareMaintenanceSave({
  required int carId,
  required String serviceName,
  required DateTime servicedAt,
  required String totalText,
  required String odometerText,
  required String currencyCode,
  required DistanceUnit distanceUnit,
  required List<DraftPartLine> parts,
  ReminderDraft? reminderDraft,
  int? linkedReminderId,
  int? existingId,
}) {
  final trimmedService = serviceName.trim();
  if (trimmedService.isEmpty) {
    return const MaintenanceFormPrepareResult.error(
      SaveMaintenanceFailure.emptyService,
    );
  }

  final totalRaw = totalText.trim();
  final totalInput = totalRaw.isEmpty ? null : parseFlexibleDouble(totalRaw);
  if (totalRaw.isNotEmpty && totalInput == null) {
    return const MaintenanceFormPrepareResult.error(
      SaveMaintenanceFailure.invalidTotal,
    );
  }

  final odometerRaw = odometerText.trim();
  final odometerInput =
      odometerRaw.isEmpty ? null : parseFlexibleDouble(odometerRaw);
  if (odometerRaw.isNotEmpty && odometerInput == null) {
    return const MaintenanceFormPrepareResult.error(
      SaveMaintenanceFailure.invalidOdometer,
    );
  }

  final odometerKm = odometerInput == null
      ? null
      : distanceUnit.toKilometers(odometerInput);

  final writeError = validateMaintenanceWrite(
    totalAmount: totalInput,
    odometerKm: odometerKm,
    parts: [
      for (final line in parts)
        MaintenancePartInput(
          partId: 0,
          quantity: line.quantity,
          amount: line.amount,
        ),
    ],
  );
  if (writeError != null) {
    final failure = mapMaintenanceSaveResultToFailure(writeError);
    if (failure != null) {
      return MaintenanceFormPrepareResult.error(failure);
    }
  }

  return MaintenanceFormPrepareResult.ready(
    SaveMaintenanceInput(
      carId: carId,
      serviceName: trimmedService,
      servicedAt: servicedAt,
      totalAmount: totalInput,
      currencyCode: currencyCode,
      odometerKm: odometerKm,
      parts: [
        for (final line in parts)
          SaveMaintenancePartDraft(
            name: line.name,
            quantity: line.quantity,
            unitId: line.unitId,
            amount: line.amount,
            comment: line.comment,
          ),
      ],
      reminderDraft: reminderDraft,
      linkedReminderId: linkedReminderId,
      existingId: existingId,
    ),
  );
}
