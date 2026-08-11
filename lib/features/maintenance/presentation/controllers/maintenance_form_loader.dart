import '../../../../core/number_formatting.dart';
import '../../../../core/units.dart';
import '../../../../shared/domain/odometer_repository.dart';
import '../../../catalog/domain/repositories/service_repository.dart';
import '../../../reminders/domain/repositories/reminder_repository.dart';
import '../../domain/entities/reminder_draft.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../models/draft_part_line.dart';
import '../models/maintenance_form_data.dart';

class MaintenancePartSeed {
  const MaintenancePartSeed({
    required this.name,
    required this.quantity,
    required this.unitId,
    required this.unitName,
    required this.amount,
    required this.comment,
  });

  final String name;
  final double quantity;
  final int? unitId;
  final String? unitName;
  final double? amount;
  final String? comment;
}

class MaintenanceFormHydration {
  const MaintenanceFormHydration({
    this.serviceName,
    this.parts = const [],
    this.reminderDraft,
  });

  final String? serviceName;
  final List<MaintenancePartSeed> parts;
  final ReminderDraft? reminderDraft;
}

class MaintenanceFormPrefillData {
  const MaintenanceFormPrefillData({
    this.serviceName,
    this.odometerText,
  });

  final String? serviceName;
  final String? odometerText;
}

/// Loads maintenance edit hydration / create prefill (no UI, no WidgetRef).
class MaintenanceFormLoader {
  const MaintenanceFormLoader();

  Future<MaintenanceFormHydration> loadExisting({
    required MaintenanceFormData data,
    required ServiceRepository services,
    required MaintenanceRepository maintenances,
    required ReminderRepository reminders,
  }) async {
    final maintenanceId = data.id;
    if (maintenanceId == null) {
      return const MaintenanceFormHydration();
    }

    String? serviceName;
    final serviceId = data.serviceId;
    if (serviceId != null) {
      final service = await services.getById(serviceId);
      serviceName = service?.name;
    }

    final lines = await maintenances.partsForMaintenance(maintenanceId);
    final parts = [
      for (final line in lines)
        MaintenancePartSeed(
          name: line.partName,
          quantity: line.quantity,
          unitId: line.unitId,
          unitName: line.unitName,
          amount: line.amount,
          comment: line.comment,
        ),
    ];

    ReminderDraft? reminderDraft;
    final reminderId = data.reminderId;
    if (reminderId != null) {
      final reminder = await reminders.getById(reminderId);
      if (reminder != null && !reminder.isDeleted) {
        reminderDraft = ReminderDraft(
          reminderId: reminder.id,
          dueAt: reminder.dueAt,
          dueOdometerKm: reminder.dueOdometerKm,
          remindBeforeDays: reminder.remindBeforeDays,
          remindBeforeKm: reminder.remindBeforeKm,
        );
      }
    }

    return MaintenanceFormHydration(
      serviceName: serviceName,
      parts: parts,
      reminderDraft: reminderDraft,
    );
  }

  Future<MaintenanceFormPrefillData> prefillFromLast({
    required int carId,
    required DistanceUnit distanceUnit,
    required MaintenanceRepository maintenances,
    required ServiceRepository services,
    required OdometerRepository odometer,
  }) async {
    String? serviceName;
    final latest = await maintenances.latestForCar(carId);
    if (latest != null) {
      final serviceId = latest.serviceId;
      if (serviceId != null) {
        final service = await services.getById(serviceId);
        serviceName = service?.name;
      }
    }

    String? odometerText;
    final previousKm = await odometer.maxOdometerKm(carId);
    if (previousKm != null) {
      final value = distanceUnit.fromKilometers(previousKm);
      odometerText = formatFlexibleDouble(value);
    }

    return MaintenanceFormPrefillData(
      serviceName: serviceName,
      odometerText: odometerText,
    );
  }
}

extension MaintenancePartSeedMapping on MaintenancePartSeed {
  DraftPartLine toDraft(int localId) {
    return DraftPartLine(
      localId: localId,
      name: name,
      quantity: quantity,
      unitId: unitId,
      unitName: unitName,
      amount: amount,
      comment: comment,
    );
  }
}
