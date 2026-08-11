import '../../../../shared/domain/money_totals.dart';
import '../entities/maintenance.dart';
import '../entities/maintenance_save.dart';

abstract class MaintenanceRepository {
  static const int pageSize = 50;

  Stream<void> watchMaintenancesChanges();

  Future<List<MaintenanceListItem>> pageForCar(
    int carId, {
    DateTime? beforeServicedAt,
    int? beforeId,
    int limit = pageSize,
  });

  Future<MonthCurrencyTotals> monthTotalsForCar(int carId);

  Future<MaintenanceRecord?> latestForCar(int carId);

  Future<List<MaintenancePartLine>> partsForMaintenance(int maintenanceId);

  Future<MaintenanceSaveOutcome> create({
    required int carId,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  });

  Future<MaintenanceSaveOutcome> update({
    required int id,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  });

  /// Deletes the maintenance row. Returns the linked reminder id, if any.
  Future<int?> delete(int id);
}
