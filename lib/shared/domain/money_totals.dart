/// Amounts keyed by ISO-like currency code (e.g. EUR, RSD).
typedef CurrencyAmounts = Map<String, double>;

/// Month totals keyed by (year, month), then by currency code.
typedef MonthCurrencyTotals = Map<(int year, int month), CurrencyAmounts>;

CurrencyAmounts mergeCurrencyAmounts(CurrencyAmounts a, CurrencyAmounts b) {
  if (a.isEmpty) return Map<String, double>.from(b);
  if (b.isEmpty) return Map<String, double>.from(a);
  final merged = Map<String, double>.from(a);
  for (final entry in b.entries) {
    if (entry.value == 0) continue;
    merged[entry.key] = (merged[entry.key] ?? 0) + entry.value;
  }
  return merged;
}

MonthCurrencyTotals mergeMonthCurrencyTotals(
  MonthCurrencyTotals a,
  MonthCurrencyTotals b,
) {
  if (a.isEmpty) return Map<(int, int), CurrencyAmounts>.from(b);
  if (b.isEmpty) return Map<(int, int), CurrencyAmounts>.from(a);
  final merged = <(int, int), CurrencyAmounts>{
    for (final entry in a.entries)
      entry.key: Map<String, double>.from(entry.value),
  };
  for (final entry in b.entries) {
    merged[entry.key] = mergeCurrencyAmounts(
      merged[entry.key] ?? const {},
      entry.value,
    );
  }
  return merged;
}

void addCurrencyAmount(
  CurrencyAmounts target,
  String currencyCode,
  double amount,
) {
  if (amount == 0) return;
  target[currencyCode] = (target[currencyCode] ?? 0) + amount;
}

/// Non-zero amounts sorted by currency code for stable UI.
List<MapEntry<String, double>> sortedNonZeroCurrencyAmounts(
  CurrencyAmounts amounts,
) {
  final items = [
    for (final entry in amounts.entries)
      if (entry.value > 0) entry,
  ]..sort((a, b) => a.key.compareTo(b.key));
  return items;
}
