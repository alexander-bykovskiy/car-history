import '../../../core/car_limits.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/usecases/car_write_usecases.dart';
import 'controllers/car_form_submit_outcome.dart';

/// Localized snack text for car form outcomes (save failure or local-only).
String carFormSnackMessage(AppLocalizations l10n, CarFormSnack snack) {
  return switch (snack) {
    CarFormSnackSave(:final failure) => switch (failure) {
        SaveCarFailure.emptyBrand => l10n.carBrandRequired,
        SaveCarFailure.limitReached => l10n.carLimitReached(kMaxCars),
        SaveCarFailure.photoTooLarge => l10n.photoTooLarge,
      },
    CarFormSnackYearInvalid() => l10n.carYearInvalid,
    CarFormSnackDeleteLastBlocked() => l10n.carDeleteLastBlocked,
  };
}
