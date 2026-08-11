import '../entities/statistics.dart';

abstract class StatisticsRepository {
  /// Years that have at least one fueling or maintenance for [carId].
  Future<List<int>> availableYears(int carId);

  /// Expense buckets for the chart.
  ///
  /// [StatsGroupBy.months] → 12 months of [focusYear].
  /// [StatsGroupBy.years] → one bucket per year from earliest data through
  /// [focusYear] (at least the focus year alone).
  Future<List<ExpenseBucket>> bucketsForCar(
    int carId, {
    required StatsGroupBy groupBy,
    required int focusYear,
  });

  /// Named breakdown for [from] inclusive … [to] exclusive.
  Future<StatisticsBreakdown> breakdownForCar(
    int carId, {
    required DateTime from,
    required DateTime to,
    required String unknownLabel,
  });

  /// Year details grouped by month → fuel/maintenance → named operations.
  /// Only months with expenses are returned, newest month first.
  Future<GroupedExpenseBreakdown> yearBreakdownForCar(
    int carId, {
    required int year,
    required String unknownLabel,
  });

  /// All years with expenses → fuel/maintenance → named operations.
  /// Newest year first.
  Future<GroupedExpenseBreakdown> yearsBreakdownForCar(
    int carId, {
    required String unknownLabel,
  });
}
