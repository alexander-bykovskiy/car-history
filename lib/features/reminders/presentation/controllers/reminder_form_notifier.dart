import 'package:flutter/foundation.dart';

import '../../../../core/units.dart';
import '../../../../shared/presentation/reminder_trigger_form.dart';
import '../../../../shared/presentation/reminder_trigger_session.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/reminder_write_usecases.dart';

enum ReminderFormTitleError { required }

sealed class ReminderFormSubmitOutcome {
  const ReminderFormSubmitOutcome();

  const factory ReminderFormSubmitOutcome.success() = ReminderFormSubmitSuccess;
  const factory ReminderFormSubmitOutcome.busy() = ReminderFormSubmitBusy;
  const factory ReminderFormSubmitOutcome.fieldError() =
      ReminderFormSubmitFieldError;
}

class ReminderFormSubmitSuccess extends ReminderFormSubmitOutcome {
  const ReminderFormSubmitSuccess();
}

class ReminderFormSubmitBusy extends ReminderFormSubmitOutcome {
  const ReminderFormSubmitBusy();
}

class ReminderFormSubmitFieldError extends ReminderFormSubmitOutcome {
  const ReminderFormSubmitFieldError();
}

/// Page-scoped reminder form session. No [WidgetRef] — page passes use cases.
class ReminderFormNotifier extends ChangeNotifier {
  ReminderFormNotifier({
    required this.existing,
    required this.distanceUnit,
    int? initialCarId,
  })  : _carId = existing?.carId ?? initialCarId,
        _isCompleted = existing?.isCompleted ?? false,
        _trigger = ReminderTriggerSession.fromExisting(
          isNew: existing == null,
          dueAt: existing?.dueAt,
          dueOdometerKm: existing?.dueOdometerKm,
        );

  final ReminderRecord? existing;
  final ReminderTriggerSession _trigger;

  DistanceUnit distanceUnit;
  int? _carId;
  bool _isCompleted;
  bool _saving = false;

  ReminderFormTitleError? titleError;

  DateTime? get dueAt => _trigger.dueAt;
  int? get carId => _carId;
  bool get isCompleted => _isCompleted;
  bool get saving => _saving;
  bool get useDate => _trigger.useDate;
  bool get useOdometer => _trigger.useOdometer;
  bool get isEditing => existing != null;

  ReminderTriggerErrorCode? get triggerError => _trigger.triggerError;
  ReminderTriggerErrorCode? get odometerError => _trigger.odometerError;
  ReminderTriggerErrorCode? get remindBeforeDaysError =>
      _trigger.remindBeforeDaysError;
  ReminderTriggerErrorCode? get remindBeforeKmError =>
      _trigger.remindBeforeKmError;

  void setDistanceUnit(DistanceUnit unit) {
    distanceUnit = unit;
    notifyListeners();
  }

  void setCarId(int? id) {
    _carId = id;
    notifyListeners();
  }

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

  void setCompleted(bool value) {
    _isCompleted = value;
    notifyListeners();
  }

  void clearErrors() {
    titleError = null;
    _trigger.clearErrors();
  }

  String formatNumber(double value) => _trigger.formatNumber(value);

  Future<ReminderFormSubmitOutcome> save({
    required String titleText,
    required String remindBeforeDaysText,
    required String odometerText,
    required String remindBeforeKmText,
    required SaveReminderUseCase saveUseCase,
  }) async {
    if (_saving) return const ReminderFormSubmitOutcome.busy();

    clearErrors();
    final title = titleText.trim();
    if (title.isEmpty) {
      titleError = ReminderFormTitleError.required;
      notifyListeners();
      return const ReminderFormSubmitOutcome.fieldError();
    }
    if (_carId == null) {
      _trigger.setTriggerError(ReminderTriggerErrorCode.carRequired);
      notifyListeners();
      return const ReminderFormSubmitOutcome.fieldError();
    }

    final prepared = _trigger.prepare(
      distanceUnit: distanceUnit,
      remindBeforeDaysText: remindBeforeDaysText,
      odometerText: odometerText,
      remindBeforeKmText: remindBeforeKmText,
    );
    if (!prepared.isValid) {
      _trigger.applyErrors(prepared.errors!);
      notifyListeners();
      return const ReminderFormSubmitOutcome.fieldError();
    }
    final trigger = prepared.values!;

    _saving = true;
    notifyListeners();

    final input = ReminderInput(
      carId: _carId!,
      title: title,
      dueAt: trigger.dueAt,
      dueOdometerKm: trigger.dueOdometerKm,
      remindBeforeDays: trigger.remindBeforeDays,
      remindBeforeKm: trigger.remindBeforeKm,
      isCompleted: _isCompleted,
    );

    try {
      final outcome = existing == null
          ? await saveUseCase.create(input)
          : await saveUseCase.update(existing!.id, input);

      switch (outcome.result) {
        case ReminderSaveResult.emptyTitle:
          titleError = ReminderFormTitleError.required;
          notifyListeners();
          return const ReminderFormSubmitOutcome.fieldError();
        case ReminderSaveResult.emptyTrigger:
          _trigger.setTriggerError(ReminderTriggerErrorCode.triggerRequired);
          notifyListeners();
          return const ReminderFormSubmitOutcome.fieldError();
        case ReminderSaveResult.invalidRemindBefore:
          _trigger.setRemindBeforeInvalid();
          notifyListeners();
          return const ReminderFormSubmitOutcome.fieldError();
        case ReminderSaveResult.invalidOdometer:
          _trigger.applyErrors(
            const ReminderTriggerFieldErrors(
              odometerError: ReminderTriggerErrorCode.odometerInvalid,
            ),
          );
          notifyListeners();
          return const ReminderFormSubmitOutcome.fieldError();
        case ReminderSaveResult.created:
        case ReminderSaveResult.updated:
          notifyListeners();
          return const ReminderFormSubmitOutcome.success();
      }
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<ReminderFormSubmitOutcome> delete(
    DeleteReminderUseCase deleteUseCase,
  ) async {
    final record = existing;
    if (record == null || _saving) {
      return const ReminderFormSubmitOutcome.busy();
    }
    _saving = true;
    notifyListeners();
    try {
      await deleteUseCase(record.id);
      return const ReminderFormSubmitOutcome.success();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
