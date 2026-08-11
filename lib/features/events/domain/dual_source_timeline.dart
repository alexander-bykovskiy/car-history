/// Pure helpers for dual-source (fueling + maintenance) timeline paging.
///
/// Lists are newest-first. Cutoff logic avoids showing older events from one
/// source while the other still has newer unread pages that would interleave.
library;

import '../../../shared/domain/money_totals.dart';

DateTime? dualSourceCutoff({
  required DateTime? sourceACutoff,
  required DateTime? sourceBCutoff,
}) {
  if (sourceACutoff != null && sourceBCutoff != null) {
    return sourceACutoff.isAfter(sourceBCutoff)
        ? sourceACutoff
        : sourceBCutoff;
  }
  return sourceACutoff ?? sourceBCutoff;
}

/// Keeps events on or after [cutoff] (inclusive). If [cutoff] is null, returns all.
List<T> dualSourceVisibleEvents<T>({
  required List<T> mergedNewestFirst,
  required DateTime Function(T event) dateOf,
  required DateTime? cutoff,
}) {
  if (cutoff == null) return List<T>.from(mergedNewestFirst);
  return [
    for (final event in mergedNewestFirst)
      if (!dateOf(event).isBefore(cutoff)) event,
  ];
}

/// Sort newest-first: date desc, then typeOrder asc, then id desc.
List<T> sortTimelineNewestFirst<T>({
  required List<T> events,
  required DateTime Function(T event) dateOf,
  required int Function(T event) typeOrder,
  required int Function(T event) idOf,
}) {
  final sorted = List<T>.from(events);
  sorted.sort((a, b) {
    final byDate = dateOf(b).compareTo(dateOf(a));
    if (byDate != 0) return byDate;
    final byType = typeOrder(a).compareTo(typeOrder(b));
    if (byType != 0) return byType;
    return idOf(b).compareTo(idOf(a));
  });
  return sorted;
}

Map<(int year, int month), CurrencyAmounts> mergeMonthTotals(
  Map<(int year, int month), CurrencyAmounts> a,
  Map<(int year, int month), CurrencyAmounts> b,
) {
  return mergeMonthCurrencyTotals(a, b);
}

/// Cutoff date for a source that still has more pages: last loaded item's date.
DateTime? pageCursorCutoff<T>({
  required bool hasMore,
  required List<T> items,
  required DateTime Function(T item) dateOf,
}) {
  if (!hasMore || items.isEmpty) return null;
  return dateOf(items.last);
}
