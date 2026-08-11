import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/units.dart';
import '../domain/repositories/unit_preferences_store.dart';

export '../../../core/units.dart';

class PrefsUnitPreferencesStore implements UnitPreferencesStore {
  static const _fuelVolumeKey = 'unit_fuel_volume';
  static const _distanceKey = 'unit_distance';

  @override
  Future<FuelVolumeUnit> fuelVolumeUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return FuelVolumeUnit.values.firstWhere(
      (unit) => unit.name == prefs.getString(_fuelVolumeKey),
      orElse: () => FuelVolumeUnit.liters,
    );
  }

  @override
  Future<void> setFuelVolumeUnit(FuelVolumeUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fuelVolumeKey, unit.name);
  }

  @override
  Future<DistanceUnit> distanceUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return DistanceUnit.values.firstWhere(
      (unit) => unit.name == prefs.getString(_distanceKey),
      orElse: () => DistanceUnit.kilometers,
    );
  }

  @override
  Future<void> setDistanceUnit(DistanceUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_distanceKey, unit.name);
  }
}
