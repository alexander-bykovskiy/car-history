import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/domain/money_totals.dart';
import '../domain/dual_source_timeline.dart';

/// Cursor pagination over two independent newest-first event sources.
class DualSourcePagedController<A, B> extends ChangeNotifier {
  DualSourcePagedController({
    required this.pageSizeA,
    required this.pageSizeB,
    required this.loadPageA,
    required this.loadPageB,
    required this.loadMonthTotalsA,
    required this.loadMonthTotalsB,
    required this.watchChangesA,
    required this.watchChangesB,
    required this.dateOfA,
    required this.dateOfB,
    required this.idOfA,
    required this.idOfB,
    this.typeOrderA = 0,
    this.typeOrderB = 1,
  });

  final int pageSizeA;
  final int pageSizeB;
  final Future<List<A>> Function({DateTime? beforeAt, int? beforeId}) loadPageA;
  final Future<List<B>> Function({DateTime? beforeAt, int? beforeId}) loadPageB;
  final Future<MonthCurrencyTotals> Function() loadMonthTotalsA;
  final Future<MonthCurrencyTotals> Function() loadMonthTotalsB;
  final Stream<void> Function() watchChangesA;
  final Stream<void> Function() watchChangesB;
  final DateTime Function(A item) dateOfA;
  final DateTime Function(B item) dateOfB;
  final int Function(A item) idOfA;
  final int Function(B item) idOfB;
  final int typeOrderA;
  final int typeOrderB;

  final List<A> itemsA = [];
  final List<B> itemsB = [];
  MonthCurrencyTotals monthTotals = const {};

  StreamSubscription<void>? _subA;
  StreamSubscription<void>? _subB;
  bool initialLoading = true;
  bool loadingMore = false;
  bool hasMoreA = true;
  bool hasMoreB = true;
  Object? error;
  int _loadGeneration = 0;
  bool _started = false;

  bool get hasMore => hasMoreA || hasMoreB;

  bool get shouldLoadMoreOnScroll =>
      hasMore && !loadingMore && !initialLoading;

  List<DualSourceEvent<A, B>> get mergedEvents {
    final events = <DualSourceEvent<A, B>>[
      for (final item in itemsA) DualSourceEvent.a(item),
      for (final item in itemsB) DualSourceEvent.b(item),
    ];
    return sortTimelineNewestFirst(
      events: events,
      dateOf: (e) => e.map(
        a: dateOfA,
        b: dateOfB,
      ),
      typeOrder: (e) => e.map(
        a: (_) => typeOrderA,
        b: (_) => typeOrderB,
      ),
      idOf: (e) => e.map(a: idOfA, b: idOfB),
    );
  }

  List<DualSourceEvent<A, B>> get visibleEvents {
    final cutoff = dualSourceCutoff(
      sourceACutoff: pageCursorCutoff(
        hasMore: hasMoreA,
        items: itemsA,
        dateOf: dateOfA,
      ),
      sourceBCutoff: pageCursorCutoff(
        hasMore: hasMoreB,
        items: itemsB,
        dateOf: dateOfB,
      ),
    );
    return dualSourceVisibleEvents(
      mergedNewestFirst: mergedEvents,
      dateOf: (e) => e.map(a: dateOfA, b: dateOfB),
      cutoff: cutoff,
    );
  }

  void Function({required bool resetScroll})? onReloaded;
  VoidCallback? onLoadedMore;

  void start() {
    if (_started) return;
    _started = true;
    _subA = watchChangesA().listen((_) => reload(resetScroll: true));
    _subB = watchChangesB().listen((_) => reload(resetScroll: true));
    reload(resetScroll: true);
  }

  void restart() {
    _subA?.cancel();
    _subB?.cancel();
    _subA = watchChangesA().listen((_) => reload(resetScroll: true));
    _subB = watchChangesB().listen((_) => reload(resetScroll: true));
    reload(resetScroll: true);
  }

  @override
  void dispose() {
    _subA?.cancel();
    _subB?.cancel();
    super.dispose();
  }

  Future<void> reload({required bool resetScroll}) async {
    final generation = ++_loadGeneration;
    initialLoading = true;
    error = null;
    hasMoreA = true;
    hasMoreB = true;
    loadingMore = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        loadPageA(),
        loadPageB(),
        loadMonthTotalsA(),
        loadMonthTotalsB(),
      ]);
      if (generation != _loadGeneration) return;
      final pageA = results[0] as List<A>;
      final pageB = results[1] as List<B>;
      final totalsA = results[2] as MonthCurrencyTotals;
      final totalsB = results[3] as MonthCurrencyTotals;
      itemsA
        ..clear()
        ..addAll(pageA);
      itemsB
        ..clear()
        ..addAll(pageB);
      monthTotals = mergeMonthTotals(totalsA, totalsB);
      hasMoreA = pageA.length >= pageSizeA;
      hasMoreB = pageB.length >= pageSizeB;
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

  Future<void> loadMore() async {
    if (!hasMore || loadingMore) return;
    if (itemsA.isEmpty && itemsB.isEmpty && !hasMoreA && !hasMoreB) {
      return;
    }
    final generation = _loadGeneration;
    loadingMore = true;
    notifyListeners();

    try {
      final futures = <Future<Object>>[];
      final loadA = hasMoreA && itemsA.isNotEmpty;
      final loadB = hasMoreB && itemsB.isNotEmpty;
      final loadAInitial = hasMoreA && itemsA.isEmpty;
      final loadBInitial = hasMoreB && itemsB.isEmpty;

      if (loadA) {
        final last = itemsA.last;
        futures.add(
          loadPageA(beforeAt: dateOfA(last), beforeId: idOfA(last)),
        );
      } else if (loadAInitial) {
        futures.add(loadPageA());
      }

      if (loadB) {
        final last = itemsB.last;
        futures.add(
          loadPageB(beforeAt: dateOfB(last), beforeId: idOfB(last)),
        );
      } else if (loadBInitial) {
        futures.add(loadPageB());
      }

      if (futures.isEmpty) {
        if (generation != _loadGeneration) return;
        hasMoreA = false;
        hasMoreB = false;
        loadingMore = false;
        notifyListeners();
        return;
      }

      final pages = await Future.wait(futures);
      if (generation != _loadGeneration) return;

      var pageIndex = 0;
      if (loadA || loadAInitial) {
        final page = pages[pageIndex++] as List<A>;
        itemsA.addAll(page);
        hasMoreA = page.length >= pageSizeA;
      }
      if (loadB || loadBInitial) {
        final page = pages[pageIndex++] as List<B>;
        itemsB.addAll(page);
        hasMoreB = page.length >= pageSizeB;
      }
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
}

/// Tagged union for a dual-source timeline row.
sealed class DualSourceEvent<A, B> {
  const DualSourceEvent();

  const factory DualSourceEvent.a(A value) = DualSourceEventA;
  const factory DualSourceEvent.b(B value) = DualSourceEventB;

  R map<R>({
    required R Function(A value) a,
    required R Function(B value) b,
  });
}

final class DualSourceEventA<A, B> extends DualSourceEvent<A, B> {
  const DualSourceEventA(this.value);

  final A value;

  @override
  R map<R>({
    required R Function(A value) a,
    required R Function(B value) b,
  }) =>
      a(value);
}

final class DualSourceEventB<A, B> extends DualSourceEvent<A, B> {
  const DualSourceEventB(this.value);

  final B value;

  @override
  R map<R>({
    required R Function(A value) a,
    required R Function(B value) b,
  }) =>
      b(value);
}
