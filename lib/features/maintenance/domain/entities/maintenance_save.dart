import 'maintenance.dart';

enum MaintenanceSaveResult {
  created,
  updated,
  invalidTotal,
  invalidOdometer,
  invalidPartAmount,
  invalidPartQuantity,
}

class MaintenanceSaveOutcome {
  const MaintenanceSaveOutcome(this.result, {this.item});

  final MaintenanceSaveResult result;
  final MaintenanceRecord? item;
}
