import '../../../l10n/app_localizations.dart';
import '../domain/usecases/save_fueling.dart';

/// Localized message for a [SaveFuelingFailure] field error, or null.
String? fuelingFailureMessage(
  AppLocalizations l10n,
  SaveFuelingFailure? failure,
) {
  return switch (failure) {
    SaveFuelingFailure.emptyFuelType => l10n.fuelingFuelTypeRequired,
    SaveFuelingFailure.gasStationEnsureFailed =>
      l10n.fuelingGasStationEnsureFailed,
    SaveFuelingFailure.invalidPrice => l10n.fuelingPriceRequired,
    SaveFuelingFailure.invalidQuantityOrTotal =>
      l10n.fuelingQuantityOrTotalRequired,
    SaveFuelingFailure.invalidOdometer => l10n.fuelingOdometerInvalid,
    null => null,
  };
}
