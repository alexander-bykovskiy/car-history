import 'package:flutter/foundation.dart';

import '../../../../core/units.dart';
import '../../../../shared/presentation/reminder_trigger_form.dart';
import '../../../../shared/presentation/reminder_trigger_session.dart';
import '../../domain/entities/reminder_draft.dart';

sealed class MaintenanceReminderFormOutcome {
  const MaintenanceReminderFormOutcome();

  const factory MaintenanceReminderFormOutcome.saved(ReminderDraft draft) =
      MaintenanceReminderFormSaved;
  const factory MaintenanceReminderFormOutcome.removed() =
      MaintenanceReminderFormRemoved;
  const factory MaintenanceReminderFormOutcome.fieldError() =
      MaintenanceReminderFormFieldError;
}

class MaintenanceReminderFormSaved extends MaintenanceReminderFormOutcome {
  const MaintenanceReminderFormSaved(this.draft);
  final ReminderDraft draft;
}

class MaintenanceReminderFormRemoved extends MaintenanceReminderFormOutcome {
  const MaintenanceReminderFormRemoved();
}

class MaintenanceReminderFormFieldError extends MaintenanceReminderFormOutcome {
  const MaintenanceReminderFormFieldError();
}

/// Session state for [MaintenanceReminderFormPage] (no title / car / completed).
class MaintenanceReminderFormNotifier extends ChangeNotifier {
  MaintenanceReminderFormNotifier({
    required this.distanceUnit,
    ReminderDraft? initial,
  })  : _initial = initial,
        _trigger = ReminderTriggerSession.fromExisting(
          isNew: initial == null,
          dueAt: initial?.dueAt,
          dueOdometerKm: initial?.dueOdometerKm,
        );

  final DistanceUnit distanceUnit;
  final ReminderDraft? _initial;
  final ReminderTriggerSession _trigger;

  DateTime? get dueAt => _trigger.dueAt;
  bool get useDate => _trigger.useDate;
  bool get useOdometer => _trigger.useOdometer;
  bool get isEditing => _initial != null;
  ReminderDraft? get initial => _initial;

  ReminderTriggerErrorCode? get triggerError => _trigger.triggerError;
  ReminderTriggerErrorCode? get odometerError => _trigger.odometerError;
  ReminderTriggerErrorCode? get remindBeforeDaysError =>
      _trigger.remindBeforeDaysError;
  ReminderTriggerErrorCode? get remindBeforeKmError =>
      _trigger.remindBeforeKmError;

  void setDueAt(DateTime? value) {
    _trigger.setDueAt(value);
    notifyListeners();
  }

  void setUseDate(bool value) {
    _trigger.setUseDate(value);
    notifyListeners();
  }

  void setUseOdometer(bool value) {
    _trigger.setUseOdometer(value);
    notifyListeners();
  }

  String formatNumber(double value) => _trigger.formatNumber(value);

  MaintenanceReminderFormOutcome submit({
    required String remindBeforeDaysText,
    required String odometerText,
    required String remindBeforeKmText,
  }) {
    _trigger.clearErrors();

    final prepared = _trigger.prepare(
      distanceUnit: distanceUnit,
      remindBeforeDaysText: remindBeforeDaysText,
      odometerText: odometerText,
      remindBeforeKmText: remindBeforeKmText,
    );
    if (!prepared.isValid) {
      _trigger.applyErrors(prepared.errors!);
      notifyListeners();
      return const MaintenanceReminderFormOutcome.fieldError();
    }
    final trigger = prepared.values!;

    return MaintenanceReminderFormOutcome.saved(
      ReminderDraft(
        reminderId: _initial?.reminderId,
        dueAt: trigger.dueAt,
        dueOdometerKm: trigger.dueOdometerKm,
        remindBeforeDays: trigger.remindBeforeDays,
        remindBeforeKm: trigger.remindBeforeKm,
      ),
    );
  }

  MaintenanceReminderFormOutcome remove() =>
      const MaintenanceReminderFormOutcome.removed();
}
