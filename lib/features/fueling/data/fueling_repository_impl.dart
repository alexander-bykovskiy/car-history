import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../../../shared/domain/money_totals.dart';
import '../domain/entities/fueling.dart';
import '../domain/entities/fueling_save.dart';
import '../domain/fueling_write_validation.dart';
import '../domain/repositories/fueling_repository.dart';
import 'mappers/fueling_mapper.dart';

class FuelingRepositoryImpl implements FuelingRepository {
  FuelingRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<void> watchFuelingsChanges() {
    return _db
        .tableUpdates(TableUpdateQuery.onTable(_db.fuelings))
        .map((_) {});
  }

  @override
  Future<List<FuelingListItem>> pageForCar(
    int carId, {
    DateTime? beforeFueledAt,
    int? beforeId,
    int limit = FuelingRepository.pageSize,
  }) async {
    assert(
      (beforeFueledAt == null) == (beforeId == null),
      'beforeFueledAt and beforeId must both be null or both set',
    );

    final query = (_db.select(_db.fuelings)
          ..where((t) {
            final forCar = t.carId.equals(carId);
            if (beforeFueledAt == null || beforeId == null) return forCar;
            return forCar &
                (t.fueledAt.isSmallerThanValue(beforeFueledAt) |
                    (t.fueledAt.equals(beforeFueledAt) &
                        t.id.isSmallerThanValue(beforeId)));
          })
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.fueledAt,
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
        _db.fuelTypes,
        _db.fuelTypes.id.equalsExp(_db.fuelings.fuelTypeId),
      ),
      leftOuterJoin(
        _db.gasStationLocations,
        _db.gasStationLocations.id.equalsExp(_db.fuelings.gasStationId),
      ),
      leftOuterJoin(
        _db.gasStationChains,
        _db.gasStationChains.id
            .equalsExp(_db.gasStationLocations.chainId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) => fuelingListItemFromJoin(row, _db)).toList();
  }

  @override
  Future<MonthCurrencyTotals> monthTotalsForCar(int carId) async {
    final query = _db.selectOnly(_db.fuelings)
      ..addColumns([
        _db.fuelings.fueledAt,
        _db.fuelings.totalAmount,
        _db.fuelings.currencyCode,
      ])
      ..where(_db.fuelings.carId.equals(carId));
    final rows = await query.get();
    final totals = <(int, int), CurrencyAmounts>{};
    for (final row in rows) {
      final at = row.read(_db.fuelings.fueledAt)!;
      final amount = row.read(_db.fuelings.totalAmount)!;
      final currency = row.read(_db.fuelings.currencyCode)!;
      final key = (at.year, at.month);
      final bucket = totals.putIfAbsent(key, () => <String, double>{});
      addCurrencyAmount(bucket, currency, amount);
    }
    return totals;
  }

  @override
  Future<FuelingRecord?> latestForCar(int carId) async {
    final row = await (_db.select(_db.fuelings)
          ..where((t) => t.carId.equals(carId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.fueledAt,
                  mode: OrderingMode.desc,
                ),
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : fuelingRecordFromRow(row);
  }

  @override
  Future<FuelingSaveOutcome> create({
    required int carId,
    required int fuelTypeId,
    required DateTime fueledAt,
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    required String currencyCode,
    int? gasStationId,
    double? odometerKm,
  }) async {
    final validation = _validate(
      pricePerLiter: pricePerLiter,
      liters: liters,
      totalAmount: totalAmount,
      odometerKm: odometerKm,
    );
    if (validation != null) {
      return FuelingSaveOutcome(validation);
    }

    final now = DateTime.now();
    final id = await _db.into(_db.fuelings).insert(
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
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final created = await (_db.select(_db.fuelings)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return FuelingSaveOutcome(
      FuelingSaveResult.created,
      item: fuelingRecordFromRow(created),
    );
  }

  @override
  Future<FuelingSaveOutcome> update({
    required int id,
    required int fuelTypeId,
    required DateTime fueledAt,
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    required String currencyCode,
    int? gasStationId,
    double? odometerKm,
  }) async {
    final validation = _validate(
      pricePerLiter: pricePerLiter,
      liters: liters,
      totalAmount: totalAmount,
      odometerKm: odometerKm,
    );
    if (validation != null) {
      return FuelingSaveOutcome(validation);
    }

    await (_db.update(_db.fuelings)..where((t) => t.id.equals(id))).write(
      FuelingsCompanion(
        fuelTypeId: Value(fuelTypeId),
        gasStationId: Value(gasStationId),
        fueledAt: Value(fueledAt),
        pricePerLiter: Value(pricePerLiter),
        liters: Value(liters),
        totalAmount: Value(totalAmount),
        currencyCode: Value(currencyCode),
        odometerKm: Value(odometerKm),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await (_db.select(_db.fuelings)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return FuelingSaveOutcome(
      FuelingSaveResult.updated,
      item: fuelingRecordFromRow(updated),
    );
  }

  FuelingSaveResult? _validate({
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    double? odometerKm,
  }) {
    return validateFuelingWrite(
      pricePerLiter: pricePerLiter,
      liters: liters,
      totalAmount: totalAmount,
      odometerKm: odometerKm,
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.fuelings)..where((t) => t.id.equals(id))).go();
  }
}
