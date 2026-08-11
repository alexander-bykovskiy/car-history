import 'entities/maintenance.dart';
import 'entities/maintenance_save.dart';

/// Domain write checks for maintenance totals, odometer, and part lines.
///
/// Shared by repository `_validate` and presentation `prepare*` after unit
/// conversion so numeric rules stay in one place.
MaintenanceSaveResult? validateMaintenanceWrite({
  double? totalAmount,
  double? odometerKm,
  List<MaintenancePartInput> parts = const [],
}) {
  if (totalAmount != null && totalAmount <= 0) {
    return MaintenanceSaveResult.invalidTotal;
  }
  if (odometerKm != null && odometerKm < 0) {
    return MaintenanceSaveResult.invalidOdometer;
  }
  for (final part in parts) {
    if (part.quantity <= 0) {
      return MaintenanceSaveResult.invalidPartQuantity;
    }
    if (part.amount != null && part.amount! <= 0) {
      return MaintenanceSaveResult.invalidPartAmount;
    }
  }
  return null;
}
