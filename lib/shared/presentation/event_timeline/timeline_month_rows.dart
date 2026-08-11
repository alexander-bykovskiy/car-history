import '../../domain/money_totals.dart';

sealed class TimelineListRow<T> {
  const TimelineListRow();
}

class TimelineMonthHeaderRow<T> extends TimelineListRow<T> {
  const TimelineMonthHeaderRow({
    required this.year,
    required this.month,
    required this.totalsByCurrency,
  });

  final int year;
  final int month;
  final CurrencyAmounts totalsByCurrency;
}

class TimelineEntryRow<T> extends TimelineListRow<T> {
  const TimelineEntryRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  final T entry;
  final bool isFirst;
  final bool isLast;
}

/// Groups paged timeline items under month headers with currency totals.
List<TimelineListRow<T>> buildMonthGroupedTimelineRows<T>({
  required List<T> items,
  required DateTime Function(T item) dateOf,
  required Map<(int, int), CurrencyAmounts> monthTotals,
  required bool hasMore,
}) {
  final rows = <TimelineListRow<T>>[];
  (int, int)? currentMonth;
  for (var i = 0; i < items.length; i++) {
    final entry = items[i];
    final at = dateOf(entry);
    final key = (at.year, at.month);
    if (currentMonth != key) {
      currentMonth = key;
      rows.add(
        TimelineMonthHeaderRow<T>(
          year: key.$1,
          month: key.$2,
          totalsByCurrency: monthTotals[key] ?? const {},
        ),
      );
    }
    rows.add(
      TimelineEntryRow<T>(
        entry: entry,
        // Month headers always precede entries, so the top rail line
        // must stay visible even for the first event in the list.
        isFirst: false,
        isLast: i == items.length - 1 && !hasMore,
      ),
    );
  }
  return rows;
}
