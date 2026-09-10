import '../../core/number_formatting.dart';
import '../../core/number_parsing.dart';
import '../../core/units.dart';
import '../domain/odometer_repository.dart';
import 'reminder_trigger_form.dart';

/// UI-only odometer baseline helpers for reminder forms.
///
/// Relative ("after N units") input is never persisted — only absolute
/// [dueOdometerKm] is stored after [prepareReminderTrigger].
abstract final class ReminderOdometerPrefill {
  /// Prefer [preferredDisplayText] (in [distanceUnit]), else max for [carId].
  static Future<double?> resolveBaselineKm({
    required OdometerRepository odometer,
    required int carId,
    DistanceUnit distanceUnit = DistanceUnit.kilometers,
    String? preferredDisplayText,
  }) async {
    final raw = preferredDisplayText?.trim();
    if (raw != null && raw.isNotEmpty) {
      final parsed = parseFlexibleDouble(raw);
      if (parsed != null) {
        return distanceUnit.toKilometers(parsed);
      }
    }
    return odometer.maxOdometerKm(carId);
  }

  /// Absolute-mode field text from [baselineKm] when the field is empty.
  static String? absoluteFieldText({
    required double? baselineKm,
    required ReminderOdometerInputMode mode,
    required DistanceUnit distanceUnit,
    required String currentText,
  }) {
    if (mode != ReminderOdometerInputMode.absolute) return null;
    if (currentText.trim().isNotEmpty) return null;
    if (baselineKm == null) return null;
    return formatFlexibleDouble(distanceUnit.fromKilometers(baselineKm));
  }
}
