import '../../core/number_parsing.dart';
import '../../core/reminder_trigger_write_validation.dart';
import '../../core/units.dart';
import '../../l10n/app_localizations.dart';

/// How the user enters the odometer due value in the form.
enum ReminderOdometerInputMode {
  /// Absolute target reading (stored as-is after unit conversion).
  absolute,

  /// Distance to add to the car's current/baseline odometer.
  after,
}

/// Parsed reminder trigger fields after form validation.
class ReminderTriggerValues {
  const ReminderTriggerValues({
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
  });

  final DateTime? dueAt;
  final double? dueOdometerKm;
  final int? remindBeforeDays;
  final double? remindBeforeKm;
}

/// Typed field-level errors for reminder date/odometer/remind-before inputs.
enum ReminderTriggerErrorCode {
  dateRequired,
  remindBeforeInvalid,
  odometerRequired,
  odometerInvalid,
  odometerBaselineMissing,
  triggerRequired,
  carRequired,
}

/// Field-level errors for reminder date/odometer/remind-before inputs.
class ReminderTriggerFieldErrors {
  const ReminderTriggerFieldErrors({
    this.triggerError,
    this.odometerError,
    this.remindBeforeDaysError,
    this.remindBeforeKmError,
  });

  final ReminderTriggerErrorCode? triggerError;
  final ReminderTriggerErrorCode? odometerError;
  final ReminderTriggerErrorCode? remindBeforeDaysError;
  final ReminderTriggerErrorCode? remindBeforeKmError;

  bool get hasError =>
      triggerError != null ||
      odometerError != null ||
      remindBeforeDaysError != null ||
      remindBeforeKmError != null;
}

/// Maps [ReminderTriggerErrorCode] to localized copy (UI layer only).
String? reminderTriggerErrorText(
  AppLocalizations l10n,
  ReminderTriggerErrorCode? code,
) {
  return switch (code) {
    ReminderTriggerErrorCode.dateRequired => l10n.reminderDateRequired,
    ReminderTriggerErrorCode.remindBeforeInvalid =>
      l10n.reminderRemindBeforeInvalid,
    ReminderTriggerErrorCode.odometerRequired => l10n.reminderOdometerRequired,
    ReminderTriggerErrorCode.odometerInvalid => l10n.fuelingOdometerInvalid,
    ReminderTriggerErrorCode.odometerBaselineMissing =>
      l10n.reminderOdometerBaselineMissing,
    ReminderTriggerErrorCode.triggerRequired => l10n.reminderTriggerRequired,
    ReminderTriggerErrorCode.carRequired => l10n.reminderCarRequired,
    null => null,
  };
}

/// Outcome of [prepareReminderTrigger].
class ReminderTriggerPrepareResult {
  const ReminderTriggerPrepareResult.ok(this.values) : errors = null;

  const ReminderTriggerPrepareResult.invalid(this.errors) : values = null;

  final ReminderTriggerValues? values;
  final ReminderTriggerFieldErrors? errors;

  bool get isValid => values != null;
}

/// Parses reminder trigger fields, then closes domain rules via
/// [validateReminderTriggerWrite] (same source of truth as repo / backup).
ReminderTriggerPrepareResult prepareReminderTrigger({
  required DistanceUnit distanceUnit,
  required bool useDate,
  required bool useOdometer,
  required DateTime? dueAt,
  required String remindBeforeDaysText,
  required String odometerText,
  required String remindBeforeKmText,
  ReminderOdometerInputMode odometerInputMode =
      ReminderOdometerInputMode.absolute,
  double? baselineOdometerKm,
}) {
  DateTime? parsedDueAt;
  double? dueOdometerKm;
  int? remindBeforeDays;
  double? remindBeforeKm;

  if (useDate) {
    if (dueAt == null) {
      return const ReminderTriggerPrepareResult.invalid(
        ReminderTriggerFieldErrors(
          triggerError: ReminderTriggerErrorCode.dateRequired,
        ),
      );
    }
    parsedDueAt = dueAt;
    final days = _parseInt(remindBeforeDaysText);
    if (remindBeforeDaysText.trim().isNotEmpty && days == null) {
      return const ReminderTriggerPrepareResult.invalid(
        ReminderTriggerFieldErrors(
          remindBeforeDaysError: ReminderTriggerErrorCode.remindBeforeInvalid,
        ),
      );
    }
    remindBeforeDays = days;
  }

  if (useOdometer) {
    final raw = parseFlexibleDouble(odometerText);
    if (raw == null) {
      return const ReminderTriggerPrepareResult.invalid(
        ReminderTriggerFieldErrors(
          odometerError: ReminderTriggerErrorCode.odometerRequired,
        ),
      );
    }

    switch (odometerInputMode) {
      case ReminderOdometerInputMode.absolute:
        if (raw < 0) {
          return const ReminderTriggerPrepareResult.invalid(
            ReminderTriggerFieldErrors(
              odometerError: ReminderTriggerErrorCode.odometerInvalid,
            ),
          );
        }
        dueOdometerKm = distanceUnit.toKilometers(raw);
      case ReminderOdometerInputMode.after:
        if (raw <= 0) {
          return const ReminderTriggerPrepareResult.invalid(
            ReminderTriggerFieldErrors(
              odometerError: ReminderTriggerErrorCode.odometerInvalid,
            ),
          );
        }
        final baseline = baselineOdometerKm;
        if (baseline == null) {
          return const ReminderTriggerPrepareResult.invalid(
            ReminderTriggerFieldErrors(
              odometerError: ReminderTriggerErrorCode.odometerBaselineMissing,
            ),
          );
        }
        dueOdometerKm = baseline + distanceUnit.toKilometers(raw);
    }

    final beforeRaw = parseFlexibleDouble(remindBeforeKmText);
    if (remindBeforeKmText.trim().isNotEmpty && beforeRaw == null) {
      return const ReminderTriggerPrepareResult.invalid(
        ReminderTriggerFieldErrors(
          remindBeforeKmError: ReminderTriggerErrorCode.remindBeforeInvalid,
        ),
      );
    }
    if (beforeRaw != null) {
      remindBeforeKm = distanceUnit.toKilometers(beforeRaw);
    }
  }

  final domainError = validateReminderTriggerWrite(
    dueAt: parsedDueAt,
    dueOdometerKm: dueOdometerKm,
    remindBeforeDays: remindBeforeDays,
    remindBeforeKm: remindBeforeKm,
  );
  if (domainError != null) {
    return ReminderTriggerPrepareResult.invalid(
      switch (domainError) {
        ReminderTriggerWriteInvalid.emptyTrigger =>
          const ReminderTriggerFieldErrors(
            triggerError: ReminderTriggerErrorCode.triggerRequired,
          ),
        ReminderTriggerWriteInvalid.invalidRemindBefore =>
          const ReminderTriggerFieldErrors(
            remindBeforeDaysError: ReminderTriggerErrorCode.remindBeforeInvalid,
            remindBeforeKmError: ReminderTriggerErrorCode.remindBeforeInvalid,
          ),
        ReminderTriggerWriteInvalid.invalidOdometer =>
          const ReminderTriggerFieldErrors(
            odometerError: ReminderTriggerErrorCode.odometerInvalid,
          ),
      },
    );
  }

  return ReminderTriggerPrepareResult.ok(
    ReminderTriggerValues(
      dueAt: parsedDueAt,
      dueOdometerKm: dueOdometerKm,
      remindBeforeDays: remindBeforeDays,
      remindBeforeKm: remindBeforeKm,
    ),
  );
}

int? _parseInt(String raw) {
  final normalized = raw.trim();
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}
