import 'package:car_history/features/maintenance/domain/usecases/save_maintenance.dart';
import 'package:car_history/features/maintenance/presentation/maintenance_failure_messages.dart';
import 'package:car_history/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('maps field and snack failures to specific copy, not listLoadError', () {
    expect(
      maintenanceFailureMessage(l10n, SaveMaintenanceFailure.emptyService),
      l10n.maintenanceServiceRequired,
    );
    expect(
      maintenanceFailureMessage(l10n, SaveMaintenanceFailure.invalidTotal),
      l10n.maintenanceTotalInvalid,
    );
    expect(
      maintenanceFailureMessage(l10n, SaveMaintenanceFailure.invalidOdometer),
      l10n.fuelingOdometerInvalid,
    );
    expect(
      maintenanceFailureMessage(l10n, SaveMaintenanceFailure.emptyPart),
      l10n.maintenancePartNameRequired,
    );
    expect(
      maintenanceFailureMessage(l10n, SaveMaintenanceFailure.invalidPartAmount),
      l10n.maintenancePartAmountInvalid,
    );
    expect(
      maintenanceFailureMessage(
        l10n,
        SaveMaintenanceFailure.invalidPartQuantity,
      ),
      l10n.maintenancePartQuantityInvalid,
    );
    expect(
      maintenanceFailureMessage(
        l10n,
        SaveMaintenanceFailure.reminderSyncFailed,
      ),
      l10n.reminderSyncFailed,
    );

    for (final failure in SaveMaintenanceFailure.values) {
      expect(
        maintenanceFailureMessage(l10n, failure),
        isNot(l10n.listLoadError),
      );
    }
  });
}
