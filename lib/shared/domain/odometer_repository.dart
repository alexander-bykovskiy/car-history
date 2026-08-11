import '../../core/odometer_sequence.dart';

/// Which event table an odometer reading belongs to.
enum OdometerEventSource { fueling, maintenance }

/// Cross-feature odometer queries over fuelings ∪ maintenances.
abstract class OdometerRepository {
  /// Highest odometer across fuelings and maintenances for [carId].
  Future<double?> maxOdometerKm(
    int carId, {
    int? excludingFuelingId,
    int? excludingMaintenanceId,
  });

  /// Chronological neighbors around [at] on the combined event timeline.
  Future<OdometerNeighbors> odometerNeighbors({
    required int carId,
    required DateTime at,
    OdometerEventSource? editingSource,
    int? excludingId,
  });
}
