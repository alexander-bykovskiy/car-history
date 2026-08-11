import '../../../../shared/data/db/app_database.dart';
import '../../domain/entities/maintenance.dart';

MaintenanceRecord maintenanceRecordFromRow(Maintenance row) {
  return MaintenanceRecord(
    id: row.id,
    carId: row.carId,
    serviceId: row.serviceId,
    reminderId: row.reminderId,
    servicedAt: row.servicedAt,
    totalAmount: row.totalAmount,
    currencyCode: row.currencyCode,
    odometerKm: row.odometerKm,
  );
}

MaintenanceListItem maintenanceListItemFromJoin({
  required Maintenance maintenance,
  String? serviceName,
  String? serviceIconKey,
  double partsTotal = 0,
}) {
  return MaintenanceListItem(
    id: maintenance.id,
    carId: maintenance.carId,
    serviceId: maintenance.serviceId,
    reminderId: maintenance.reminderId,
    servicedAt: maintenance.servicedAt,
    totalAmount: maintenance.totalAmount,
    currencyCode: maintenance.currencyCode,
    odometerKm: maintenance.odometerKm,
    serviceName: serviceName,
    serviceIconKey: serviceIconKey,
    partsTotal: partsTotal,
  );
}
