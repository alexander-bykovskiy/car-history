import '../../domain/usecases/car_write_usecases.dart';

/// Snack payload for the car form: reuse [SaveCarFailure] when possible;
/// local-only cases cover prepare/delete paths that are not use-case failures.
sealed class CarFormSnack {
  const CarFormSnack();

  const factory CarFormSnack.save(SaveCarFailure failure) = CarFormSnackSave;
  const factory CarFormSnack.yearInvalid() = CarFormSnackYearInvalid;
  const factory CarFormSnack.deleteLastBlocked() = CarFormSnackDeleteLastBlocked;
}

class CarFormSnackSave extends CarFormSnack {
  const CarFormSnackSave(this.failure);
  final SaveCarFailure failure;
}

class CarFormSnackYearInvalid extends CarFormSnack {
  const CarFormSnackYearInvalid();
}

class CarFormSnackDeleteLastBlocked extends CarFormSnack {
  const CarFormSnackDeleteLastBlocked();
}

sealed class CarFormSubmitOutcome {
  const CarFormSubmitOutcome();

  const factory CarFormSubmitOutcome.success() = CarFormSubmitSuccess;
  const factory CarFormSubmitOutcome.busy() = CarFormSubmitBusy;
  const factory CarFormSubmitOutcome.fieldError() = CarFormSubmitFieldError;
  const factory CarFormSubmitOutcome.deleted() = CarFormSubmitDeleted;
  const factory CarFormSubmitOutcome.snack(CarFormSnack snack) =
      CarFormSubmitSnack;
  const factory CarFormSubmitOutcome.unexpected() = CarFormSubmitUnexpected;
}

class CarFormSubmitSuccess extends CarFormSubmitOutcome {
  const CarFormSubmitSuccess();
}

class CarFormSubmitBusy extends CarFormSubmitOutcome {
  const CarFormSubmitBusy();
}

class CarFormSubmitFieldError extends CarFormSubmitOutcome {
  const CarFormSubmitFieldError();
}

class CarFormSubmitDeleted extends CarFormSubmitOutcome {
  const CarFormSubmitDeleted();
}

class CarFormSubmitSnack extends CarFormSubmitOutcome {
  const CarFormSubmitSnack(this.snack);
  final CarFormSnack snack;
}

class CarFormSubmitUnexpected extends CarFormSubmitOutcome {
  const CarFormSubmitUnexpected();
}

sealed class CarPhotoPickOutcome {
  const CarPhotoPickOutcome();

  const factory CarPhotoPickOutcome.success() = CarPhotoPickSuccess;
  const factory CarPhotoPickOutcome.cancelled() = CarPhotoPickCancelled;
  const factory CarPhotoPickOutcome.tooLarge() = CarPhotoPickTooLarge;
  const factory CarPhotoPickOutcome.failed() = CarPhotoPickFailed;
}

class CarPhotoPickSuccess extends CarPhotoPickOutcome {
  const CarPhotoPickSuccess();
}

class CarPhotoPickCancelled extends CarPhotoPickOutcome {
  const CarPhotoPickCancelled();
}

class CarPhotoPickTooLarge extends CarPhotoPickOutcome {
  const CarPhotoPickTooLarge();
}

class CarPhotoPickFailed extends CarPhotoPickOutcome {
  const CarPhotoPickFailed();
}
