/// Fuel volume display/input unit. Storage is always liters.
enum FuelVolumeUnit {
  liters,
  usGallons,
  imperialGallons;

  /// Liters in one unit of this volume measure.
  double get litersPerUnit => switch (this) {
        FuelVolumeUnit.liters => 1,
        FuelVolumeUnit.usGallons => 3.785411784,
        FuelVolumeUnit.imperialGallons => 4.54609,
      };

  double toLiters(double amount) => amount * litersPerUnit;

  double fromLiters(double liters) => liters / litersPerUnit;

  /// Converts a price quoted per this unit into a price per liter.
  double priceToPerLiter(double pricePerUnit) => pricePerUnit / litersPerUnit;

  /// Converts a stored price per liter into a price per this unit.
  double priceFromPerLiter(double pricePerLiter) =>
      pricePerLiter * litersPerUnit;
}

/// Distance display/input unit. Storage is always kilometers.
enum DistanceUnit {
  kilometers,
  miles;

  /// Kilometers in one unit of this distance measure.
  double get kilometersPerUnit => switch (this) {
        DistanceUnit.kilometers => 1,
        DistanceUnit.miles => 1.609344,
      };

  double toKilometers(double amount) => amount * kilometersPerUnit;

  double fromKilometers(double kilometers) => kilometers / kilometersPerUnit;
}
