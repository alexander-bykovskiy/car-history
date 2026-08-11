import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'car_brand_seeds.dart';
import 'database_seed_texts.dart';

part 'app_database.g.dart';
part 'migrations/schema_upgrades.dart';
part 'migrations/legacy_migrators.dart';
part 'seeds/database_seeds.dart';

class FuelTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class CarBrands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Cars extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get brandId => integer().references(CarBrands, #id)();
  TextColumn get model => text().nullable()();
  IntColumn get year => integer().nullable()();
  BlobColumn get photo => blob().nullable()();
  IntColumn get colorArgb => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Restricted fuel↔car links.
/// No rows for a fuel type ⇒ available for every car.
class FuelTypeCars extends Table {
  IntColumn get fuelTypeId =>
      integer().references(FuelTypes, #id, onDelete: KeyAction.cascade)();
  IntColumn get carId =>
      integer().references(Cars, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {fuelTypeId, carId};
}

class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Restricted part↔car links.
/// No rows for a part ⇒ available for every car.
class PartCars extends Table {
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();
  IntColumn get carId =>
      integer().references(Cars, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {partId, carId};
}

/// Units of measure for parts (liters, pieces, packs, …).
class PartUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  /// Optional catalog key; null ⇒ default handyman icon.
  TextColumn get iconKey => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ServiceCenters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class GasStationChains extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class GasStationLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chainId => integer()
      .references(GasStationChains, #id, onDelete: KeyAction.cascade)();
  TextColumn get address => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Fuelings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get carId =>
      integer().references(Cars, #id, onDelete: KeyAction.cascade)();
  IntColumn get fuelTypeId => integer()
      .nullable()
      .references(FuelTypes, #id, onDelete: KeyAction.setNull)();
  /// Points to a concrete location (chain + optional address).
  IntColumn get gasStationId => integer()
      .nullable()
      .references(GasStationLocations, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get fueledAt => dateTime()();
  RealColumn get pricePerLiter => real()();
  RealColumn get liters => real()();
  RealColumn get totalAmount => real()();
  /// ISO-like currency code snapshot at save time (e.g. EUR, RSD).
  TextColumn get currencyCode =>
      text().withDefault(const Constant('EUR'))();
  /// Odometer reading stored in kilometers; null if not provided.
  RealColumn get odometerKm => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Maintenances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get carId =>
      integer().references(Cars, #id, onDelete: KeyAction.cascade)();
  IntColumn get serviceId => integer()
      .nullable()
      .references(Services, #id, onDelete: KeyAction.setNull)();
  /// Optional linked reminder; title is synced from the service name.
  IntColumn get reminderId => integer()
      .nullable()
      .references(Reminders, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get servicedAt => dateTime()();
  /// Cost of the service; null if not provided.
  RealColumn get totalAmount => real().nullable()();
  /// ISO-like currency code snapshot at save time (e.g. EUR, RSD).
  TextColumn get currencyCode =>
      text().withDefault(const Constant('EUR'))();
  /// Odometer reading stored in kilometers; null if not provided.
  RealColumn get odometerKm => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Parts used on a maintenance record, with quantity and optional unit price.
class MaintenanceParts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maintenanceId => integer()
      .references(Maintenances, #id, onDelete: KeyAction.cascade)();
  IntColumn get partId => integer()
      .nullable()
      .references(Parts, #id, onDelete: KeyAction.setNull)();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  IntColumn get unitId => integer()
      .nullable()
      .references(PartUnits, #id, onDelete: KeyAction.setNull)();
  /// Unit price; null if not provided.
  RealColumn get amount => real().nullable()();
  /// Optional free-text note for this part line.
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Per-car reminders by date and/or odometer, with optional "remind before" windows.
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get carId =>
      integer().references(Cars, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  /// Target date; null if mileage-only.
  DateTimeColumn get dueAt => dateTime().nullable()();
  /// Target odometer in km; null if date-only.
  RealColumn get dueOdometerKm => real().nullable()();
  /// Days before [dueAt] to enter the "soon" (orange) state.
  IntColumn get remindBeforeDays => integer().nullable()();
  /// Kilometers before [dueOdometerKm] to enter the "soon" (orange) state.
  RealColumn get remindBeforeKm => real().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    FuelTypes,
    CarBrands,
    Cars,
    FuelTypeCars,
    Parts,
    PartCars,
    PartUnits,
    Services,
    ServiceCenters,
    GasStationChains,
    GasStationLocations,
    Fuelings,
    Maintenances,
    MaintenanceParts,
    Reminders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({
    QueryExecutor? executor,
    this.seeds = DatabaseSeedTexts.english,
    this.defaultCurrencyCode = 'EUR',
  }) : super(executor ?? _openConnection());

  final DatabaseSeedTexts seeds;

  /// Used when migrating rows that gain a currency_code column.
  final String defaultCurrencyCode;

  @override
  int get schemaVersion => 25;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _ensureFuelingsListIndex(this);
          await _ensureMaintenancesListIndex(this);
          await _ensureActiveNamedCatalogUniqueIndexes(this);
          await _seedFuelTypes(this);
          await _seedCarBrands(this);
          await _seedPlaceholderCar(this);
          await _seedPartUnits(this);
        },
        onUpgrade: (Migrator m, int from, int to) async {
          await _runOnUpgrade(this, m, from, to);
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'car_history',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
