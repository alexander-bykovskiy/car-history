import '../../domain/usecases/save_fueling.dart';

sealed class FuelingFormSubmitOutcome {
  const FuelingFormSubmitOutcome();

  const factory FuelingFormSubmitOutcome.success() = FuelingFormSubmitSuccess;
  const factory FuelingFormSubmitOutcome.cancelled() =
      FuelingFormSubmitCancelled;
  const factory FuelingFormSubmitOutcome.busy() = FuelingFormSubmitBusy;
  const factory FuelingFormSubmitOutcome.fieldError(SaveFuelingFailure error) =
      FuelingFormSubmitFieldError;
  const factory FuelingFormSubmitOutcome.unexpected() =
      FuelingFormSubmitUnexpected;
}

class FuelingFormSubmitSuccess extends FuelingFormSubmitOutcome {
  const FuelingFormSubmitSuccess();
}

class FuelingFormSubmitCancelled extends FuelingFormSubmitOutcome {
  const FuelingFormSubmitCancelled();
}

class FuelingFormSubmitBusy extends FuelingFormSubmitOutcome {
  const FuelingFormSubmitBusy();
}

class FuelingFormSubmitFieldError extends FuelingFormSubmitOutcome {
  const FuelingFormSubmitFieldError(this.error);
  final SaveFuelingFailure error;
}

class FuelingFormSubmitUnexpected extends FuelingFormSubmitOutcome {
  const FuelingFormSubmitUnexpected();
}
