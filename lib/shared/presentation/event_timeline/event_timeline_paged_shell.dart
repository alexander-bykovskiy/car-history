import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../domain/money_totals.dart';
import 'event_list_formatting.dart';
import 'event_month_header_tile.dart';
import 'timeline_month_rows.dart';

/// Shared text styles for month headers and event tiles.
class EventTimelineStyles {
  EventTimelineStyles(ThemeData theme)
      : titleStyle = theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
        subtitleStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.0) {
    unitStyle = subtitleStyle?.copyWith(
      fontSize: (subtitleStyle?.fontSize ?? 14) * 0.72,
      height: 1.0,
    );
    trailingUnitStyle = titleStyle?.copyWith(
      fontSize: (titleStyle?.fontSize ?? 16) * 0.72,
      height: 1.0,
    );
    final monthOnAccent = theme.colorScheme.onPrimary;
    monthTitleStyle = titleStyle?.copyWith(color: monthOnAccent);
    monthTotalStyle = monthTitleStyle;
    monthUnitStyle = monthTotalStyle?.copyWith(
      fontSize: (monthTotalStyle?.fontSize ?? 16) * 0.72,
      height: 1.0,
    );
  }

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  late final TextStyle? unitStyle;
  late final TextStyle? trailingUnitStyle;
  late final TextStyle? monthTitleStyle;
  late final TextStyle? monthTotalStyle;
  late final TextStyle? monthUnitStyle;

  TextSpan numberSpan(String text, TextStyle? style) =>
      TextSpan(text: text, style: style);

  TextSpan unitSpan(String text, TextStyle? style) => TextSpan(
        text: text.toUpperCase(),
        style: style,
      );
}

typedef PagedEventEntryBuilder<T> = Widget Function(
  BuildContext context,
  TimelineEntryRow<T> row,
  EventTimelineStyles styles,
  NumberFormat numberFormat,
  String locale,
);

/// Shared paging surface for single- and dual-source event timelines.
class EventTimelinePager {
  EventTimelinePager({
    required this.listenable,
    required this.initialLoading,
    required this.loadingMore,
    required this.hasMore,
    required this.shouldLoadMoreOnScroll,
    required this.error,
    required this.loadMore,
    required this.setOnReloaded,
    required this.setOnLoadedMore,
  });

  final Listenable listenable;
  final bool Function() initialLoading;
  final bool Function() loadingMore;
  final bool Function() hasMore;
  final bool Function() shouldLoadMoreOnScroll;
  final Object? Function() error;
  final VoidCallback loadMore;
  final void Function(void Function({required bool resetScroll})? callback)
      setOnReloaded;
  final void Function(VoidCallback? callback) setOnLoadedMore;
}

/// Scroll threshold, viewport fill, and month-grouped ListView chrome.
///
/// Controllers stay outside; this shell only owns scroll + list presentation.
class EventTimelinePagedShell<T> extends StatefulWidget {
  const EventTimelinePagedShell({
    super.key,
    required this.pager,
    required this.items,
    required this.dateOf,
    required this.monthTotals,
    required this.entryBuilder,
    required this.emptyMessage,
    this.errorMessage,
  });

  final EventTimelinePager pager;
  /// Read on each rebuild so dual-source computed lists stay fresh.
  final List<T> Function() items;
  final DateTime Function(T item) dateOf;
  final MonthCurrencyTotals Function() monthTotals;
  final PagedEventEntryBuilder<T> entryBuilder;
  final String emptyMessage;
  final String Function(Object error)? errorMessage;

  @override
  State<EventTimelinePagedShell<T>> createState() =>
      _EventTimelinePagedShellState<T>();
}

class _EventTimelinePagedShellState<T>
    extends State<EventTimelinePagedShell<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bindPagerCallbacks();
    widget.pager.listenable.addListener(_onPagingChanged);
  }

  @override
  void didUpdateWidget(covariant EventTimelinePagedShell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pager.listenable != widget.pager.listenable) {
      oldWidget.pager.listenable.removeListener(_onPagingChanged);
      oldWidget.pager.setOnReloaded(null);
      oldWidget.pager.setOnLoadedMore(null);
      _bindPagerCallbacks();
      widget.pager.listenable.addListener(_onPagingChanged);
    }
  }

  void _bindPagerCallbacks() {
    widget.pager.setOnReloaded(({required resetScroll}) {
      if (!mounted) return;
      if (resetScroll && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _scheduleFillViewport();
    });
    widget.pager.setOnLoadedMore(_scheduleFillViewport);
  }

  void _onPagingChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.pager.listenable.removeListener(_onPagingChanged);
    widget.pager.setOnReloaded(null);
    widget.pager.setOnLoadedMore(null);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.pager.shouldLoadMoreOnScroll()) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      widget.pager.loadMore();
    }
  }

  void _scheduleFillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !widget.pager.hasMore() ||
          widget.pager.loadingMore() ||
          widget.pager.initialLoading()) {
        return;
      }
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.maxScrollExtent <= 0) {
        widget.pager.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items();
    final error = widget.pager.error();

    if (error != null && items.isEmpty && !widget.pager.initialLoading()) {
      final message = widget.errorMessage?.call(error) ??
          AppLocalizations.of(context).listLoadError;
      return Center(child: Text(message));
    }
    if (widget.pager.initialLoading() && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return Center(child: Text(widget.emptyMessage));
    }

    final locale = Localizations.localeOf(context).toString();
    final numberFormat = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = 2;
    final styles = EventTimelineStyles(Theme.of(context));
    final rows = buildMonthGroupedTimelineRows(
      items: items,
      dateOf: widget.dateOf,
      monthTotals: widget.monthTotals(),
      hasMore: widget.pager.hasMore(),
    );
    final showFooter = widget.pager.loadingMore();
    final itemCount = rows.length + (showFooter ? 1 : 0);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 88, top: 8),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= rows.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final row = rows[index];
          if (row is TimelineMonthHeaderRow<T>) {
            return EventMonthHeaderTile(
              isFirst: index == 0,
              title: formatEventMonthTitle(row.year, row.month, locale),
              total: formatCurrencyAmountsSpan(
                amounts: row.totalsByCurrency,
                numberFormat: numberFormat,
                amountStyle: styles.monthTotalStyle,
                unitStyle: styles.monthUnitStyle,
              ),
              titleStyle: styles.monthTitleStyle,
            );
          }

          return widget.entryBuilder(
            context,
            row as TimelineEntryRow<T>,
            styles,
            numberFormat,
            locale,
          );
        },
      ),
    );
  }
}
