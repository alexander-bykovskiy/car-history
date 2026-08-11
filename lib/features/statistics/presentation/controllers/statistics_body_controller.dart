import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../../../shared/domain/expenses_change_source.dart';

/// Loads chart buckets + breakdown for one [StatsGroupBy] tab.
///
/// Dependencies are passed from the page (no [WidgetRef]).
class StatisticsBodyController extends ChangeNotifier {
  StatisticsBodyController({
    required this.groupBy,
    required this.unknownLabel,
  });

  final StatsGroupBy groupBy;
  final String unknownLabel;

  int focusYear = DateTime.now().year;
  int? selectedBucketIndex;
  List<ExpenseBucket> buckets = const [];
  GroupedExpenseBreakdown grouped = const GroupedExpenseBreakdown(periods: []);
  bool loading = true;

  StreamSubscription<void>? _changesSub;
  int? _boundCarId;
  bool _disposed = false;

  ExpenseBucket? get selectedBucket {
    final index = selectedBucketIndex;
    if (index == null || index < 0 || index >= buckets.length) return null;
    return buckets[index];
  }

  int get detailYear {
    final selected = selectedBucket;
    if (groupBy == StatsGroupBy.years && selected != null) {
      return selected.year;
    }
    return focusYear;
  }

  String get periodTitle {
    if (groupBy == StatsGroupBy.months) return '$detailYear';
    if (grouped.periods.isEmpty) return '$detailYear';
    final newest = grouped.periods.first.year;
    final oldest = grouped.periods.last.year;
    if (newest == oldest) return '$newest';
    return '$oldest–$newest';
  }

  void bindCar({
    required StatisticsRepository repository,
    required ExpensesChangeSource changes,
    required int? carId,
  }) {
    if (_boundCarId == carId) return;
    _boundCarId = carId;
    selectedBucketIndex = null;
    _changesSub?.cancel();
    if (carId != null) {
      _changesSub = changes.watchExpensesChanged().listen((_) {
        reload(repository);
      });
    }
    reload(repository);
  }

  Future<GroupedExpenseBreakdown> _loadGrouped({
    required StatisticsRepository repo,
    required int carId,
    required int year,
  }) {
    if (groupBy == StatsGroupBy.months) {
      return repo.yearBreakdownForCar(
        carId,
        year: year,
        unknownLabel: unknownLabel,
      );
    }
    return repo.yearsBreakdownForCar(carId, unknownLabel: unknownLabel);
  }

  int _defaultMonthIndex(int year) {
    final now = DateTime.now();
    if (year == now.year) return now.month - 1;
    return 0;
  }

  Future<void> reloadBreakdownOnly(StatisticsRepository repository) async {
    final carId = _boundCarId;
    if (carId == null) return;
    if (groupBy == StatsGroupBy.years) return;
    final groupedResult = await _loadGrouped(
      repo: repository,
      carId: carId,
      year: detailYear,
    );
    if (_disposed) return;
    grouped = groupedResult;
    notifyListeners();
  }

  Future<void> reload(StatisticsRepository repository) async {
    final carId = _boundCarId;
    if (_disposed) return;

    if (carId == null) {
      buckets = const [];
      grouped = const GroupedExpenseBreakdown(periods: []);
      loading = false;
      notifyListeners();
      return;
    }

    loading = true;
    notifyListeners();

    final years = await repository.availableYears(carId);
    if (_disposed) return;

    var nextFocus = focusYear;
    final yearChoices = {
      DateTime.now().year,
      ...years,
    }.toList()
      ..sort();
    if (!yearChoices.contains(nextFocus)) {
      nextFocus = yearChoices.isEmpty ? DateTime.now().year : yearChoices.last;
    }

    final nextBuckets = await repository.bucketsForCar(
      carId,
      groupBy: groupBy,
      focusYear: nextFocus,
    );
    if (_disposed) return;

    var selectedIndex = selectedBucketIndex;
    if (groupBy == StatsGroupBy.months) {
      selectedIndex ??= _defaultMonthIndex(nextFocus);
      if (selectedIndex < 0 || selectedIndex >= nextBuckets.length) {
        selectedIndex = _defaultMonthIndex(nextFocus);
      }
    } else {
      if (selectedIndex != null &&
          (selectedIndex < 0 || selectedIndex >= nextBuckets.length)) {
        selectedIndex = null;
      }
      selectedIndex ??= () {
        final focusIndex = nextBuckets.indexWhere((b) => b.year == nextFocus);
        return focusIndex >= 0
            ? focusIndex
            : (nextBuckets.isEmpty ? null : nextBuckets.length - 1);
      }();
    }

    final nextDetailYear = () {
      if (groupBy == StatsGroupBy.years &&
          selectedIndex != null &&
          selectedIndex >= 0 &&
          selectedIndex < nextBuckets.length) {
        return nextBuckets[selectedIndex].year;
      }
      return nextFocus;
    }();

    final nextGrouped = await _loadGrouped(
      repo: repository,
      carId: carId,
      year: nextDetailYear,
    );
    if (_disposed) return;

    focusYear = nextFocus;
    buckets = nextBuckets;
    selectedBucketIndex = selectedIndex;
    grouped = nextGrouped;
    loading = false;
    notifyListeners();
  }

  Future<void> goPrevious(StatisticsRepository repository) async {
    if (groupBy == StatsGroupBy.years) return;
    focusYear -= 1;
    selectedBucketIndex = null;
    notifyListeners();
    await reload(repository);
  }

  Future<void> goNext(StatisticsRepository repository) async {
    if (groupBy == StatsGroupBy.years) return;
    final now = DateTime.now();
    if (focusYear >= now.year) return;
    focusYear += 1;
    selectedBucketIndex = null;
    notifyListeners();
    await reload(repository);
  }

  Future<void> onChartSelect(
    StatisticsRepository repository,
    int index,
  ) async {
    if (selectedBucketIndex == index) return;
    final bucket = buckets[index];
    final yearChanged = bucket.year != detailYear;
    selectedBucketIndex = index;
    focusYear = bucket.year;
    notifyListeners();
    if (groupBy == StatsGroupBy.months && yearChanged) {
      await reloadBreakdownOnly(repository);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _changesSub?.cancel();
    super.dispose();
  }
}
