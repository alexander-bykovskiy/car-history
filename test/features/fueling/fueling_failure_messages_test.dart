import 'package:car_history/features/fueling/domain/usecases/save_fueling.dart';
import 'package:car_history/features/fueling/presentation/fueling_failure_messages.dart';
import 'package:car_history/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('maps each SaveFuelingFailure to specific copy', () {
    expect(
      fuelingFailureMessage(l10n, SaveFuelingFailure.emptyFuelType),
      l10n.fuelingFuelTypeRequired,
    );
    expect(
      fuelingFailureMessage(l10n, SaveFuelingFailure.gasStationEnsureFailed),
      l10n.fuelingGasStationEnsureFailed,
    );
    expect(
      fuelingFailureMessage(l10n, SaveFuelingFailure.invalidPrice),
      l10n.fuelingPriceRequired,
    );
    expect(
      fuelingFailureMessage(l10n, SaveFuelingFailure.invalidQuantityOrTotal),
      l10n.fuelingQuantityOrTotalRequired,
    );
    expect(
      fuelingFailureMessage(l10n, SaveFuelingFailure.invalidOdometer),
      l10n.fuelingOdometerInvalid,
    );
    expect(fuelingFailureMessage(l10n, null), isNull);

    for (final failure in SaveFuelingFailure.values) {
      expect(
        fuelingFailureMessage(l10n, failure),
        isNot(l10n.listLoadError),
      );
    }
  });
}
