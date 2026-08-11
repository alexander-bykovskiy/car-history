import '../../domain/usecases/save_maintenance.dart';

/// Field-bound failures; the rest are shown via SnackBar.
///
/// Single source of truth for which [SaveMaintenanceFailure] values bind to
/// form fields vs snackbars. Keep [MaintenanceFormFieldErrors.apply] in sync
/// by routing through this helper only.
bool isMaintenanceFormFieldFailure(SaveMaintenanceFailure failure) {
  return switch (failure) {
    SaveMaintenanceFailure.emptyService ||
    SaveMaintenanceFailure.invalidTotal ||
    SaveMaintenanceFailure.invalidOdometer =>
      true,
    SaveMaintenanceFailure.emptyPart ||
    SaveMaintenanceFailure.invalidPartAmount ||
    SaveMaintenanceFailure.invalidPartQuantity ||
    SaveMaintenanceFailure.reminderSyncFailed =>
      false,
  };
}

/// Field-level error slots for the maintenance form.
class MaintenanceFormFieldErrors {
  SaveMaintenanceFailure? serviceError;
  SaveMaintenanceFailure? totalError;
  SaveMaintenanceFailure? odometerError;

  void clearService() => serviceError = null;
  void clearTotal() => totalError = null;
  void clearOdometer() => odometerError = null;

  void clearAll() {
    serviceError = null;
    totalError = null;
    odometerError = null;
  }

  /// Applies a field-bound failure. Non-field / null clears slots and no-ops.
  void apply(SaveMaintenanceFailure? error) {
    clearAll();
    if (error == null || !isMaintenanceFormFieldFailure(error)) return;
    switch (error) {
      case SaveMaintenanceFailure.emptyService:
        serviceError = error;
      case SaveMaintenanceFailure.invalidTotal:
        totalError = error;
      case SaveMaintenanceFailure.invalidOdometer:
        odometerError = error;
      case SaveMaintenanceFailure.emptyPart ||
            SaveMaintenanceFailure.invalidPartAmount ||
            SaveMaintenanceFailure.invalidPartQuantity ||
            SaveMaintenanceFailure.reminderSyncFailed:
        // Unreachable when [isMaintenanceFormFieldFailure] is true.
        break;
    }
  }
}
