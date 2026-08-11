import 'package:drift/drift.dart';

import '../../../../shared/data/db/app_database.dart';
import '../../../fueling/domain/fueling_write_validation.dart';
import '../../domain/currency_code.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Merges fueling rows from a backup root.
class BackupImportFuelings {
  BackupImportFuelings(this._db);

  final AppDatabase _db;

  Future<void> import(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required BackupCatalogIdMaps catalogs,
    required BackupImportCounters counters,
  }) async {
    final existingFuelings = await _db.select(_db.fuelings).get();
    for (final item in BackupJsonCodec.list(root[BackupKeys.fuelings])) {
      final oldCarId = BackupJsonCodec.asInt(item[BackupKeys.carId]);
      if (oldCarId == null) continue;
      final carId = carIdMap[oldCarId];
      if (carId == null) continue;

      final fuelTypeId = BackupJsonCodec.mapRequired(
        BackupJsonCodec.asInt(item[BackupKeys.fuelTypeId]),
        catalogs.fuelTypeIdMap,
      );
      if (fuelTypeId == null) {
        counters.skipped++;
        continue;
      }
      final gasStationMapped = BackupJsonCodec.mapOptionalFk(
        BackupJsonCodec.asInt(item[BackupKeys.gasStationId]),
        catalogs.locationIdMap,
      );
      if (gasStationMapped.unresolved) {
        counters.skipped++;
        continue;
      }
      final gasStationId = gasStationMapped.id;
      final fueledAt = BackupJsonCodec.parseDt(item[BackupKeys.fueledAt]);
      if (fueledAt == null) {
        counters.skipped++;
        continue;
      }
      final pricePerLiter =
          BackupJsonCodec.asDouble(item[BackupKeys.pricePerLiter]);
      final liters = BackupJsonCodec.asDouble(item[BackupKeys.liters]);
      final totalAmount = BackupJsonCodec.asDouble(item[BackupKeys.totalAmount]);
      if (pricePerLiter == null || liters == null || totalAmount == null) {
        counters.skipped++;
        continue;
      }
      final currencyCode = CurrencyCode.normalize(
            BackupJsonCodec.asString(item[BackupKeys.currencyCode]) ?? '',
          ) ??
          CurrencyCode.defaultCode;
      final odometerKm = BackupJsonCodec.asDouble(item[BackupKeys.odometerKm]);

      if (validateFuelingWrite(
            pricePerLiter: pricePerLiter,
            liters: liters,
            totalAmount: totalAmount,
            odometerKm: odometerKm,
          ) !=
          null) {
        counters.skipped++;
        continue;
      }

      final isDup = existingFuelings.any(
        (row) =>
            row.carId == carId &&
            row.fuelTypeId == fuelTypeId &&
            row.gasStationId == gasStationId &&
            BackupJsonCodec.sameDt(row.fueledAt, fueledAt) &&
            BackupJsonCodec.sameDouble(row.pricePerLiter, pricePerLiter) &&
            BackupJsonCodec.sameDouble(row.liters, liters) &&
            BackupJsonCodec.sameDouble(row.totalAmount, totalAmount) &&
            row.currencyCode == currencyCode &&
            BackupJsonCodec.sameDouble(row.odometerKm, odometerKm),
      );
      if (isDup) {
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.fuelings).insert(
            FuelingsCompanion.insert(
              carId: carId,
              fuelTypeId: Value(fuelTypeId),
              gasStationId: Value(gasStationId),
              fueledAt: fueledAt,
              pricePerLiter: pricePerLiter,
              liters: liters,
              totalAmount: totalAmount,
              currencyCode: Value(currencyCode),
              odometerKm: Value(odometerKm),
              createdAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
              ),
              updatedAt: Value(
                BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
              ),
            ),
          );
      existingFuelings.add(
        Fueling(
          id: newId,
          carId: carId,
          fuelTypeId: fuelTypeId,
          gasStationId: gasStationId,
          fueledAt: fueledAt,
          pricePerLiter: pricePerLiter,
          liters: liters,
          totalAmount: totalAmount,
          currencyCode: currencyCode,
          odometerKm: odometerKm,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;
    }
  }
}
