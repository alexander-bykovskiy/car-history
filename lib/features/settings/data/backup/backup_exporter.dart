import 'dart:convert';

import '../../../../shared/data/db/app_database.dart';
import '../../domain/repositories/currency_preferences_store.dart';
import '../../domain/repositories/unit_preferences_store.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Builds the versioned JSON map for a full app backup.
class BackupExporter {
  BackupExporter(this._db, this._units, this._currency);

  final AppDatabase _db;
  final UnitPreferencesStore _units;
  final CurrencyPreferencesStore _currency;

  static const currentVersion = 1;

  Future<Map<String, Object?>> buildExportMap() async {
    final fuelVolume = await _units.fuelVolumeUnit();
    final distance = await _units.distanceUnit();
    final currency = await _currency.currencyCode();
    final currencyCodes = await _currency.currencyCodes();

    final brands = await _db.select(_db.carBrands).get();
    final cars = await _db.select(_db.cars).get();
    final fuelTypes = await _db.select(_db.fuelTypes).get();
    final fuelTypeCars = await _db.select(_db.fuelTypeCars).get();
    final parts = await _db.select(_db.parts).get();
    final partCars = await _db.select(_db.partCars).get();
    final partUnits = await _db.select(_db.partUnits).get();
    final services = await _db.select(_db.services).get();
    final serviceCenters = await _db.select(_db.serviceCenters).get();
    final chains = await _db.select(_db.gasStationChains).get();
    final locations = await _db.select(_db.gasStationLocations).get();
    final reminders = await _db.select(_db.reminders).get();
    final fuelings = await _db.select(_db.fuelings).get();
    final maintenances = await _db.select(_db.maintenances).get();
    final maintenanceParts = await _db.select(_db.maintenanceParts).get();

    return {
      BackupKeys.version: currentVersion,
      BackupKeys.exportedAt: DateTime.now().toUtc().toIso8601String(),
      BackupKeys.preferences: {
        BackupKeys.fuelVolumeUnit: fuelVolume.name,
        BackupKeys.distanceUnit: distance.name,
        BackupKeys.currencyCode: currency,
        BackupKeys.currencyCodes: currencyCodes,
      },
      BackupKeys.carBrands: [
        for (final row in brands)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
          },
      ],
      BackupKeys.cars: [
        for (final row in cars)
          {
            BackupKeys.id: row.id,
            BackupKeys.brandId: row.brandId,
            BackupKeys.model: row.model,
            BackupKeys.year: row.year,
            BackupKeys.photoBase64:
                row.photo == null ? null : base64Encode(row.photo!),
            BackupKeys.colorArgb: row.colorArgb,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.fuelTypes: [
        for (final row in fuelTypes)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.fuelTypeCars: [
        for (final row in fuelTypeCars)
          {
            BackupKeys.fuelTypeId: row.fuelTypeId,
            BackupKeys.carId: row.carId,
          },
      ],
      BackupKeys.parts: [
        for (final row in parts)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.partCars: [
        for (final row in partCars)
          {
            BackupKeys.partId: row.partId,
            BackupKeys.carId: row.carId,
          },
      ],
      BackupKeys.partUnits: [
        for (final row in partUnits)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.services: [
        for (final row in services)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.iconKey: row.iconKey,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.serviceCenters: [
        for (final row in serviceCenters)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.address: row.address,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.gasStationChains: [
        for (final row in chains)
          {
            BackupKeys.id: row.id,
            BackupKeys.name: row.name,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.gasStationLocations: [
        for (final row in locations)
          {
            BackupKeys.id: row.id,
            BackupKeys.chainId: row.chainId,
            BackupKeys.address: row.address,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.reminders: [
        for (final row in reminders)
          {
            BackupKeys.id: row.id,
            BackupKeys.carId: row.carId,
            BackupKeys.title: row.title,
            BackupKeys.dueAt:
                row.dueAt == null ? null : BackupJsonCodec.dt(row.dueAt!),
            BackupKeys.dueOdometerKm: row.dueOdometerKm,
            BackupKeys.remindBeforeDays: row.remindBeforeDays,
            BackupKeys.remindBeforeKm: row.remindBeforeKm,
            BackupKeys.isCompleted: row.isCompleted,
            BackupKeys.isDeleted: row.isDeleted,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.fuelings: [
        for (final row in fuelings)
          {
            BackupKeys.id: row.id,
            BackupKeys.carId: row.carId,
            BackupKeys.fuelTypeId: row.fuelTypeId,
            BackupKeys.gasStationId: row.gasStationId,
            BackupKeys.fueledAt: BackupJsonCodec.dt(row.fueledAt),
            BackupKeys.pricePerLiter: row.pricePerLiter,
            BackupKeys.liters: row.liters,
            BackupKeys.totalAmount: row.totalAmount,
            BackupKeys.currencyCode: row.currencyCode,
            BackupKeys.odometerKm: row.odometerKm,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.maintenances: [
        for (final row in maintenances)
          {
            BackupKeys.id: row.id,
            BackupKeys.carId: row.carId,
            BackupKeys.serviceId: row.serviceId,
            BackupKeys.reminderId: row.reminderId,
            BackupKeys.servicedAt: BackupJsonCodec.dt(row.servicedAt),
            BackupKeys.totalAmount: row.totalAmount,
            BackupKeys.currencyCode: row.currencyCode,
            BackupKeys.odometerKm: row.odometerKm,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
      BackupKeys.maintenanceParts: [
        for (final row in maintenanceParts)
          {
            BackupKeys.id: row.id,
            BackupKeys.maintenanceId: row.maintenanceId,
            BackupKeys.partId: row.partId,
            BackupKeys.quantity: row.quantity,
            BackupKeys.unitId: row.unitId,
            BackupKeys.amount: row.amount,
            BackupKeys.comment: row.comment,
            BackupKeys.createdAt: BackupJsonCodec.dt(row.createdAt),
            BackupKeys.updatedAt: BackupJsonCodec.dt(row.updatedAt),
          },
      ],
    };
  }
}
