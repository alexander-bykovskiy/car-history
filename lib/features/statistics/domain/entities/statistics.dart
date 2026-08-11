import '../../../../shared/domain/money_totals.dart';

enum StatsGroupBy { months, years }

/// Named expense line with amounts stacked per currency (one name, many codes).
class NamedExpense {
  const NamedExpense({
    required this.name,
    required this.amountsByCurrency,
  });

  final String name;
  final CurrencyAmounts amountsByCurrency;

  /// Largest single-currency amount — used for list ordering.
  double get sortAmount {
    final values = sortedNonZeroCurrencyAmounts(amountsByCurrency);
    if (values.isEmpty) return 0;
    return values.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.year,
    required this.fuelByCurrency,
    required this.maintenanceByCurrency,
    this.month,
  });

  final int year;
  final int? month;
  final CurrencyAmounts fuelByCurrency;
  final CurrencyAmounts maintenanceByCurrency;

  CurrencyAmounts get totalByCurrency =>
      mergeCurrencyAmounts(fuelByCurrency, maintenanceByCurrency);

  /// Tallest single-currency stack in this bucket (for chart scale).
  double get maxCurrencyTotal {
    final totals = sortedNonZeroCurrencyAmounts(totalByCurrency);
    if (totals.isEmpty) return 0;
    return totals
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
  }

  bool get hasExpenses =>
      sortedNonZeroCurrencyAmounts(totalByCurrency).isNotEmpty;
}

class StatisticsBreakdown {
  const StatisticsBreakdown({
    required this.fuelByType,
    required this.maintenanceByService,
  });

  final List<NamedExpense> fuelByType;
  final List<NamedExpense> maintenanceByService;

  CurrencyAmounts get fuelTotalsByCurrency {
    var totals = <String, double>{};
    for (final item in fuelByType) {
      totals = mergeCurrencyAmounts(totals, item.amountsByCurrency);
    }
    return totals;
  }

  CurrencyAmounts get maintenanceTotalsByCurrency {
    var totals = <String, double>{};
    for (final item in maintenanceByService) {
      totals = mergeCurrencyAmounts(totals, item.amountsByCurrency);
    }
    return totals;
  }

  CurrencyAmounts get totalsByCurrency =>
      mergeCurrencyAmounts(fuelTotalsByCurrency, maintenanceTotalsByCurrency);

  bool get isEmpty => fuelByType.isEmpty && maintenanceByService.isEmpty;
}

/// One period block: a month (month != null) or a whole year (month == null).
class PeriodExpenseBreakdown {
  const PeriodExpenseBreakdown({
    required this.year,
    required this.fuelByType,
    required this.maintenanceByService,
    this.month,
  });

  final int year;
  final int? month;
  final List<NamedExpense> fuelByType;
  final List<NamedExpense> maintenanceByService;

  CurrencyAmounts get fuelTotalsByCurrency {
    var totals = <String, double>{};
    for (final item in fuelByType) {
      totals = mergeCurrencyAmounts(totals, item.amountsByCurrency);
    }
    return totals;
  }

  CurrencyAmounts get maintenanceTotalsByCurrency {
    var totals = <String, double>{};
    for (final item in maintenanceByService) {
      totals = mergeCurrencyAmounts(totals, item.amountsByCurrency);
    }
    return totals;
  }

  CurrencyAmounts get totalsByCurrency =>
      mergeCurrencyAmounts(fuelTotalsByCurrency, maintenanceTotalsByCurrency);

  bool get isEmpty => fuelByType.isEmpty && maintenanceByService.isEmpty;
}

class GroupedExpenseBreakdown {
  const GroupedExpenseBreakdown({required this.periods});

  final List<PeriodExpenseBreakdown> periods;

  CurrencyAmounts get totalsByCurrency {
    var totals = <String, double>{};
    for (final period in periods) {
      totals = mergeCurrencyAmounts(totals, period.totalsByCurrency);
    }
    return totals;
  }

  bool get isEmpty => periods.isEmpty;
}
