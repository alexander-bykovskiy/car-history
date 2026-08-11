import '../../../shared/domain/money_totals.dart';
import '../domain/entities/statistics.dart';

/// SQL subquery: per-maintenance parts total (`quantity * amount`).
const kMaintenancePartsTotalSql = '''
SELECT maintenance_id,
       SUM(quantity * amount) AS parts_total
FROM maintenance_parts
WHERE amount IS NOT NULL
GROUP BY maintenance_id
''';

List<NamedExpense> sortedNamedExpenses(
  Map<(String name, String currency), double> source,
) {
  final byName = <String, CurrencyAmounts>{};
  for (final entry in source.entries) {
    if (entry.value <= 0) continue;
    final map = byName.putIfAbsent(entry.key.$1, () => <String, double>{});
    addCurrencyAmount(map, entry.key.$2, entry.value);
  }
  final items = [
    for (final entry in byName.entries)
      NamedExpense(name: entry.key, amountsByCurrency: entry.value),
  ]..sort((a, b) {
      final byAmount = b.sortAmount.compareTo(a.sortAmount);
      if (byAmount != 0) return byAmount;
      return a.name.compareTo(b.name);
    });
  return items;
}
