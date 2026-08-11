import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/money_totals.dart';
import '../../domain/entities/statistics.dart';

class ExpensesBarChart extends StatelessWidget {
  const ExpensesBarChart({
    required this.buckets,
    required this.groupBy,
    required this.locale,
    required this.fuelColor,
    required this.maintenanceColor,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final List<ExpenseBucket> buckets;
  final StatsGroupBy groupBy;
  final String locale;
  final Color fuelColor;
  final Color maintenanceColor;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = buckets.fold<double>(
      0,
      (max, bucket) => math.max(max, bucket.maxCurrencyTotal),
    );
    final chartMaxY = maxY <= 0 ? 1.0 : maxY * 1.15;
    final monthFormat = DateFormat.MMM(locale);

    return BarChart(
      BarChartData(
        maxY: chartMaxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          handleBuiltInTouches: false,
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions) return;
            if (event is! FlTapUpEvent) return;
            final index = response?.spot?.touchedBarGroupIndex;
            if (index == null) return;
            onSelect(index);
          },
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Text(
                  _compactNumber(value),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= buckets.length) {
                  return const SizedBox.shrink();
                }
                final bucket = buckets[index];
                final label = bucket.month != null
                    ? monthFormat.format(DateTime(bucket.year, bucket.month!))
                    : '${bucket.year}';
                final selected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < buckets.length; i++)
            _barGroup(
              index: i,
              bucket: buckets[i],
              selected: selectedIndex == i,
              width: groupBy == StatsGroupBy.months ? 14 : 22,
            ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  BarChartGroupData _barGroup({
    required int index,
    required ExpenseBucket bucket,
    required bool selected,
    required double width,
  }) {
    final currencies = sortedNonZeroCurrencyAmounts(bucket.totalByCurrency)
        .map((e) => e.key)
        .toList();
    final dimmedFuel = fuelColor.withValues(alpha: selected ? 1 : 0.55);
    final dimmedMaintenance =
        maintenanceColor.withValues(alpha: selected ? 1 : 0.55);

    if (currencies.isEmpty) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 0,
            width: width,
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }

    final rodWidth = currencies.length == 1
        ? width
        : math.max(6.0, width / currencies.length);

    return BarChartGroupData(
      x: index,
      barsSpace: 2,
      barRods: [
        for (final code in currencies)
          _currencyRod(
            code: code,
            bucket: bucket,
            width: rodWidth,
            fuelColor: dimmedFuel,
            maintenanceColor: dimmedMaintenance,
          ),
      ],
    );
  }

  BarChartRodData _currencyRod({
    required String code,
    required ExpenseBucket bucket,
    required double width,
    required Color fuelColor,
    required Color maintenanceColor,
  }) {
    final fuel = bucket.fuelByCurrency[code] ?? 0;
    final maintenance = bucket.maintenanceByCurrency[code] ?? 0;
    final total = fuel + maintenance;
    return BarChartRodData(
      toY: total,
      width: width,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      rodStackItems: [
        if (fuel > 0) BarChartRodStackItem(0, fuel, fuelColor),
        if (maintenance > 0)
          BarChartRodStackItem(fuel, total, maintenanceColor),
      ],
      color: Colors.transparent,
    );
  }

  String _compactNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    }
    return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
  }
}
