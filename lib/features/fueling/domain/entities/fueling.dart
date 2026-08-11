/// List/timeline row for a fueling (no persistence types).
class FuelingListItem {
  const FuelingListItem({
    required this.id,
    required this.carId,
    required this.fueledAt,
    required this.pricePerLiter,
    required this.liters,
    required this.totalAmount,
    required this.currencyCode,
    this.fuelTypeId,
    this.gasStationId,
    this.odometerKm,
    this.fuelTypeName,
    this.gasStationName,
  });

  final int id;
  final int carId;
  final int? fuelTypeId;
  final int? gasStationId;
  final DateTime fueledAt;
  final double pricePerLiter;
  final double liters;
  final double totalAmount;
  final String currencyCode;
  final double? odometerKm;
  final String? fuelTypeName;
  final String? gasStationName;
}

/// Persisted fueling fields used after create/update or for prefill.
class FuelingRecord {
  const FuelingRecord({
    required this.id,
    required this.carId,
    required this.fueledAt,
    required this.pricePerLiter,
    required this.liters,
    required this.totalAmount,
    required this.currencyCode,
    this.fuelTypeId,
    this.gasStationId,
    this.odometerKm,
  });

  final int id;
  final int carId;
  final int? fuelTypeId;
  final int? gasStationId;
  final DateTime fueledAt;
  final double pricePerLiter;
  final double liters;
  final double totalAmount;
  final String currencyCode;
  final double? odometerKm;
}
