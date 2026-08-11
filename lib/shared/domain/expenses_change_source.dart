/// Emits when expense-backed data that feeds statistics / odometer alerts
/// may have changed (fuelings + maintenances).
abstract class ExpensesChangeSource {
  Stream<void> watchExpensesChanged();
}
