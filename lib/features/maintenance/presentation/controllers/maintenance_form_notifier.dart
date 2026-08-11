import 'package:flutter/foundation.dart';

import '../../../../core/units.dart';
import '../../../../shared/domain/event_odometer_warning.dart';
import '../../../../shared/domain/odometer_repository.dart';
import '../../domain/entities/reminder_draft.dart';
import '../../domain/usecases/delete_maintenance.dart';
import '../../domain/usecases/save_maintenance.dart';
import '../models/draft_part_line.dart';
import '../models/maintenance_form_data.dart';
import 'maintenance_form_prepare.dart';
import 'maintenance_form_field_errors.dart';
import 'maintenance_form_loader.dart';
import 'maintenance_form_submit_outcome.dart';
import 'maintenance_parts_draft.dart';

export 'maintenance_form_submit_outcome.dart';

/// Page-scoped form session: drafts, field errors, save/delete orchestration.
///
/// [TextEditingController]s stay on the page; this notifier owns the rest and
/// notifies listeners so section widgets can rebuild.
/// Dependencies are passed from the page (no [WidgetRef]).
class MaintenanceFormNotifier extends ChangeNotifier {
  MaintenanceFormNotifier({
    required this.carId,
    required this.distanceUnit,
    required String currencyCode,
    required this.existing,
    required this.deleteId,
    required this.initialServiceName,
  })  : _currencyCode = existing?.currencyCode ?? currencyCode,
        _servicedAt = _initialDate(existing);

  final int carId;
  final DistanceUnit distanceUnit;
  final MaintenanceFormData? existing;
  final int? deleteId;
  final String? initialServiceName;

  DateTime _servicedAt;
  String _currencyCode;
  final MaintenanceFormFieldErrors _errors = MaintenanceFormFieldErrors();
  final MaintenancePartsDraft _partsDraft = MaintenancePartsDraft();
  bool _saving = false;
  ReminderDraft? _reminderDraft;
  int? _linkedReminderId;

  bool get isEditing => existing != null;
  DateTime get servicedAt => _servicedAt;
  String get currencyCode => _currencyCode;
  SaveMaintenanceFailure? get serviceError => _errors.serviceError;
  SaveMaintenanceFailure? get totalError => _errors.totalError;
  SaveMaintenanceFailure? get odometerError => _errors.odometerError;
  bool get saving => _saving;
  List<DraftPartLine> get parts => _partsDraft.parts;
  int get nextPartLocalId => _partsDraft.nextPartLocalId;
  ReminderDraft? get reminderDraft => _reminderDraft;
  int? get linkedReminderId => _linkedReminderId;

  double get partsTotal => _partsDraft.partsTotal;

  double laborTotal(String totalText) =>
      MaintenancePartsDraft.laborTotal(totalText);

  double grandTotal(String totalText) => MaintenancePartsDraft.grandTotal(
        partsTotal: partsTotal,
        totalText: totalText,
      );

  static DateTime _initialDate(MaintenanceFormData? existing) {
    if (existing != null) {
      return DateTime(
        existing.servicedAt.year,
        existing.servicedAt.month,
        existing.servicedAt.day,
      );
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setServicedAt(DateTime value) {
    _servicedAt = value;
    notifyListeners();
  }

  void setCurrencyCode(String code) {
    if (code == _currencyCode) return;
    _currencyCode = code;
    notifyListeners();
  }

  void clearServiceError() {
    if (_errors.serviceError == null) return;
    _errors.clearService();
    notifyListeners();
  }

  void clearTotalError() {
    if (_errors.totalError == null) return;
    _errors.clearTotal();
    notifyListeners();
  }

  void clearOdometerError() {
    if (_errors.odometerError == null) return;
    _errors.clearOdometer();
    notifyListeners();
  }

  void upsertPart(DraftPartLine line, {DraftPartLine? replacing}) {
    _partsDraft.upsert(line, replacing: replacing);
    notifyListeners();
  }

  void removePart(int localId) {
    _partsDraft.remove(localId);
    notifyListeners();
  }

  void setReminderDraft(ReminderDraft? draft) {
    _reminderDraft = draft;
    notifyListeners();
  }

  void clearReminderDraft() {
    if (_reminderDraft == null) return;
    _reminderDraft = null;
    notifyListeners();
  }

  void applyHydration(MaintenanceFormHydration hydration) {
    _linkedReminderId = hydration.reminderDraft?.reminderId;
    _reminderDraft = hydration.reminderDraft;
    _partsDraft.hydrateFromSeeds(hydration.parts);
    notifyListeners();
  }

  /// Validates and saves. Returns a UI outcome; odometer confirm is requested
  /// via [confirmOdometer] before the write.
  Future<MaintenanceFormSubmitOutcome> submit({
    required SaveMaintenanceUseCase save,
    required OdometerRepository odometer,
    required String serviceName,
    required String totalText,
    required String odometerText,
    required Future<bool> Function(EventOdometerWarning details)
        confirmOdometer,
  }) async {
    if (_saving) return const MaintenanceFormSubmitOutcome.busy();

    final prepared = prepareMaintenanceSave(
      carId: carId,
      serviceName: serviceName,
      servicedAt: _servicedAt,
      totalText: totalText,
      odometerText: odometerText,
      currencyCode: _currencyCode,
      distanceUnit: distanceUnit,
      parts: _partsDraft.parts,
      reminderDraft: _reminderDraft,
      linkedReminderId: _linkedReminderId,
      existingId: existing?.id,
    );

    if (!prepared.isReady) {
      final failure = prepared.error!;
      if (isMaintenanceFormFieldFailure(failure)) {
        _errors.apply(failure);
        notifyListeners();
        return MaintenanceFormSubmitOutcome.fieldError(failure);
      }
      return MaintenanceFormSubmitOutcome.snack(failure);
    }

    final input = prepared.input!;
    final odometerKm = input.odometerKm;

    _errors.clearAll();
    _saving = true;
    notifyListeners();

    try {
      final proceed = await confirmEventOdometerIfNeeded(
        odometer: odometer,
        carId: carId,
        at: _servicedAt,
        odometerKm: odometerKm,
        confirmOdometer: confirmOdometer,
        editingSource:
            existing?.id == null ? null : OdometerEventSource.maintenance,
        excludingId: existing?.id,
      );
      if (!proceed) {
        return const MaintenanceFormSubmitOutcome.cancelled();
      }

      final result = await save(input);
      if (result.isSuccess) {
        return const MaintenanceFormSubmitOutcome.success();
      }

      final failure = result.failure;
      if (failure == null) {
        return const MaintenanceFormSubmitOutcome.cancelled();
      }
      if (isMaintenanceFormFieldFailure(failure)) {
        _errors.apply(failure);
        notifyListeners();
        return MaintenanceFormSubmitOutcome.fieldError(failure);
      }
      return MaintenanceFormSubmitOutcome.snack(failure);
    } catch (_) {
      return const MaintenanceFormSubmitOutcome.unexpected();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<MaintenanceFormSubmitOutcome> delete(
    DeleteMaintenanceUseCase deleteUseCase,
  ) async {
    final id = deleteId;
    if (id == null || _saving) {
      return const MaintenanceFormSubmitOutcome.cancelled();
    }

    _saving = true;
    notifyListeners();
    try {
      await deleteUseCase(id);
      return const MaintenanceFormSubmitOutcome.success();
    } catch (_) {
      return const MaintenanceFormSubmitOutcome.unexpected();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
