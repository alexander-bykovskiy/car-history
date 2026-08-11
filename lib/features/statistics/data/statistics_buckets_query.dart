import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../../../shared/domain/money_totals.dart';
import '../domain/entities/statistics.dart';
import 'statistics_query_support.dart';

Future<List<ExpenseBucket>> loadMonthExpenseBuckets(
  AppDatabase db, {
  required int carId,
  required int focusYear,
}) async {
  final fuelByMonth = List<CurrencyAmounts>.generate(
    12,
    (_) => <String, double>{},
  );
  final maintenanceByMonth = List<CurrencyAmounts>.generate(
    12,
    (_) => <String, double>{},
  );

  final fuelRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%m', fueled_at, 'unixepoch') AS INTEGER) AS month,
           currency_code,
           SUM(total_amount) AS total
    FROM fuelings
    WHERE car_id = ?
      AND CAST(strftime('%Y', fueled_at, 'unixepoch') AS INTEGER) = ?
    GROUP BY month, currency_code
    ''',
    variables: [Variable.withInt(carId), Variable.withInt(focusYear)],
    readsFrom: {db.fuelings},
  ).get();
  for (final row in fuelRows) {
    final month = row.read<int>('month');
    final currency = row.read<String>('currency_code');
    final total = row.read<double>('total');
    addCurrencyAmount(fuelByMonth[month - 1], currency, total);
  }

  final maintenanceRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%m', m.serviced_at, 'unixepoch') AS INTEGER) AS month,
           m.currency_code AS currency_code,
           SUM(COALESCE(m.total_amount, 0) + COALESCE(p.parts_total, 0)) AS total
    FROM maintenances m
    LEFT JOIN (
      $kMaintenancePartsTotalSql
    ) p ON p.maintenance_id = m.id
    WHERE m.car_id = ?
      AND CAST(strftime('%Y', m.serviced_at, 'unixepoch') AS INTEGER) = ?
    GROUP BY month, m.currency_code
    ''',
    variables: [Variable.withInt(carId), Variable.withInt(focusYear)],
    readsFrom: {db.maintenances, db.maintenanceParts},
  ).get();
  for (final row in maintenanceRows) {
    final month = row.read<int>('month');
    final currency = row.read<String>('currency_code');
    final total = row.read<double>('total');
    addCurrencyAmount(maintenanceByMonth[month - 1], currency, total);
  }

  return [
    for (var month = 1; month <= 12; month++)
      ExpenseBucket(
        year: focusYear,
        month: month,
        fuelByCurrency: Map<String, double>.from(fuelByMonth[month - 1]),
        maintenanceByCurrency:
            Map<String, double>.from(maintenanceByMonth[month - 1]),
      ),
  ];
}

Future<List<ExpenseBucket>> loadYearExpenseBuckets(
  AppDatabase db, {
  required int carId,
  required List<int> years,
}) async {
  final fuelByYear = <int, CurrencyAmounts>{
    for (final year in years) year: <String, double>{},
  };
  final maintenanceByYear = <int, CurrencyAmounts>{
    for (final year in years) year: <String, double>{},
  };

  final fuelRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%Y', fueled_at, 'unixepoch') AS INTEGER) AS year,
           currency_code,
           SUM(total_amount) AS total
    FROM fuelings
    WHERE car_id = ?
    GROUP BY year, currency_code
    ''',
    variables: [Variable.withInt(carId)],
    readsFrom: {db.fuelings},
  ).get();
  for (final row in fuelRows) {
    final year = row.read<int>('year');
    final bucket = fuelByYear[year];
    if (bucket == null) continue;
    addCurrencyAmount(
      bucket,
      row.read<String>('currency_code'),
      row.read<double>('total'),
    );
  }

  final maintenanceRows = await db.customSelect(
    '''
    SELECT CAST(strftime('%Y', m.serviced_at, 'unixepoch') AS INTEGER) AS year,
           m.currency_code AS currency_code,
           SUM(COALESCE(m.total_amount, 0) + COALESCE(p.parts_total, 0)) AS total
    FROM maintenances m
    LEFT JOIN (
      $kMaintenancePartsTotalSql
    ) p ON p.maintenance_id = m.id
    WHERE m.car_id = ?
    GROUP BY year, m.currency_code
    ''',
    variables: [Variable.withInt(carId)],
    readsFrom: {db.maintenances, db.maintenanceParts},
  ).get();
  for (final row in maintenanceRows) {
    final year = row.read<int>('year');
    final bucket = maintenanceByYear[year];
    if (bucket == null) continue;
    addCurrencyAmount(
      bucket,
      row.read<String>('currency_code'),
      row.read<double>('total'),
    );
  }

  return [
    for (final year in years)
      ExpenseBucket(
        year: year,
        fuelByCurrency: Map<String, double>.from(fuelByYear[year] ?? const {}),
        maintenanceByCurrency:
            Map<String, double>.from(maintenanceByYear[year] ?? const {}),
      ),
  ];
}
