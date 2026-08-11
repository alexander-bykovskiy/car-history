import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

import '../../domain/money_totals.dart';

/// Shared date labels for event timeline lists.
String formatEventListDate(DateTime date, String locale) {
  final weekdayRaw = DateFormat('EEE', locale).format(date);
  final weekday = weekdayRaw.isEmpty
      ? weekdayRaw
      : '${weekdayRaw[0].toUpperCase()}${weekdayRaw.substring(1)}';
  final day = DateFormat('dd.MM.yyyy', locale).format(date);
  final withDot = weekday.endsWith('.') ? weekday : '$weekday.';
  return '$withDot $day';
}

String formatEventMonthTitle(int year, int month, String locale) {
  final raw = DateFormat.yMMMM(locale).format(DateTime(year, month));
  if (raw.isEmpty) return raw;
  return '${raw[0].toUpperCase()}${raw.substring(1)}';
}

/// Formats non-zero currency totals stacked vertically (one currency per line).
InlineSpan formatCurrencyAmountsSpan({
  required CurrencyAmounts amounts,
  required NumberFormat numberFormat,
  TextStyle? amountStyle,
  TextStyle? unitStyle,
  String separator = '\n',
}) {
  final entries = sortedNonZeroCurrencyAmounts(amounts);
  if (entries.isEmpty) {
    return TextSpan(text: numberFormat.format(0), style: amountStyle);
  }

  return TextSpan(
    children: [
      for (var i = 0; i < entries.length; i++) ...[
        if (i > 0) TextSpan(text: separator, style: amountStyle),
        TextSpan(
          text: numberFormat.format(entries[i].value),
          style: amountStyle,
        ),
        TextSpan(
          text: ' ${entries[i].key}',
          style: unitStyle,
        ),
      ],
    ],
  );
}
