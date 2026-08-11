import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../../../shared/domain/money_totals.dart';
import '../domain/entities/maintenance.dart';
import '../domain/repositories/maintenance_repository.dart';
import 'mappers/maintenance_mapper.dart';

/// Read / watch surface for maintenances and parts.
class MaintenanceQueryStore {
  MaintenanceQueryStore(this._db);

  final AppDatabase _db;

  Stream<void> watchMaintenancesChanges() {
    return _db
        .tableUpdates(TableUpdateQuery.onTable(_db.maintenances))
        .map((_) {});
  }

  Future<List<MaintenanceListItem>> pageForCar(
    int carId, {
    DateTime? beforeServicedAt,
    int? beforeId,
    int limit = MaintenanceRepository.pageSize,
  }) async {
    assert(
      (beforeServicedAt == null) == (beforeId == null),
      'beforeServicedAt and beforeId must both be null or both set',
    );

    final query = (_db.select(_db.maintenances)
          ..where((t) {
            final forCar = t.carId.equals(carId);
            if (beforeServicedAt == null || beforeId == null) return forCar;
            return forCar &
                (t.servicedAt.isSmallerThanValue(beforeServicedAt) |
                    (t.servicedAt.equals(beforeServicedAt) &
                        t.id.isSmallerThanValue(beforeId)));
          })
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.servicedAt,
                  mode: OrderingMode.desc,
                ),
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(limit))
        .join([
      leftOuterJoin(
        _db.services,
        _db.services.id.equalsExp(_db.maintenances.serviceId),
      ),
    ]);

    final rows = await query.get();
    final items = <MaintenanceListItem>[
      for (final row in rows)
        maintenanceListItemFromJoin(
          maintenance: row.readTable(_db.maintenances),
          serviceName: row.readTableOrNull(_db.services)?.name,
          serviceIconKey: row.readTableOrNull(_db.services)?.iconKey,
        ),
    ];
    final partsTotals = await partsTotalsFor(
      items.map((item) => item.id).toList(),
    );
    return [
      for (final item in items)
        MaintenanceListItem(
          id: item.id,
          carId: item.carId,
          serviceId: item.serviceId,
          reminderId: item.reminderId,
          servicedAt: item.servicedAt,
          totalAmount: item.totalAmount,
          currencyCode: item.currencyCode,
          odometerKm: item.odometerKm,
          serviceName: item.serviceName,
          serviceIconKey: item.serviceIconKey,
          partsTotal: partsTotals[item.id] ?? 0,
        ),
    ];
  }

  Future<MonthCurrencyTotals> monthTotalsForCar(int carId) async {
    final query = _db.selectOnly(_db.maintenances)
      ..addColumns([
        _db.maintenances.id,
        _db.maintenances.servicedAt,
        _db.maintenances.totalAmount,
        _db.maintenances.currencyCode,
      ])
      ..where(_db.maintenances.carId.equals(carId));
    final rows = await query.get();
    final ids = [
      for (final row in rows) row.read(_db.maintenances.id)!,
    ];
    final partsTotals = await partsTotalsFor(ids);
    final totals = <(int, int), CurrencyAmounts>{};
    for (final row in rows) {
      final id = row.read(_db.maintenances.id)!;
      final at = row.read(_db.maintenances.servicedAt)!;
      final labor = row.read(_db.maintenances.totalAmount) ?? 0;
      final currency = row.read(_db.maintenances.currencyCode)!;
      final key = (at.year, at.month);
      final bucket = totals.putIfAbsent(key, () => <String, double>{});
      addCurrencyAmount(bucket, currency, labor + (partsTotals[id] ?? 0));
    }
    return totals;
  }

  Future<Map<int, double>> partsTotalsFor(List<int> maintenanceIds) async {
    if (maintenanceIds.isEmpty) return const {};
    final rows = await (_db.select(_db.maintenanceParts)
          ..where((t) => t.maintenanceId.isIn(maintenanceIds)))
        .get();
    final totals = <int, double>{};
    for (final row in rows) {
      final unitPrice = row.amount;
      if (unitPrice == null) continue;
      totals[row.maintenanceId] =
          (totals[row.maintenanceId] ?? 0) + row.quantity * unitPrice;
    }
    return totals;
  }

  Future<MaintenanceRecord?> latestForCar(int carId) async {
    final row = await (_db.select(_db.maintenances)
          ..where((t) => t.carId.equals(carId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.servicedAt,
                  mode: OrderingMode.desc,
                ),
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : maintenanceRecordFromRow(row);
  }

  Future<List<MaintenancePartLine>> partsForMaintenance(
    int maintenanceId,
  ) async {
    final query = (_db.select(_db.maintenanceParts)
          ..where((t) => t.maintenanceId.equals(maintenanceId))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .join([
      leftOuterJoin(
        _db.parts,
        _db.parts.id.equalsExp(_db.maintenanceParts.partId),
      ),
      leftOuterJoin(
        _db.partUnits,
        _db.partUnits.id.equalsExp(_db.maintenanceParts.unitId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) {
      final line = row.readTable(_db.maintenanceParts);
      final part = row.readTableOrNull(_db.parts);
      final unit = row.readTableOrNull(_db.partUnits);
      return MaintenancePartLine(
        id: line.id,
        partId: line.partId ?? 0,
        partName: part?.name ?? '',
        quantity: line.quantity,
        unitId: line.unitId,
        unitName: unit?.name,
        amount: line.amount,
        comment: line.comment,
      );
    }).where((line) => line.partId != 0 && line.partName.isNotEmpty).toList();
  }

  Future<Maintenance?> getById(int id) {
    return (_db.select(_db.maintenances)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }
}
