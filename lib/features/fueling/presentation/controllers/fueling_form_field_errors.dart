import '../../domain/usecases/save_fueling.dart';

/// Field-level error slots for the fueling form.
class FuelingFormFieldErrors {
  SaveFuelingFailure? fuelTypeError;
  SaveFuelingFailure? gasStationError;
  SaveFuelingFailure? priceError;
  SaveFuelingFailure? amountError;
  SaveFuelingFailure? odometerError;

  void clearFuelType() => fuelTypeError = null;
  void clearGasStation() => gasStationError = null;
  void clearPrice() => priceError = null;
  void clearAmount() => amountError = null;
  void clearOdometer() => odometerError = null;

  void clearAll() {
    fuelTypeError = null;
    gasStationError = null;
    priceError = null;
    amountError = null;
    odometerError = null;
  }

  void apply(SaveFuelingFailure? error) {
    clearAll();
    switch (error) {
      case SaveFuelingFailure.emptyFuelType:
        fuelTypeError = error;
      case SaveFuelingFailure.gasStationEnsureFailed:
        gasStationError = error;
      case SaveFuelingFailure.invalidPrice:
        priceError = error;
      case SaveFuelingFailure.invalidQuantityOrTotal:
        amountError = error;
      case SaveFuelingFailure.invalidOdometer:
        odometerError = error;
      case null:
        break;
    }
  }
}
