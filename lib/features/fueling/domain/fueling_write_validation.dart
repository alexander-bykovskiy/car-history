import 'entities/fueling_save.dart';

/// Domain write checks for persisted fueling amounts (liters / price-per-liter).
///
/// Shared by repository `_validate` and presentation `prepare*` after unit
/// conversion so numeric rules stay in one place.
FuelingSaveResult? validateFuelingWrite({
  required double pricePerLiter,
  required double liters,
  required double totalAmount,
  double? odometerKm,
}) {
  if (pricePerLiter <= 0) return FuelingSaveResult.invalidPrice;
  if (liters <= 0 || totalAmount <= 0) {
    return FuelingSaveResult.invalidQuantityOrTotal;
  }
  if (odometerKm != null && odometerKm < 0) {
    return FuelingSaveResult.invalidOdometer;
  }
  return null;
}
