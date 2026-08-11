import '../../../shared/data/db/app_database.dart';
import '../../../shared/domain/money_totals.dart';
import '../domain/entities/maintenance.dart';
import '../domain/entities/maintenance_save.dart';
import '../domain/repositories/maintenance_repository.dart';
import 'maintenance_query_store.dart';
import 'maintenance_write_store.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl(AppDatabase db) : _query = MaintenanceQueryStore(db) {
    _write = MaintenanceWriteStore(db, _query);
  }

  final MaintenanceQueryStore _query;
  late final MaintenanceWriteStore _write;

  @override
  Stream<void> watchMaintenancesChanges() => _query.watchMaintenancesChanges();

  @override
  Future<List<MaintenanceListItem>> pageForCar(
    int carId, {
    DateTime? beforeServicedAt,
    int? beforeId,
    int limit = MaintenanceRepository.pageSize,
  }) =>
      _query.pageForCar(
        carId,
        beforeServicedAt: beforeServicedAt,
        beforeId: beforeId,
        limit: limit,
      );

  @override
  Future<MonthCurrencyTotals> monthTotalsForCar(int carId) =>
      _query.monthTotalsForCar(carId);

  @override
  Future<MaintenanceRecord?> latestForCar(int carId) =>
      _query.latestForCar(carId);

  @override
  Future<List<MaintenancePartLine>> partsForMaintenance(int maintenanceId) =>
      _query.partsForMaintenance(maintenanceId);

  @override
  Future<MaintenanceSaveOutcome> create({
    required int carId,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  }) =>
      _write.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: servicedAt,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        odometerKm: odometerKm,
        reminderId: reminderId,
        parts: parts,
      );

  @override
  Future<MaintenanceSaveOutcome> update({
    required int id,
    required int serviceId,
    required DateTime servicedAt,
    required String currencyCode,
    double? totalAmount,
    double? odometerKm,
    int? reminderId,
    List<MaintenancePartInput> parts = const [],
  }) =>
      _write.update(
        id: id,
        serviceId: serviceId,
        servicedAt: servicedAt,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        odometerKm: odometerKm,
        reminderId: reminderId,
        parts: parts,
      );

  @override
  Future<int?> delete(int id) => _write.delete(id);
}
