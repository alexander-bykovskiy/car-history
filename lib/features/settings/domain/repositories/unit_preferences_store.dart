import '../../../../core/units.dart';

/// Persisted display units for fuel volume and distance.
abstract class UnitPreferencesStore {
  Future<FuelVolumeUnit> fuelVolumeUnit();
  Future<void> setFuelVolumeUnit(FuelVolumeUnit unit);
  Future<DistanceUnit> distanceUnit();
  Future<void> setDistanceUnit(DistanceUnit unit);
}
