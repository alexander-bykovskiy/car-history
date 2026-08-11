import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../domain/entities/statistics.dart';
import '../domain/repositories/statistics_repository.dart';
import 'statistics_breakdown_query.dart';
import 'statistics_buckets_query.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<int>> availableYears(int carId) async {
    final rows = await _db.customSelect(
      '''
      SELECT y FROM (
        SELECT CAST(strftime('%Y', fueled_at, 'unixepoch') AS INTEGER) AS y
        FROM fuelings WHERE car_id = ?
        UNION
        SELECT CAST(strftime('%Y', serviced_at, 'unixepoch') AS INTEGER) AS y
        FROM maintenances WHERE car_id = ?
      )
      ORDER BY y
      ''',
      variables: [Variable.withInt(carId), Variable.withInt(carId)],
      readsFrom: {_db.fuelings, _db.maintenances},
    ).get();
    return [
      for (final row in rows)
        if (row.read<int?>('y') != null) row.read<int>('y'),
    ];
  }

  @override
  Future<List<ExpenseBucket>> bucketsForCar(
    int carId, {
    required StatsGroupBy groupBy,
    required int focusYear,
  }) async {
    if (groupBy == StatsGroupBy.months) {
      return loadMonthExpenseBuckets(
        _db,
        carId: carId,
        focusYear: focusYear,
      );
    }

    final years = <int>{
      focusYear,
      ...await availableYears(carId),
    }.toList()
      ..sort();

    return loadYearExpenseBuckets(
      _db,
      carId: carId,
      years: years,
    );
  }

  @override
  Future<StatisticsBreakdown> breakdownForCar(
    int carId, {
    required DateTime from,
    required DateTime to,
    required String unknownLabel,
  }) {
    return loadStatisticsBreakdown(
      _db,
      carId: carId,
      from: from,
      to: to,
      unknownLabel: unknownLabel,
    );
  }

  @override
  Future<GroupedExpenseBreakdown> yearBreakdownForCar(
    int carId, {
    required int year,
    required String unknownLabel,
  }) {
    return loadYearGroupedBreakdown(
      _db,
      carId: carId,
      year: year,
      unknownLabel: unknownLabel,
    );
  }

  @override
  Future<GroupedExpenseBreakdown> yearsBreakdownForCar(
    int carId, {
    required String unknownLabel,
  }) async {
    final years = await availableYears(carId);
    if (years.isEmpty) {
      return const GroupedExpenseBreakdown(periods: []);
    }

    final periods = <PeriodExpenseBreakdown>[];
    for (final year in years.reversed) {
      final flat = await breakdownForCar(
        carId,
        from: DateTime(year),
        to: DateTime(year + 1),
        unknownLabel: unknownLabel,
      );
      if (flat.isEmpty) continue;
      periods.add(
        PeriodExpenseBreakdown(
          year: year,
          fuelByType: flat.fuelByType,
          maintenanceByService: flat.maintenanceByService,
        ),
      );
    }
    return GroupedExpenseBreakdown(periods: periods);
  }
}
