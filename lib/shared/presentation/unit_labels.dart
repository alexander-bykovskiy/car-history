import '../../core/units.dart';
import '../../l10n/app_localizations.dart';

/// Localized short label for a fuel volume unit (L, gal, …).
String volumeUnitShort(AppLocalizations l10n, FuelVolumeUnit unit) {
  return switch (unit) {
    FuelVolumeUnit.liters => l10n.unitFuelShortLiter,
    FuelVolumeUnit.usGallons => l10n.unitFuelShortUsGallon,
    FuelVolumeUnit.imperialGallons => l10n.unitFuelShortImperialGallon,
  };
}

/// Localized short label for a distance unit (km, mi).
String distanceUnitShort(AppLocalizations l10n, DistanceUnit unit) {
  return switch (unit) {
    DistanceUnit.kilometers => l10n.unitDistanceShortKm,
    DistanceUnit.miles => l10n.unitDistanceShortMile,
  };
}
