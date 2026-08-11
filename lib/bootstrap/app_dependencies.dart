import 'package:flutter_riverpod/misc.dart' show Override;

import '../app/di/app_providers.dart';
import '../features/cars/data/car_brand_repository_impl.dart';
import '../features/cars/data/car_repository_impl.dart';
import '../features/catalog/data/fuel_type_repository_impl.dart';
import '../features/catalog/data/gas_station_repository_impl.dart';
import '../features/catalog/data/part_repository_impl.dart';
import '../features/catalog/data/part_unit_repository_impl.dart';
import '../features/catalog/data/service_center_repository_impl.dart';
import '../features/catalog/data/service_repository_impl.dart';
import '../features/fueling/data/fueling_repository_impl.dart';
import '../features/maintenance/data/maintenance_repository_impl.dart';
import '../features/reminders/data/reminder_repository_impl.dart';
import '../features/settings/data/backup/backup_repository_impl.dart';
import '../features/settings/data/currency_preferences.dart';
import '../features/settings/data/tip_preferences.dart';
import '../features/settings/data/unit_preferences.dart';
import '../features/settings/domain/repositories/currency_preferences_store.dart';
import '../features/settings/domain/repositories/tip_preferences_store.dart';
import '../features/settings/domain/repositories/unit_preferences_store.dart';
import '../features/statistics/data/merged_expenses_change_source.dart';
import '../features/statistics/data/statistics_repository_impl.dart';
import '../shared/data/db/app_database.dart';
import '../shared/data/drift_transaction_runner.dart';
import '../shared/data/odometer_repository_impl.dart';
import 'resolve_database_seeds.dart';

/// Wired application dependencies after DB bootstrap.
class AppDependencies {
  const AppDependencies({
    required this.overrides,
    required this.database,
  });

  final List<Override> overrides;
  final AppDatabase database;

  /// Creates DB, repositories, preference stores, and Riverpod overrides.
  static Future<AppDependencies> create({
    UnitPreferencesStore? units,
    CurrencyPreferencesStore? currency,
    TipPreferencesStore? tips,
  }) async {
    final unitStore = units ?? PrefsUnitPreferencesStore();
    final currencyStore = currency ?? PrefsCurrencyPreferencesStore();
    final tipStore = tips ?? PrefsTipPreferencesStore();

    // Warm SharedPreferences + currency list before the first screen paints.
    await currencyStore.currencyCodes();

    final currencyCode = await currencyStore.currencyCode();
    final database = AppDatabase(
      seeds: resolveDatabaseSeedTexts(),
      defaultCurrencyCode: currencyCode,
    );
    final transactionRunner = DriftTransactionRunner(database);
    final odometerRepository = OdometerRepositoryImpl(database);
    final fuelTypeRepository = FuelTypeRepositoryImpl(database);
    final fuelingRepository = FuelingRepositoryImpl(database);
    final maintenanceRepository = MaintenanceRepositoryImpl(database);
    final partRepository = PartRepositoryImpl(database);
    final partUnitRepository = PartUnitRepositoryImpl(database);
    final serviceRepository = ServiceRepositoryImpl(database);
    final serviceCenterRepository = ServiceCenterRepositoryImpl(database);
    final gasStationRepository = GasStationRepositoryImpl(database);
    final carBrandRepository = CarBrandRepositoryImpl(database);
    final carRepository = CarRepositoryImpl(database);
    final statisticsRepository = StatisticsRepositoryImpl(database);
    final expensesChangeSource = MergedExpensesChangeSource(
      fuelings: fuelingRepository,
      maintenances: maintenanceRepository,
    );
    final reminderRepository = ReminderRepositoryImpl(
      database,
      odometerRepository: odometerRepository,
      expensesChangeSource: expensesChangeSource,
    );
    final backupRepository = BackupRepositoryImpl(
      database,
      units: unitStore,
      currency: currencyStore,
    );

    return AppDependencies(
      database: database,
      overrides: buildAppProviderOverrides(
        transactionRunner: transactionRunner,
        odometerRepository: odometerRepository,
        unitPreferencesStore: unitStore,
        currencyPreferencesStore: currencyStore,
        tipPreferencesStore: tipStore,
        fuelTypeRepository: fuelTypeRepository,
        fuelingRepository: fuelingRepository,
        maintenanceRepository: maintenanceRepository,
        partRepository: partRepository,
        partUnitRepository: partUnitRepository,
        serviceRepository: serviceRepository,
        serviceCenterRepository: serviceCenterRepository,
        gasStationRepository: gasStationRepository,
        carBrandRepository: carBrandRepository,
        carRepository: carRepository,
        reminderRepository: reminderRepository,
        statisticsRepository: statisticsRepository,
        expensesChangeSource: expensesChangeSource,
        backupRepository: backupRepository,
      ),
    );
  }
}
