import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/event_timeline/event_list_formatting.dart';
import '../widgets/period_header_bar.dart';
import '../../../../app/di/app_providers.dart';
import '../../../../app/navigation/car_header_bar.dart';
import '../../domain/entities/statistics.dart';
import '../controllers/statistics_body_controller.dart';
import '../widgets/expenses_bar_chart.dart';
import '../widgets/period_breakdown_card.dart';
import '../widgets/stats_legend_swatch.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CarHeaderBar(),
          Material(
            color: theme.colorScheme.surface.withValues(alpha: 0.5),
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.onSurface,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: [
                Tab(
                  icon: const Icon(Icons.calendar_month_outlined),
                  text: l10n.statsGroupByMonths,
                ),
                Tab(
                  icon: const Icon(Icons.calendar_today_outlined),
                  text: l10n.statsGroupByYears,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _StatisticsBody(groupBy: StatsGroupBy.months),
                _StatisticsBody(groupBy: StatsGroupBy.years),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsBody extends ConsumerStatefulWidget {
  const _StatisticsBody({required this.groupBy});

  final StatsGroupBy groupBy;

  @override
  ConsumerState<_StatisticsBody> createState() => _StatisticsBodyState();
}

class _StatisticsBodyState extends ConsumerState<_StatisticsBody> {
  late final StatisticsBodyController _controller;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final l10n = AppLocalizations.of(context);
    _controller = StatisticsBodyController(
      groupBy: widget.groupBy,
      unknownLabel: l10n.statsUnknownCategory,
    );
    ref.listenManual(selectedCarProvider, (previous, next) {
      _controller.bindCar(
        repository: ref.read(statisticsRepositoryProvider),
        changes: ref.read(expensesChangeSourceProvider),
        carId: next.value?.id,
      );
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    if (_started) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _capitalize(String raw) {
    if (raw.isEmpty) return raw;
    return '${raw[0].toUpperCase()}${raw.substring(1)}';
  }

  String _periodLabel(PeriodExpenseBreakdown period, String locale) {
    if (period.month == null) return '${period.year}';
    return _capitalize(
      DateFormat.yMMMM(locale).format(DateTime(period.year, period.month!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedAsync = ref.watch(selectedCarProvider);
    if (selectedAsync.isLoading && !selectedAsync.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final carId = selectedAsync.value?.id;

    if (carId == null) {
      return Center(child: Text(l10n.listEmpty));
    }

    if (!_started) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.loading && _controller.buckets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final locale = Localizations.localeOf(context).toString();
        final numberFormat = NumberFormat.decimalPattern(locale)
          ..minimumFractionDigits = 0
          ..maximumFractionDigits = 2;
        final theme = Theme.of(context);
        final fuelColor = theme.colorScheme.primary;
        final maintenanceColor = chartSeriesColor(fuelColor, tonesDarker: 3);
        final onAccent = theme.colorScheme.onPrimary;
        final periodTitleStyle = theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.0,
          color: onAccent,
        );
        final periodUnitStyle = periodTitleStyle?.copyWith(
          fontSize: (periodTitleStyle.fontSize ?? 16) * 0.72,
          height: 1.0,
        );
        final canNavigateYears = widget.groupBy == StatsGroupBy.months;

        return RefreshIndicator(
          onRefresh: () =>
              _controller.reload(ref.read(statisticsRepositoryProvider)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    StatsLegendSwatch(
                      color: fuelColor,
                      label: l10n.statsLegendFuel,
                    ),
                    StatsLegendSwatch(
                      color: maintenanceColor,
                      label: l10n.statsLegendMaintenance,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: ExpensesBarChart(
                  buckets: _controller.buckets,
                  groupBy: widget.groupBy,
                  locale: locale,
                  fuelColor: fuelColor,
                  maintenanceColor: maintenanceColor,
                  selectedIndex: _controller.selectedBucketIndex,
                  onSelect: (index) => _controller.onChartSelect(
                    ref.read(statisticsRepositoryProvider),
                    index,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PeriodHeaderBar(
                showCalendar: false,
                title: _controller.periodTitle,
                total: formatCurrencyAmountsSpan(
                  amounts: _controller.grouped.totalsByCurrency,
                  numberFormat: numberFormat,
                  amountStyle: periodTitleStyle,
                  unitStyle: periodUnitStyle,
                ),
                titleStyle: periodTitleStyle,
                onPrevious: canNavigateYears
                    ? () => _controller
                        .goPrevious(ref.read(statisticsRepositoryProvider))
                    : null,
                onNext: canNavigateYears
                    ? () => _controller
                        .goNext(ref.read(statisticsRepositoryProvider))
                    : null,
              ),
              const SizedBox(height: 16),
              if (_controller.grouped.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(l10n.statsEmpty)),
                )
              else
                for (var i = 0; i < _controller.grouped.periods.length; i++)
                  PeriodBreakdownCard(
                    isFirst: i == 0,
                    isLast: i == _controller.grouped.periods.length - 1,
                    title: _periodLabel(_controller.grouped.periods[i], locale),
                    period: _controller.grouped.periods[i],
                    fuelLabel: l10n.statsLegendFuel,
                    maintenanceLabel: l10n.statsLegendMaintenance,
                    fuelColor: fuelColor,
                    maintenanceColor: maintenanceColor,
                    numberFormat: numberFormat,
                  ),
            ],
          ),
        );
      },
    );
  }
}
