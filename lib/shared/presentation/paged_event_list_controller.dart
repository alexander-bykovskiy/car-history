import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/money_totals.dart';

/// Shared cursor-pagination + month-totals session for event history lists.
class PagedEventListController<T> extends ChangeNotifier {
  PagedEventListController({
    required this.pageSize,
    required this.loadPage,
    required this.loadMonthTotals,
    required this.watchChanges,
    required this.dateOf,
    required this.idOf,
  });

  final int pageSize;
  final Future<List<T>> Function({DateTime? beforeAt, int? beforeId}) loadPage;
  final Future<MonthCurrencyTotals> Function() loadMonthTotals;
  final Stream<void> Function() watchChanges;
  final DateTime Function(T item) dateOf;
  final int Function(T item) idOf;

  final List<T> items = [];
  MonthCurrencyTotals monthTotals = const {};

  StreamSubscription<void>? _changesSub;
  bool initialLoading = true;
  bool loadingMore = false;
  bool hasMore = true;
  Object? error;
  int _loadGeneration = 0;
  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;
    _changesSub = watchChanges().listen((_) {
      reload(resetScroll: true);
    });
    reload(resetScroll: true);
  }

  void restart() {
    _changesSub?.cancel();
    _changesSub = watchChanges().listen((_) {
      reload(resetScroll: true);
    });
    reload(resetScroll: true);
  }

  @override
  void dispose() {
    _changesSub?.cancel();
    super.dispose();
  }

  Future<void> reload({required bool resetScroll}) async {
    final generation = ++_loadGeneration;
    initialLoading = true;
    error = null;
    hasMore = true;
    loadingMore = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        loadPage(),
        loadMonthTotals(),
      ]);
      if (generation != _loadGeneration) return;
      final page = results[0] as List<T>;
      final totals = results[1] as MonthCurrencyTotals;
      items
        ..clear()
        ..addAll(page);
      monthTotals = totals;
      hasMore = page.length >= pageSize;
      initialLoading = false;
      notifyListeners();
      onReloaded?.call(resetScroll: resetScroll);
    } catch (e) {
      if (generation != _loadGeneration) return;
      error = e;
      initialLoading = false;
      notifyListeners();
    }
  }

  /// Called after a successful [reload] so the host can jump scroll / fill viewport.
  void Function({required bool resetScroll})? onReloaded;

  /// Called after [loadMore] so the host can fill a short viewport.
  VoidCallback? onLoadedMore;

  Future<void> loadMore() async {
    if (!hasMore || loadingMore || items.isEmpty) return;
    final generation = _loadGeneration;
    loadingMore = true;
    notifyListeners();

    try {
      final last = items.last;
      final page = await loadPage(
        beforeAt: dateOf(last),
        beforeId: idOf(last),
      );
      if (generation != _loadGeneration) return;
      items.addAll(page);
      hasMore = page.length >= pageSize;
      loadingMore = false;
      notifyListeners();
      onLoadedMore?.call();
    } catch (e) {
      if (generation != _loadGeneration) return;
      error = e;
      loadingMore = false;
      notifyListeners();
    }
  }

  bool get shouldLoadMoreOnScroll =>
      hasMore && !loadingMore && !initialLoading;
}
