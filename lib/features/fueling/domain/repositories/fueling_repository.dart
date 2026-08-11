import '../../../../shared/domain/money_totals.dart';
import '../entities/fueling.dart';
import '../entities/fueling_save.dart';

/// Persistence port for fuelings.
abstract class FuelingRepository {
  static const int pageSize = 50;

  Stream<void> watchFuelingsChanges();

  Future<List<FuelingListItem>> pageForCar(
    int carId, {
    DateTime? beforeFueledAt,
    int? beforeId,
    int limit = pageSize,
  });

  Future<MonthCurrencyTotals> monthTotalsForCar(int carId);

  Future<FuelingRecord?> latestForCar(int carId);

  Future<FuelingSaveOutcome> create({
    required int carId,
    required int fuelTypeId,
    required DateTime fueledAt,
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    required String currencyCode,
    int? gasStationId,
    double? odometerKm,
  });

  Future<FuelingSaveOutcome> update({
    required int id,
    required int fuelTypeId,
    required DateTime fueledAt,
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    required String currencyCode,
    int? gasStationId,
    double? odometerKm,
  });

  Future<void> delete(int id);
}
