import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/widgets.dart' show Locale;

import '../shared/data/db/database_seed_texts.dart';
import '../l10n/app_localizations.dart';
import '../theme/car_theme_config.dart';

/// Builds [DatabaseSeedTexts] from the device locale via app l10n.
DatabaseSeedTexts resolveDatabaseSeedTexts() {
  final locale = _resolveSupportedLocale(PlatformDispatcher.instance.locale);
  final l10n = lookupAppLocalizations(locale);
  return DatabaseSeedTexts(
    fuelTypePetrol95: l10n.fuelTypePetrol95,
    fuelTypePetrol100: l10n.fuelTypePetrol100,
    fuelTypeDiesel: l10n.fuelTypeDiesel,
    partUnitLiters: l10n.partUnitLiters,
    partUnitPieces: l10n.partUnitPieces,
    partUnitPackages: l10n.partUnitPackages,
    seedCarBrand: l10n.seedCarBrand,
    seedCarModel: l10n.seedCarModel,
    defaultCarColorArgb: kCarColorOptions.first.toARGB32(),
  );
}

Locale _resolveSupportedLocale(Locale deviceLocale) {
  for (final supported in AppLocalizations.supportedLocales) {
    if (supported.languageCode == deviceLocale.languageCode) {
      return supported;
    }
  }
  return AppLocalizations.supportedLocales.first;
}
