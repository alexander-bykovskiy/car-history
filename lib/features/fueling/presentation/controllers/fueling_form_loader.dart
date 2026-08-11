import '../../../../core/number_formatting.dart';
import '../../../../core/units.dart';
import '../../../../shared/domain/odometer_repository.dart';
import '../../../catalog/domain/repositories/fuel_type_repository.dart';
import '../../../catalog/domain/repositories/gas_station_repository.dart';
import '../../domain/repositories/fueling_repository.dart';
import '../models/fueling_form_data.dart';

class FuelingFormCatalogNames {
  const FuelingFormCatalogNames({
    this.fuelTypeName,
    this.gasStationLabel,
  });

  final String? fuelTypeName;
  final String? gasStationLabel;
}

class FuelingFormPrefillData {
  const FuelingFormPrefillData({
    this.fuelTypeName,
    this.gasStationLabel,
    this.priceText,
    this.odometerText,
  });

  final String? fuelTypeName;
  final String? gasStationLabel;
  final String? priceText;
  final String? odometerText;
}

/// Loads catalog labels / last-fueling prefill for the fueling form (no UI).
class FuelingFormLoader {
  const FuelingFormLoader();

  Future<FuelingFormCatalogNames> loadExistingNames({
    required FuelingFormData existing,
    required FuelTypeRepository fuelTypes,
    required GasStationRepository gasStations,
  }) async {
    String? fuelTypeName;
    final fuelTypeId = existing.fuelTypeId;
    if (fuelTypeId != null) {
      final type = await fuelTypes.getById(fuelTypeId);
      fuelTypeName = type?.name;
    }

    String? gasStationLabel;
    final gasStationId = existing.gasStationId;
    if (gasStationId != null) {
      final option = await gasStations.optionForLocationId(gasStationId);
      gasStationLabel = option?.label;
    }

    return FuelingFormCatalogNames(
      fuelTypeName: fuelTypeName,
      gasStationLabel: gasStationLabel,
    );
  }

  Future<FuelingFormPrefillData> prefillFromLast({
    required int carId,
    required FuelVolumeUnit volumeUnit,
    required DistanceUnit distanceUnit,
    required FuelingRepository fuelings,
    required FuelTypeRepository fuelTypes,
    required GasStationRepository gasStations,
    required OdometerRepository odometer,
  }) async {
    String? fuelTypeName;
    String? gasStationLabel;
    String? priceText;

    final latest = await fuelings.latestForCar(carId);
    if (latest != null) {
      final pricePerUnit = volumeUnit.priceFromPerLiter(latest.pricePerLiter);
      priceText = formatFlexibleDouble(pricePerUnit);

      final fuelTypeId = latest.fuelTypeId;
      if (fuelTypeId != null) {
        final type = await fuelTypes.getById(fuelTypeId);
        fuelTypeName = type?.name;
      }

      final gasStationId = latest.gasStationId;
      if (gasStationId != null) {
        final option = await gasStations.optionForLocationId(gasStationId);
        gasStationLabel = option?.label;
      }
    }

    String? odometerText;
    final previousKm = await odometer.maxOdometerKm(carId);
    if (previousKm != null) {
      final value = distanceUnit.fromKilometers(previousKm);
      odometerText = formatFlexibleDouble(value);
    }

    return FuelingFormPrefillData(
      fuelTypeName: fuelTypeName,
      gasStationLabel: gasStationLabel,
      priceText: priceText,
      odometerText: odometerText,
    );
  }
}
