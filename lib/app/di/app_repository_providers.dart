import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../features/cars/di/car_selection_store_provider.dart';
import '../../features/cars/domain/repositories/car_brand_repository.dart';
import '../../features/cars/domain/repositories/car_repository.dart';
import '../../features/cars/domain/selected_car_service.dart';
import '../../features/catalog/domain/repositories/fuel_type_repository.dart';
import '../../features/catalog/domain/repositories/gas_station_repository.dart';
import '../../features/catalog/domain/repositories/part_repository.dart';
import '../../features/catalog/domain/repositories/part_unit_repository.dart';
import '../../features/catalog/domain/repositories/service_center_repository.dart';
import '../../features/catalog/domain/repositories/service_repository.dart';
import '../../features/fueling/domain/repositories/fueling_repository.dart';
import '../../features/maintenance/domain/repositories/maintenance_repository.dart';
import '../../features/reminders/domain/repositories/reminder_repository.dart';
import '../../features/settings/di/preference_store_providers.dart';
import '../../features/settings/domain/repositories/backup_repository.dart';
import '../../features/settings/domain/repositories/currency_preferences_store.dart';
import '../../features/settings/domain/repositories/tip_preferences_store.dart';
import '../../features/settings/domain/repositories/unit_preferences_store.dart';
import '../../features/statistics/domain/repositories/statistics_repository.dart';
import '../../shared/domain/expenses_change_source.dart';
import '../../shared/domain/odometer_repository.dart';
import '../../shared/domain/transaction_runner.dart';

export '../../features/cars/di/car_selection_store_provider.dart'
    show carSelectionStoreProvider;
export '../../features/settings/di/preference_store_providers.dart'
    show
        currencyPreferencesStoreProvider,
        lastPartUnitStoreProvider,
        tipPreferencesStoreProvider,
        unitPreferencesStoreProvider;

/// DB-backed composition-root ports. Defaults throw until overridden after bootstrap.

Never _unimplemented() =>
    throw StateError('Provider not overridden. Bootstrap AppDatabase first.');

final transactionRunnerProvider =
    Provider<TransactionRunner>((ref) => _unimplemented());

final odometerRepositoryProvider =
    Provider<OdometerRepository>((ref) => _unimplemented());

final fuelTypeRepositoryProvider =
    Provider<FuelTypeRepository>((ref) => _unimplemented());

final fuelingRepositoryProvider =
    Provider<FuelingRepository>((ref) => _unimplemented());

final maintenanceRepositoryProvider =
    Provider<MaintenanceRepository>((ref) => _unimplemented());

final partRepositoryProvider =
    Provider<PartRepository>((ref) => _unimplemented());

final partUnitRepositoryProvider =
    Provider<PartUnitRepository>((ref) => _unimplemented());

final serviceRepositoryProvider =
    Provider<ServiceRepository>((ref) => _unimplemented());

final serviceCenterRepositoryProvider =
    Provider<ServiceCenterRepository>((ref) => _unimplemented());

final gasStationRepositoryProvider =
    Provider<GasStationRepository>((ref) => _unimplemented());

final carBrandRepositoryProvider =
    Provider<CarBrandRepository>((ref) => _unimplemented());

final carRepositoryProvider =
    Provider<CarRepository>((ref) => _unimplemented());

final selectedCarServiceProvider = Provider<SelectedCarService>((ref) {
  return SelectedCarService(
    carRepository: ref.watch(carRepositoryProvider),
    selectionStore: ref.watch(carSelectionStoreProvider),
  );
});

final reminderRepositoryProvider =
    Provider<ReminderRepository>((ref) => _unimplemented());

final statisticsRepositoryProvider =
    Provider<StatisticsRepository>((ref) => _unimplemented());

final expensesChangeSourceProvider =
    Provider<ExpensesChangeSource>((ref) => _unimplemented());

final backupRepositoryProvider =
    Provider<BackupRepository>((ref) => _unimplemented());

/// Overrides for the composition root after database bootstrap.
List<Override> buildAppProviderOverrides({
  required TransactionRunner transactionRunner,
  required OdometerRepository odometerRepository,
  required UnitPreferencesStore unitPreferencesStore,
  required CurrencyPreferencesStore currencyPreferencesStore,
  required TipPreferencesStore tipPreferencesStore,
  required FuelTypeRepository fuelTypeRepository,
  required FuelingRepository fuelingRepository,
  required MaintenanceRepository maintenanceRepository,
  required PartRepository partRepository,
  required PartUnitRepository partUnitRepository,
  required ServiceRepository serviceRepository,
  required ServiceCenterRepository serviceCenterRepository,
  required GasStationRepository gasStationRepository,
  required CarBrandRepository carBrandRepository,
  required CarRepository carRepository,
  required ReminderRepository reminderRepository,
  required StatisticsRepository statisticsRepository,
  required ExpensesChangeSource expensesChangeSource,
  required BackupRepository backupRepository,
}) {
  return [
    transactionRunnerProvider.overrideWithValue(transactionRunner),
    odometerRepositoryProvider.overrideWithValue(odometerRepository),
    unitPreferencesStoreProvider.overrideWithValue(unitPreferencesStore),
    currencyPreferencesStoreProvider.overrideWithValue(currencyPreferencesStore),
    tipPreferencesStoreProvider.overrideWithValue(tipPreferencesStore),
    fuelTypeRepositoryProvider.overrideWithValue(fuelTypeRepository),
    fuelingRepositoryProvider.overrideWithValue(fuelingRepository),
    maintenanceRepositoryProvider.overrideWithValue(maintenanceRepository),
    partRepositoryProvider.overrideWithValue(partRepository),
    partUnitRepositoryProvider.overrideWithValue(partUnitRepository),
    serviceRepositoryProvider.overrideWithValue(serviceRepository),
    serviceCenterRepositoryProvider.overrideWithValue(serviceCenterRepository),
    gasStationRepositoryProvider.overrideWithValue(gasStationRepository),
    carBrandRepositoryProvider.overrideWithValue(carBrandRepository),
    carRepositoryProvider.overrideWithValue(carRepository),
    reminderRepositoryProvider.overrideWithValue(reminderRepository),
    statisticsRepositoryProvider.overrideWithValue(statisticsRepository),
    expensesChangeSourceProvider.overrideWithValue(expensesChangeSource),
    backupRepositoryProvider.overrideWithValue(backupRepository),
  ];
}
