import 'package:car_history/features/statistics/domain/entities/statistics.dart';
import 'package:car_history/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:car_history/features/statistics/presentation/controllers/statistics_body_controller.dart';
import 'package:car_history/shared/domain/expenses_change_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStatsRepo implements StatisticsRepository {
  _FakeStatsRepo({
    this.buckets = const [],
  });

  final List<ExpenseBucket> buckets;

  @override
  Future<List<int>> availableYears(int carId) async => const [2024, 2025];

  @override
  Future<List<ExpenseBucket>> bucketsForCar(
    int carId, {
    required StatsGroupBy groupBy,
    required int focusYear,
  }) async =>
      buckets;

  @override
  Future<StatisticsBreakdown> breakdownForCar(
    int carId, {
    required DateTime from,
    required DateTime to,
    required String unknownLabel,
  }) async {
    return const StatisticsBreakdown(
      fuelByType: [],
      maintenanceByService: [],
    );
  }

  @override
  Future<GroupedExpenseBreakdown> yearBreakdownForCar(
    int carId, {
    required int year,
    required String unknownLabel,
  }) async {
    return GroupedExpenseBreakdown(
      periods: [
        PeriodExpenseBreakdown(
          year: year,
          month: 1,
          fuelByType: const [],
          maintenanceByService: const [],
        ),
      ],
    );
  }

  @override
  Future<GroupedExpenseBreakdown> yearsBreakdownForCar(
    int carId, {
    required String unknownLabel,
  }) async {
    return const GroupedExpenseBreakdown(periods: []);
  }
}

class _FakeChanges implements ExpensesChangeSource {
  @override
  Stream<void> watchExpensesChanged() => const Stream.empty();
}

void main() {
  test('StatisticsBodyController clears state when carId is null', () async {
    final controller = StatisticsBodyController(
      groupBy: StatsGroupBy.months,
      unknownLabel: 'Other',
    );
    addTearDown(controller.dispose);

    final repo = _FakeStatsRepo(
      buckets: [
        const ExpenseBucket(
          year: 2025,
          month: 1,
          fuelByCurrency: {'EUR': 5},
          maintenanceByCurrency: {},
        ),
      ],
    );

    controller.bindCar(repository: repo, changes: _FakeChanges(), carId: 1);
    await Future<void>.delayed(Duration.zero);
    expect(controller.buckets, isNotEmpty);

    controller.bindCar(repository: repo, changes: _FakeChanges(), carId: null);
    await Future<void>.delayed(Duration.zero);
    expect(controller.buckets, isEmpty);
    expect(controller.loading, isFalse);
  });

  test('periodTitle for months uses focus year', () {
    final controller = StatisticsBodyController(
      groupBy: StatsGroupBy.months,
      unknownLabel: 'Other',
    );
    addTearDown(controller.dispose);
    controller.focusYear = 2023;
    expect(controller.periodTitle, '2023');
  });
}
