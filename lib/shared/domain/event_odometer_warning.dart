import '../../core/odometer_sequence.dart';
import 'odometer_repository.dart';

/// Odometer-sequence check result for fueling / maintenance forms.
class EventOdometerWarning {
  const EventOdometerWarning({
    required this.warning,
    required this.neighbors,
  });

  final OdometerSequenceWarning warning;
  final OdometerNeighbors neighbors;
}

/// Shared odometer-sequence check for event forms.
///
/// Lives in `shared/domain` (not `core/`) because it depends on
/// [OdometerRepository]. Pure sequence math stays in `core/odometer_sequence.dart`.
Future<EventOdometerWarning?> eventOdometerWarning({
  required OdometerRepository odometer,
  required int carId,
  required DateTime at,
  required double odometerKm,
  OdometerEventSource? editingSource,
  int? excludingId,
}) async {
  final neighbors = await odometer.odometerNeighbors(
    carId: carId,
    at: at,
    editingSource: editingSource,
    excludingId: excludingId,
  );
  final warning = checkOdometerSequence(
    odometerKm: odometerKm,
    neighbors: neighbors,
  );
  if (!warning.hasWarning) return null;
  return EventOdometerWarning(warning: warning, neighbors: neighbors);
}

/// Runs [eventOdometerWarning] and asks [confirmOdometer] when needed.
///
/// Returns `false` if the user cancels; `true` when there is no warning or the
/// user confirms. Shared by fueling / maintenance form notifiers.
Future<bool> confirmEventOdometerIfNeeded({
  required OdometerRepository odometer,
  required int carId,
  required DateTime at,
  required double? odometerKm,
  required Future<bool> Function(EventOdometerWarning details) confirmOdometer,
  OdometerEventSource? editingSource,
  int? excludingId,
}) async {
  if (odometerKm == null) return true;
  final details = await eventOdometerWarning(
    odometer: odometer,
    carId: carId,
    at: at,
    odometerKm: odometerKm,
    editingSource: editingSource,
    excludingId: excludingId,
  );
  if (details == null) return true;
  return confirmOdometer(details);
}
