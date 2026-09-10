import '../../core/number_formatting.dart';
import '../../core/units.dart';
import 'reminder_trigger_form.dart';

/// Shared mutable state for reminder date/odometer toggles and field errors.
///
/// Used by standalone reminder form and maintenance-embedded reminder draft.
class ReminderTriggerSession {
  ReminderTriggerSession({
    DateTime? dueAt,
    required bool useDate,
    required bool useOdometer,
    ReminderOdometerInputMode odometerInputMode =
        ReminderOdometerInputMode.absolute,
    double? baselineOdometerKm,
  }) : this._(
          dueAt,
          useDate,
          useOdometer,
          odometerInputMode,
          baselineOdometerKm,
        );

  ReminderTriggerSession._(
    this._dueAt,
    this._useDate,
    this._useOdometer,
    this._odometerInputMode,
    this._baselineOdometerKm,
  );

  /// Seeds toggles from an existing record/draft ([isNew] = creating fresh).
  factory ReminderTriggerSession.fromExisting({
    required bool isNew,
    DateTime? dueAt,
    double? dueOdometerKm,
  }) {
    return ReminderTriggerSession(
      dueAt: dueAt ?? (isNew ? DateTime.now() : null),
      useDate: isNew ? true : dueAt != null,
      useOdometer: dueOdometerKm != null,
      // New reminders default to "after N units" (UI-only); edits keep absolute.
      odometerInputMode: isNew
          ? ReminderOdometerInputMode.after
          : ReminderOdometerInputMode.absolute,
    );
  }

  DateTime? _dueAt;
  bool _useDate;
  bool _useOdometer;
  ReminderOdometerInputMode _odometerInputMode;
  double? _baselineOdometerKm;

  ReminderTriggerErrorCode? _triggerError;
  ReminderTriggerErrorCode? _odometerError;
  ReminderTriggerErrorCode? _remindBeforeDaysError;
  ReminderTriggerErrorCode? _remindBeforeKmError;

  DateTime? get dueAt => _dueAt;
  bool get useDate => _useDate;
  bool get useOdometer => _useOdometer;
  ReminderOdometerInputMode get odometerInputMode => _odometerInputMode;
  double? get baselineOdometerKm => _baselineOdometerKm;

  ReminderTriggerErrorCode? get triggerError => _triggerError;
  ReminderTriggerErrorCode? get odometerError => _odometerError;
  ReminderTriggerErrorCode? get remindBeforeDaysError => _remindBeforeDaysError;
  ReminderTriggerErrorCode? get remindBeforeKmError => _remindBeforeKmError;

  void setDueAt(DateTime? value) {
    _dueAt = value;
  }

  void setUseDate(bool value) {
    _useDate = value;
    if (!value) {
      _dueAt = null;
    } else {
      _dueAt ??= DateTime.now();
    }
  }

  void setUseOdometer(bool value) {
    _useOdometer = value;
  }

  void setOdometerInputMode(ReminderOdometerInputMode value) {
    _odometerInputMode = value;
  }

  void setBaselineOdometerKm(double? value) {
    _baselineOdometerKm = value;
  }

  void clearErrors() {
    _triggerError = null;
    _odometerError = null;
    _remindBeforeDaysError = null;
    _remindBeforeKmError = null;
  }

  void applyErrors(ReminderTriggerFieldErrors errors) {
    _triggerError = errors.triggerError;
    _odometerError = errors.odometerError;
    _remindBeforeDaysError = errors.remindBeforeDaysError;
    _remindBeforeKmError = errors.remindBeforeKmError;
  }

  void setTriggerError(ReminderTriggerErrorCode code) {
    _triggerError = code;
  }

  void setRemindBeforeInvalid() {
    _remindBeforeDaysError = ReminderTriggerErrorCode.remindBeforeInvalid;
    _remindBeforeKmError = ReminderTriggerErrorCode.remindBeforeInvalid;
  }

  String formatNumber(double value) => formatFlexibleDouble(value);

  ReminderTriggerPrepareResult prepare({
    required DistanceUnit distanceUnit,
    required String remindBeforeDaysText,
    required String odometerText,
    required String remindBeforeKmText,
  }) {
    return prepareReminderTrigger(
      distanceUnit: distanceUnit,
      useDate: _useDate,
      useOdometer: _useOdometer,
      dueAt: _dueAt,
      remindBeforeDaysText: remindBeforeDaysText,
      odometerText: odometerText,
      remindBeforeKmText: remindBeforeKmText,
      odometerInputMode: _odometerInputMode,
      baselineOdometerKm: _baselineOdometerKm,
    );
  }
}
