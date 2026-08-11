import '../../../l10n/app_localizations.dart';
import '../domain/usecases/save_maintenance.dart';

/// Localized message for any [SaveMaintenanceFailure] (fields + snack).
String maintenanceFailureMessage(
  AppLocalizations l10n,
  SaveMaintenanceFailure failure,
) {
  return switch (failure) {
    SaveMaintenanceFailure.emptyService => l10n.maintenanceServiceRequired,
    SaveMaintenanceFailure.invalidTotal => l10n.maintenanceTotalInvalid,
    SaveMaintenanceFailure.invalidOdometer => l10n.fuelingOdometerInvalid,
    SaveMaintenanceFailure.emptyPart => l10n.maintenancePartNameRequired,
    SaveMaintenanceFailure.invalidPartAmount =>
      l10n.maintenancePartAmountInvalid,
    SaveMaintenanceFailure.invalidPartQuantity =>
      l10n.maintenancePartQuantityInvalid,
    SaveMaintenanceFailure.reminderSyncFailed => l10n.reminderSyncFailed,
  };
}
