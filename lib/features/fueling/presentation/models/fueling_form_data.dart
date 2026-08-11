/// Editable fueling fields for the form UI (no Drift types).
class FuelingFormData {
  const FuelingFormData({
    this.id,
    this.fuelTypeId,
    this.gasStationId,
    required this.fueledAt,
    required this.pricePerLiter,
    required this.liters,
    required this.totalAmount,
    required this.currencyCode,
    this.odometerKm,
    this.fuelTypeName,
    this.gasStationName,
  });

  final int? id;
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

  bool get isEditing => id != null;
}
