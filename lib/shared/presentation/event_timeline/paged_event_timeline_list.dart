import 'package:flutter/material.dart';

import '../../domain/money_totals.dart';
import '../paged_event_list_controller.dart';
import 'event_timeline_paged_shell.dart';

export 'event_timeline_paged_shell.dart'
    show EventTimelineStyles, PagedEventEntryBuilder;
export 'timeline_month_rows.dart' show TimelineEntryRow;

/// Scrollable month-grouped timeline backed by [PagedEventListController].
class PagedEventTimelineList<T> extends StatefulWidget {
  const PagedEventTimelineList({
    super.key,
    required this.pageSize,
    required this.loadPage,
    required this.loadMonthTotals,
    required this.watchChanges,
    required this.dateOf,
    required this.idOf,
    required this.entryBuilder,
    required this.emptyMessage,
    this.errorMessage,
  });

  final int pageSize;
  final Future<List<T>> Function({DateTime? beforeAt, int? beforeId}) loadPage;
  final Future<MonthCurrencyTotals> Function() loadMonthTotals;
  final Stream<void> Function() watchChanges;
  final DateTime Function(T item) dateOf;
  final int Function(T item) idOf;
  final PagedEventEntryBuilder<T> entryBuilder;
  final String emptyMessage;
  final String Function(Object error)? errorMessage;

  @override
  State<PagedEventTimelineList<T>> createState() =>
      _PagedEventTimelineListState<T>();
}

class _PagedEventTimelineListState<T> extends State<PagedEventTimelineList<T>> {
  late PagedEventListController<T> _paging;
  late EventTimelinePager _pager;

  @override
  void initState() {
    super.initState();
    _paging = _createController()..start();
    _pager = _createPager(_paging);
  }

  PagedEventListController<T> _createController() {
    return PagedEventListController<T>(
      pageSize: widget.pageSize,
      loadPage: widget.loadPage,
      loadMonthTotals: widget.loadMonthTotals,
      watchChanges: widget.watchChanges,
      dateOf: widget.dateOf,
      idOf: widget.idOf,
    );
  }

  EventTimelinePager _createPager(PagedEventListController<T> paging) {
    return EventTimelinePager(
      listenable: paging,
      initialLoading: () => paging.initialLoading,
      loadingMore: () => paging.loadingMore,
      hasMore: () => paging.hasMore,
      shouldLoadMoreOnScroll: () => paging.shouldLoadMoreOnScroll,
      error: () => paging.error,
      loadMore: paging.loadMore,
      setOnReloaded: (callback) => paging.onReloaded = callback,
      setOnLoadedMore: (callback) => paging.onLoadedMore = callback,
    );
  }

  @override
  void dispose() {
    _paging.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventTimelinePagedShell<T>(
      pager: _pager,
      items: () => _paging.items,
      dateOf: widget.dateOf,
      monthTotals: () => _paging.monthTotals,
      entryBuilder: widget.entryBuilder,
      emptyMessage: widget.emptyMessage,
      errorMessage: widget.errorMessage,
    );
  }
}
