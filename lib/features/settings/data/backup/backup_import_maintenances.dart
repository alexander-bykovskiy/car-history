import 'package:drift/drift.dart';

import '../../../../shared/data/db/app_database.dart';
import '../../../maintenance/domain/entities/maintenance.dart'
    show MaintenancePartInput;
import '../../../maintenance/domain/maintenance_write_validation.dart';
import '../../domain/currency_code.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Merges maintenances and related maintenance parts from a backup root.
class BackupImportMaintenances {
  BackupImportMaintenances(this._db);

  final AppDatabase _db;

  Future<void> import(
    Map<String, dynamic> root, {
    required Map<int, int> carIdMap,
    required Map<int, int> reminderIdMap,
    required BackupCatalogIdMaps catalogs,
    required BackupImportCounters counters,
  }) async {
    final existingMaintenances = await _db.select(_db.maintenances).get();
    final maintenancePartsByOldId = <int, List<Map<String, dynamic>>>{};
    for (final item
        in BackupJsonCodec.list(root[BackupKeys.maintenanceParts])) {
      final mid = BackupJsonCodec.asInt(item[BackupKeys.maintenanceId]);
      if (mid == null) continue;
      maintenancePartsByOldId.putIfAbsent(mid, () => []).add(item);
    }

    for (final item in BackupJsonCodec.list(root[BackupKeys.maintenances])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final oldCarId = BackupJsonCodec.asInt(item[BackupKeys.carId]);
      if (oldId == null || oldCarId == null) continue;
      final carId = carIdMap[oldCarId];
      if (carId == null) continue;

      final rawParts = maintenancePartsByOldId[oldId] ?? const [];
      final serviceId = BackupJsonCodec.mapRequired(
        BackupJsonCodec.asInt(item[BackupKeys.serviceId]),
        catalogs.serviceIdMap,
      );
      if (serviceId == null) {
        counters.skipped++;
        counters.skipped += rawParts.length;
        continue;
      }
      final reminderMapped = BackupJsonCodec.mapOptionalFk(
        BackupJsonCodec.asInt(item[BackupKeys.reminderId]),
        reminderIdMap,
      );
      if (reminderMapped.unresolved) {
        counters.skipped++;
        counters.skipped += rawParts.length;
        continue;
      }
      final reminderId = reminderMapped.id;
      final servicedAt = BackupJsonCodec.parseDt(item[BackupKeys.servicedAt]);
      if (servicedAt == null) {
        counters.skipped++;
        counters.skipped += rawParts.length;
        continue;
      }
      final totalAmount = BackupJsonCodec.asDouble(item[BackupKeys.totalAmount]);
      final currencyCode = CurrencyCode.normalize(
            BackupJsonCodec.asString(item[BackupKeys.currencyCode]) ?? '',
          ) ??
          CurrencyCode.defaultCode;
      final odometerKm = BackupJsonCodec.asDouble(item[BackupKeys.odometerKm]);
      final partInputs = <MaintenancePartInput>[
        for (final partItem in rawParts)
          MaintenancePartInput(
            partId: 0,
            quantity:
                BackupJsonCodec.asDouble(partItem[BackupKeys.quantity]) ?? 1,
            amount: BackupJsonCodec.asDouble(partItem[BackupKeys.amount]),
          ),
      ];
      if (validateMaintenanceWrite(
            totalAmount: totalAmount,
            odometerKm: odometerKm,
            parts: partInputs,
          ) !=
          null) {
        counters.skipped++;
        counters.skipped += rawParts.length;
        continue;
      }

      Maintenance? match;
      for (final row in existingMaintenances) {
        if (row.carId == carId &&
            row.serviceId == serviceId &&
            row.reminderId == reminderId &&
            BackupJsonCodec.sameDt(row.servicedAt, servicedAt) &&
            BackupJsonCodec.sameDouble(row.totalAmount, totalAmount) &&
            row.currencyCode == currencyCode &&
            BackupJsonCodec.sameDouble(row.odometerKm, odometerKm)) {
          match = row;
          break;
        }
      }
      if (match != null) {
        counters.skipped++;
        // Skip related parts as part of the duplicate maintenance.
        counters.skipped += rawParts.length;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.maintenances).insert(
            MaintenancesCompanion.insert(
              carId: carId,
              serviceId: Value(serviceId),
              reminderId: Value(reminderId),
              servicedAt: servicedAt,
              totalAmount: Value(totalAmount),
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
      existingMaintenances.add(
        Maintenance(
          id: newId,
          carId: carId,
          serviceId: serviceId,
          reminderId: reminderId,
          servicedAt: servicedAt,
          totalAmount: totalAmount,
          currencyCode: currencyCode,
          odometerKm: odometerKm,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      counters.added++;

      for (final partItem in rawParts) {
        final partId = BackupJsonCodec.mapRequired(
          BackupJsonCodec.asInt(partItem[BackupKeys.partId]),
          catalogs.partIdMap,
        );
        if (partId == null) {
          counters.skipped++;
          continue;
        }
        final unitMapped = BackupJsonCodec.mapOptionalFk(
          BackupJsonCodec.asInt(partItem[BackupKeys.unitId]),
          catalogs.partUnitIdMap,
        );
        if (unitMapped.unresolved) {
          counters.skipped++;
          continue;
        }
        final unitId = unitMapped.id;
        final quantity =
            BackupJsonCodec.asDouble(partItem[BackupKeys.quantity]) ?? 1;
        final amount = BackupJsonCodec.asDouble(partItem[BackupKeys.amount]);
        final comment = BackupJsonCodec.asString(partItem[BackupKeys.comment]);
        final partNow = DateTime.now();
        await _db.into(_db.maintenanceParts).insert(
              MaintenancePartsCompanion.insert(
                maintenanceId: newId,
                partId: Value(partId),
                quantity: Value(quantity),
                unitId: Value(unitId),
                amount: Value(amount),
                comment: Value(comment),
                createdAt: Value(
                  BackupJsonCodec.parseDt(partItem[BackupKeys.createdAt]) ??
                      partNow,
                ),
                updatedAt: Value(
                  BackupJsonCodec.parseDt(partItem[BackupKeys.updatedAt]) ??
                      partNow,
                ),
              ),
            );
        counters.added++;
      }
    }
  }
}
