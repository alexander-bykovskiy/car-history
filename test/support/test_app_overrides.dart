import 'package:car_history/app/di/app_providers.dart';
import 'package:car_history/features/cars/data/car_brand_repository_impl.dart';
import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/catalog/data/fuel_type_repository_impl.dart';
import 'package:car_history/features/catalog/data/gas_station_repository_impl.dart';
import 'package:car_history/features/catalog/data/part_repository_impl.dart';
import 'package:car_history/features/catalog/data/part_unit_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_center_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/features/settings/data/backup/backup_repository_impl.dart';
import 'package:car_history/features/settings/data/currency_preferences.dart';
import 'package:car_history/features/settings/data/tip_preferences.dart';
import 'package:car_history/features/settings/data/unit_preferences.dart';
import 'package:car_history/features/statistics/data/merged_expenses_change_source.dart';
import 'package:car_history/features/statistics/data/statistics_repository_impl.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Full app repository overrides for widget/integration tests with an in-memory DB.
List<Override> testAppOverrides(AppDatabase database) {
  final odometer = OdometerRepositoryImpl(database);
  final units = PrefsUnitPreferencesStore();
  final currency = PrefsCurrencyPreferencesStore();
  final tips = PrefsTipPreferencesStore();
  final fuelingRepository = FuelingRepositoryImpl(database);
  final maintenanceRepository = MaintenanceRepositoryImpl(database);
  final expensesChangeSource = MergedExpensesChangeSource(
    fuelings: fuelingRepository,
    maintenances: maintenanceRepository,
  );
  return buildAppProviderOverrides(
    transactionRunner: DriftTransactionRunner(database),
    odometerRepository: odometer,
    unitPreferencesStore: units,
    currencyPreferencesStore: currency,
    tipPreferencesStore: tips,
    fuelTypeRepository: FuelTypeRepositoryImpl(database),
    fuelingRepository: fuelingRepository,
    maintenanceRepository: maintenanceRepository,
    partRepository: PartRepositoryImpl(database),
    partUnitRepository: PartUnitRepositoryImpl(database),
    serviceRepository: ServiceRepositoryImpl(database),
    serviceCenterRepository: ServiceCenterRepositoryImpl(database),
    gasStationRepository: GasStationRepositoryImpl(database),
    carBrandRepository: CarBrandRepositoryImpl(database),
    carRepository: CarRepositoryImpl(database),
    reminderRepository: ReminderRepositoryImpl(
      database,
      odometerRepository: odometer,
      expensesChangeSource: expensesChangeSource,
    ),
    statisticsRepository: StatisticsRepositoryImpl(database),
    expensesChangeSource: expensesChangeSource,
    backupRepository: BackupRepositoryImpl(
      database,
      units: units,
      currency: currency,
    ),
  );
}
