import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../domain/entities/statistics.dart';
import 'statistics_query_support.dart';

Future<StatisticsBreakdown> loadStatisticsBreakdown(
  AppDatabase db, {
  required int carId,
  required DateTime from,
  required DateTime to,
  required String unknownLabel,
}) async {
  final fuelRows = await db.customSelect(
    '''
    SELECT COALESCE(ft.name, ?) AS name,
           f.currency_code AS currency_code,
           SUM(f.total_amount) AS total
    FROM fuelings f
    LEFT JOIN fuel_types ft ON ft.id = f.fuel_type_id
    WHERE f.car_id = ?
      AND f.fueled_at >= ?
      AND f.fueled_at < ?
    GROUP BY name, f.currency_code
    ''',
    variables: [
      Variable.withString(unknownLabel),
      Variable.withInt(carId),
      Variable.withDateTime(from),
      Variable.withDateTime(to),
    ],
    readsFrom: {db.fuelings, db.fuelTypes},
  ).get();

  final fuelTotals = <(String name, String currency), double>{};
  for (final row in fuelRows) {
    final key = (row.read<String>('name'), row.read<String>('currency_code'));
    fuelTotals[key] = row.read<double>('total');
  }

  final serviceRows = await db.customSelect(
    '''
    SELECT COALESCE(s.name, ?) AS name,
           m.currency_code AS currency_code,
           SUM(COALESCE(m.total_amount, 0) + COALESCE(p.parts_total, 0)) AS total
    FROM maintenances m
    LEFT JOIN services s ON s.id = m.service_id
    LEFT JOIN (
      $kMaintenancePartsTotalSql
    ) p ON p.maintenance_id = m.id
    WHERE m.car_id = ?
      AND m.serviced_at >= ?
      AND m.serviced_at < ?
    GROUP BY name, m.currency_code
    HAVING total > 0
    ''',
    variables: [
      Variable.withString(unknownLabel),
      Variable.withInt(carId),
      Variable.withDateTime(from),
      Variable.withDateTime(to),
    ],
    readsFrom: {db.maintenances, db.services, db.maintenanceParts},
  ).get();

  final serviceTotals = <(String name, String currency), double>{};
  for (final row in serviceRows) {
    final key = (row.read<String>('name'), row.read<String>('currency_code'));
    serviceTotals[key] = row.read<double>('total');
  }

  return StatisticsBreakdown(
    fuelByType: sortedNamedExpenses(fuelTotals),
    maintenanceByService: sortedNamedExpenses(serviceTotals),
  );
}

Future<GroupedExpenseBreakdown> loadYearGroupedBreakdown(
  AppDatabase db, {
  required int carId,
  required int year,
  required String unknownLabel,
}) async {
  final from = DateTime(year);
  final to = DateTime(year + 1);

  final fuelRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%m', f.fueled_at, 'unixepoch') AS INTEGER) AS month,
           COALESCE(ft.name, ?) AS name,
           f.currency_code AS currency_code,
           SUM(f.total_amount) AS total
    FROM fuelings f
    LEFT JOIN fuel_types ft ON ft.id = f.fuel_type_id
    WHERE f.car_id = ?
      AND f.fueled_at >= ?
      AND f.fueled_at < ?
    GROUP BY month, name, f.currency_code
    ''',
    variables: [
      Variable.withString(unknownLabel),
      Variable.withInt(carId),
      Variable.withDateTime(from),
      Variable.withDateTime(to),
    ],
    readsFrom: {db.fuelings, db.fuelTypes},
  ).get();

  final fuelByMonth = <int, Map<(String, String), double>>{};
  for (final row in fuelRows) {
    final month = row.read<int>('month');
    final bucket = fuelByMonth.putIfAbsent(month, () => {});
    final key = (row.read<String>('name'), row.read<String>('currency_code'));
    bucket[key] = (bucket[key] ?? 0) + row.read<double>('total');
  }

  final serviceRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%m', m.serviced_at, 'unixepoch') AS INTEGER) AS month,
           COALESCE(s.name, ?) AS name,
           m.currency_code AS currency_code,
           SUM(COALESCE(m.total_amount, 0) + COALESCE(p.parts_total, 0)) AS total
    FROM maintenances m
    LEFT JOIN services s ON s.id = m.service_id
    LEFT JOIN (
      $kMaintenancePartsTotalSql
    ) p ON p.maintenance_id = m.id
    WHERE m.car_id = ?
      AND m.serviced_at >= ?
      AND m.serviced_at < ?
    GROUP BY month, name, m.currency_code
    HAVING total > 0
    ''',
    variables: [
      Variable.withString(unknownLabel),
      Variable.withInt(carId),
      Variable.withDateTime(from),
      Variable.withDateTime(to),
    ],
    readsFrom: {db.maintenances, db.services, db.maintenanceParts},
  ).get();

  final serviceByMonth = <int, Map<(String, String), double>>{};
  for (final row in serviceRows) {
    final month = row.read<int>('month');
    final bucket = serviceByMonth.putIfAbsent(month, () => {});
    final key = (row.read<String>('name'), row.read<String>('currency_code'));
    bucket[key] = (bucket[key] ?? 0) + row.read<double>('total');
  }

  final months = {
    ...fuelByMonth.keys,
    ...serviceByMonth.keys,
  }.toList()
    ..sort((a, b) => b.compareTo(a));

  return GroupedExpenseBreakdown(
    periods: [
      for (final month in months)
        PeriodExpenseBreakdown(
          year: year,
          month: month,
          fuelByType: sortedNamedExpenses(fuelByMonth[month] ?? const {}),
          maintenanceByService:
              sortedNamedExpenses(serviceByMonth[month] ?? const {}),
        ),
    ],
  );
}
