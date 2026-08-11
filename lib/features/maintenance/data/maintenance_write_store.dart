import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../domain/entities/maintenance.dart';
import '../domain/entities/maintenance_save.dart';
import '../domain/maintenance_write_validation.dart';
import 'mappers/maintenance_mapper.dart';
import 'maintenance_query_store.dart';

/// Create / update / delete surface for maintenances and parts.
class MaintenanceWriteStore {
  MaintenanceWriteStore(this._db, this._query);

  final AppDatabase _db;
  final MaintenanceQueryStore _query;

  Future<MaintenanceSaveOutcome> create({
    required int carId,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  }) async {
    final validation = _validate(
      totalAmount: totalAmount,
      odometerKm: odometerKm,
      parts: parts,
    );
    if (validation != null) {
      return MaintenanceSaveOutcome(validation);
    }

    final now = DateTime.now();
    final id = await _db.into(_db.maintenances).insert(
          MaintenancesCompanion.insert(
            carId: carId,
            serviceId: Value(serviceId),
            servicedAt: servicedAt,
            totalAmount: Value(totalAmount),
            currencyCode: Value(currencyCode),
            odometerKm: Value(odometerKm),
            reminderId: Value(reminderId),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await _replaceParts(id, parts);
    final created = await _query.getById(id);
    return MaintenanceSaveOutcome(
      MaintenanceSaveResult.created,
      item: maintenanceRecordFromRow(created!),
    );
  }

  Future<MaintenanceSaveOutcome> update({
    required int id,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  }) async {
    final validation = _validate(
      totalAmount: totalAmount,
      odometerKm: odometerKm,
      parts: parts,
    );
    if (validation != null) {
      return MaintenanceSaveOutcome(validation);
    }

    await (_db.update(_db.maintenances)..where((t) => t.id.equals(id))).write(
      MaintenancesCompanion(
        serviceId: Value(serviceId),
        servicedAt: Value(servicedAt),
        totalAmount: Value(totalAmount),
        currencyCode: Value(currencyCode),
        odometerKm: Value(odometerKm),
        reminderId: Value(reminderId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _replaceParts(id, parts);
    final updated = await _query.getById(id);
    return MaintenanceSaveOutcome(
      MaintenanceSaveResult.updated,
      item: maintenanceRecordFromRow(updated!),
    );
  }

  Future<int?> delete(int id) async {
    final item = await _query.getById(id);
    if (item == null) return null;
    final reminderId = item.reminderId;
    await (_db.delete(_db.maintenances)..where((t) => t.id.equals(id))).go();
    return reminderId;
  }

  Future<void> _replaceParts(
    int maintenanceId,
    List<MaintenancePartInput> parts,
  ) async {
    await (_db.delete(_db.maintenanceParts)
          ..where((t) => t.maintenanceId.equals(maintenanceId)))
        .go();

    if (parts.isEmpty) return;

    final now = DateTime.now();
    await _db.batch((batch) {
      batch.insertAll(
        _db.maintenanceParts,
        parts
            .map(
              (part) => MaintenancePartsCompanion.insert(
                maintenanceId: maintenanceId,
                partId: Value(part.partId),
                quantity: Value(part.quantity),
                unitId: Value(part.unitId),
                amount: Value(part.amount),
                comment: Value(part.comment),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            )
            .toList(),
      );
    });
  }

  MaintenanceSaveResult? _validate({
    double? totalAmount,
    double? odometerKm,
    List<MaintenancePartInput> parts = const [],
  }) {
    return validateMaintenanceWrite(
      totalAmount: totalAmount,
      odometerKm: odometerKm,
      parts: parts,
    );
  }
}
