import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/money_totals.dart';
import '../../../../shared/presentation/event_timeline/event_list_formatting.dart';
import '../../domain/entities/statistics.dart';

class PeriodBreakdownCard extends StatelessWidget {
  const PeriodBreakdownCard({
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.period,
    required this.fuelLabel,
    required this.maintenanceLabel,
    required this.fuelColor,
    required this.maintenanceColor,
    required this.numberFormat,
    super.key,
  });

  final bool isFirst;
  final bool isLast;
  final String title;
  final PeriodExpenseBreakdown period;
  final String fuelLabel;
  final String maintenanceLabel;
  final Color fuelColor;
  final Color maintenanceColor;
  final NumberFormat numberFormat;

  static const double _iconSize = 36;
  static const double _lineWidth = 2;
  static const double _railWidth = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final onAccent = theme.colorScheme.onPrimary;
    final lineColor = accent.withValues(alpha: 0.35);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: onAccent,
    );
    final unitStyle = titleStyle?.copyWith(
      fontSize: (titleStyle.fontSize ?? 16) * 0.72,
      height: 1.0,
    );
    final hasDetails =
        period.fuelByType.isNotEmpty || period.maintenanceByService.isNotEmpty;
    final drawLineBelow = !isLast;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _railWidth,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: _lineWidth,
                            color: isFirst ? Colors.transparent : lineColor,
                          ),
                        ),
                      ),
                      Container(
                        width: _iconSize,
                        height: _iconSize,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: accent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.18),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: onAccent,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: _lineWidth,
                            color:
                                drawLineBelow ? lineColor : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, isFirst ? 4 : 10, 4, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(title, style: titleStyle),
                              ),
                              const SizedBox(width: 8),
                              Text.rich(
                                formatCurrencyAmountsSpan(
                                  amounts: period.totalsByCurrency,
                                  numberFormat: numberFormat,
                                  amountStyle: titleStyle,
                                  unitStyle: unitStyle,
                                ),
                                style: titleStyle,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasDetails)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: _railWidth,
                    child: Center(
                      child: Container(
                        width: _lineWidth,
                        color: drawLineBelow ? lineColor : Colors.transparent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (period.fuelByType.isNotEmpty)
                            StatsTypeGroup(
                              title: fuelLabel,
                              items: period.fuelByType,
                              totalsByCurrency: period.fuelTotalsByCurrency,
                              accent: fuelColor,
                              numberFormat: numberFormat,
                            ),
                          if (period.fuelByType.isNotEmpty &&
                              period.maintenanceByService.isNotEmpty)
                            const SizedBox(height: 10),
                          if (period.maintenanceByService.isNotEmpty)
                            StatsTypeGroup(
                              title: maintenanceLabel,
                              items: period.maintenanceByService,
                              totalsByCurrency:
                                  period.maintenanceTotalsByCurrency,
                              accent: maintenanceColor,
                              numberFormat: numberFormat,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class StatsTypeGroup extends StatelessWidget {
  const StatsTypeGroup({
    required this.title,
    required this.items,
    required this.totalsByCurrency,
    required this.accent,
    required this.numberFormat,
    super.key,
  });

  final String title;
  final List<NamedExpense> items;
  final CurrencyAmounts totalsByCurrency;
  final Color accent;
  final NumberFormat numberFormat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalUnitStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: (theme.textTheme.labelLarge?.fontSize ?? 14) * 0.85,
    );
    final itemAmountStyle = theme.textTheme.bodyMedium;
    final itemUnitStyle = itemAmountStyle?.copyWith(
      fontSize: (itemAmountStyle.fontSize ?? 14) * 0.85,
    );
    final dividerColor =
        theme.colorScheme.outlineVariant.withValues(alpha: 0.55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text.rich(
              formatCurrencyAmountsSpan(
                amounts: totalsByCurrency,
                numberFormat: numberFormat,
                amountStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unitStyle: totalUnitStyle,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        for (var i = 0; i < items.length; i++) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    items[i].name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Text.rich(
                  formatCurrencyAmountsSpan(
                    amounts: items[i].amountsByCurrency,
                    numberFormat: numberFormat,
                    amountStyle: itemAmountStyle,
                    unitStyle: itemUnitStyle,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 12,
            color: dividerColor,
          ),
        ],
      ],
    );
  }
}
