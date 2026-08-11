import '../../../../core/number_parsing.dart';
import '../../../../core/units.dart';
import '../../domain/entities/fueling.dart';
import '../../domain/fueling_write_validation.dart';
import '../../domain/usecases/save_fueling.dart';
import '../models/fueling_form_data.dart';

/// Maps a fueling list item into a form DTO.
FuelingFormData fuelingFormDataFromView(FuelingListItem view) {
  return FuelingFormData(
    id: view.id,
    fuelTypeId: view.fuelTypeId,
    gasStationId: view.gasStationId,
    fueledAt: view.fueledAt,
    pricePerLiter: view.pricePerLiter,
    liters: view.liters,
    totalAmount: view.totalAmount,
    currencyCode: view.currencyCode,
    odometerKm: view.odometerKm,
    fuelTypeName: view.fuelTypeName,
    gasStationName: view.gasStationName,
  );
}

enum FuelingAmountField { quantity, total }

class FuelingFormPrepareResult {
  const FuelingFormPrepareResult._({this.error, this.input, this.quantity, this.total});

  const FuelingFormPrepareResult.error(SaveFuelingFailure error)
      : this._(error: error);

  const FuelingFormPrepareResult.ready({
    required SaveFuelingInput input,
    required double quantity,
    required double total,
  }) : this._(input: input, quantity: quantity, total: total);

  final SaveFuelingFailure? error;
  final SaveFuelingInput? input;
  final double? quantity;
  final double? total;

  bool get isReady => input != null;
}

/// Parses and validates fueling form fields into a [SaveFuelingInput].
///
/// When both quantity and total are set, [lastEdited] is the source of truth
/// and the other amount is recalculated from price.
FuelingFormPrepareResult prepareFuelingSave({
  required int carId,
  required String fuelTypeName,
  required String? gasStationName,
  required DateTime fueledAt,
  required String priceText,
  required String quantityText,
  required String totalText,
  required String odometerText,
  required String currencyCode,
  required FuelVolumeUnit volumeUnit,
  required DistanceUnit distanceUnit,
  required FuelingAmountField lastEdited,
  int? existingId,
}) {
  final trimmedFuelType = fuelTypeName.trim();
  if (trimmedFuelType.isEmpty) {
    return const FuelingFormPrepareResult.error(
      SaveFuelingFailure.emptyFuelType,
    );
  }

  final pricePerUnit = parseFlexibleDouble(priceText);
  if (pricePerUnit == null || pricePerUnit <= 0) {
    return const FuelingFormPrepareResult.error(
      SaveFuelingFailure.invalidPrice,
    );
  }

  var quantity = parseFlexibleDouble(quantityText);
  var total = parseFlexibleDouble(totalText);
  final hasQuantity = quantity != null && quantity > 0;
  final hasTotal = total != null && total > 0;
  if (!hasQuantity && !hasTotal) {
    return const FuelingFormPrepareResult.error(
      SaveFuelingFailure.invalidQuantityOrTotal,
    );
  }

  if (hasQuantity && !hasTotal) {
    total = pricePerUnit * quantity;
  } else if (hasTotal && !hasQuantity) {
    quantity = total / pricePerUnit;
  } else if (hasQuantity && hasTotal) {
    if (lastEdited == FuelingAmountField.total) {
      quantity = total / pricePerUnit;
    } else {
      total = pricePerUnit * quantity;
    }
  }

  final odometerRaw = odometerText.trim();
  final odometerInput =
      odometerRaw.isEmpty ? null : parseFlexibleDouble(odometerRaw);
  if (odometerRaw.isNotEmpty && odometerInput == null) {
    return const FuelingFormPrepareResult.error(
      SaveFuelingFailure.invalidOdometer,
    );
  }

  final odometerKm = odometerInput == null
      ? null
      : distanceUnit.toKilometers(odometerInput);
  final pricePerLiter = volumeUnit.priceToPerLiter(pricePerUnit);
  final liters = volumeUnit.toLiters(quantity!);
  final totalAmount = total!;

  final writeError = validateFuelingWrite(
    pricePerLiter: pricePerLiter,
    liters: liters,
    totalAmount: totalAmount,
    odometerKm: odometerKm,
  );
  if (writeError != null) {
    final failure = mapFuelingSaveResultToFailure(writeError);
    if (failure != null) {
      return FuelingFormPrepareResult.error(failure);
    }
  }

  return FuelingFormPrepareResult.ready(
    input: SaveFuelingInput(
      carId: carId,
      fuelTypeName: trimmedFuelType,
      gasStationName: gasStationName,
      fueledAt: fueledAt,
      pricePerLiter: pricePerLiter,
      liters: liters,
      totalAmount: totalAmount,
      currencyCode: currencyCode,
      odometerKm: odometerKm,
      existingId: existingId,
    ),
    quantity: quantity,
    total: totalAmount,
  );
}
