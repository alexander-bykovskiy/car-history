import '../../domain/usecases/save_maintenance.dart';

sealed class MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitOutcome();

  const factory MaintenanceFormSubmitOutcome.success() =
      MaintenanceFormSubmitSuccess;
  const factory MaintenanceFormSubmitOutcome.cancelled() =
      MaintenanceFormSubmitCancelled;
  const factory MaintenanceFormSubmitOutcome.busy() = MaintenanceFormSubmitBusy;
  const factory MaintenanceFormSubmitOutcome.fieldError(
    SaveMaintenanceFailure error,
  ) = MaintenanceFormSubmitFieldError;
  const factory MaintenanceFormSubmitOutcome.snack(
    SaveMaintenanceFailure error,
  ) = MaintenanceFormSubmitSnack;
  const factory MaintenanceFormSubmitOutcome.unexpected() =
      MaintenanceFormSubmitUnexpected;
}

class MaintenanceFormSubmitSuccess extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitSuccess();
}

class MaintenanceFormSubmitCancelled extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitCancelled();
}

class MaintenanceFormSubmitBusy extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitBusy();
}

class MaintenanceFormSubmitFieldError extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitFieldError(this.error);
  final SaveMaintenanceFailure error;
}

class MaintenanceFormSubmitSnack extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitSnack(this.error);
  final SaveMaintenanceFailure error;
}

class MaintenanceFormSubmitUnexpected extends MaintenanceFormSubmitOutcome {
  const MaintenanceFormSubmitUnexpected();
}
