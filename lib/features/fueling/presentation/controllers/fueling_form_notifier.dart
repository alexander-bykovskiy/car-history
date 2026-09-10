import 'package:flutter/widgets.dart';

import '../../../../core/report_caught_error.dart';
import '../../../../core/units.dart';
import '../../../../shared/domain/event_odometer_warning.dart';
import '../../../../shared/domain/odometer_repository.dart';
import '../../domain/usecases/delete_fueling.dart';
import '../../domain/usecases/save_fueling.dart';
import '../models/fueling_form_data.dart';
import 'fueling_amount_sync.dart';
import 'fueling_form_prepare.dart';
import 'fueling_form_field_errors.dart';
import 'fueling_form_submit_outcome.dart';

export 'fueling_form_submit_outcome.dart';

/// Page-scoped fueling form session (errors, dates, amount sync, save/delete).
///
/// [TextEditingController]s stay on the page; this notifier owns the rest.
/// Dependencies are passed from the page (no [WidgetRef]).
class FuelingFormNotifier extends ChangeNotifier {
  FuelingFormNotifier({
    required this.carId,
    required this.volumeUnit,
    required this.distanceUnit,
    required String currencyCode,
    required this.existing,
    required this.deleteId,
  })  : _currencyCode = existing?.currencyCode ?? currencyCode,
        _fueledAt = _initialDate(existing);

  final int carId;
  final FuelVolumeUnit volumeUnit;
  final DistanceUnit distanceUnit;
  final FuelingFormData? existing;
  final int? deleteId;

  DateTime _fueledAt;
  String _currencyCode;
  final FuelingAmountSync _amountSync = FuelingAmountSync();
  final FuelingFormFieldErrors _errors = FuelingFormFieldErrors();
  bool _saving = false;

  bool get isEditing => existing != null;
  DateTime get fueledAt => _fueledAt;
  String get currencyCode => _currencyCode;
  FuelingAmountField get lastEdited => _amountSync.lastEdited;
  SaveFuelingFailure? get fuelTypeError => _errors.fuelTypeError;
  SaveFuelingFailure? get gasStationError => _errors.gasStationError;
  SaveFuelingFailure? get priceError => _errors.priceError;
  SaveFuelingFailure? get amountError => _errors.amountError;
  SaveFuelingFailure? get odometerError => _errors.odometerError;
  bool get saving => _saving;

  static DateTime _initialDate(FuelingFormData? existing) {
    if (existing != null) {
      return DateTime(
        existing.fueledAt.year,
        existing.fueledAt.month,
        existing.fueledAt.day,
      );
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setFueledAt(DateTime value) {
    _fueledAt = value;
    notifyListeners();
  }

  void setCurrencyCode(String code) {
    if (code == _currencyCode) return;
    _currencyCode = code;
    notifyListeners();
  }

  void clearFuelTypeError() {
    if (_errors.fuelTypeError == null) return;
    _errors.clearFuelType();
    notifyListeners();
  }

  void clearGasStationError() {
    if (_errors.gasStationError == null) return;
    _errors.clearGasStation();
    notifyListeners();
  }

  void clearPriceError() {
    if (_errors.priceError == null) return;
    _errors.clearPrice();
    notifyListeners();
  }

  void clearAmountError() {
    if (_errors.amountError == null) return;
    _errors.clearAmount();
    notifyListeners();
  }

  void clearOdometerError() {
    if (_errors.odometerError == null) return;
    _errors.clearOdometer();
    notifyListeners();
  }

  void recalculate({
    required TextEditingController priceController,
    required TextEditingController quantityController,
    required TextEditingController totalController,
    FuelingAmountField? edited,
  }) {
    _amountSync.recalculate(
      priceController: priceController,
      quantityController: quantityController,
      totalController: totalController,
      edited: edited,
    );
  }

  Future<FuelingFormSubmitOutcome> submit({
    required SaveFuelingUseCase save,
    required OdometerRepository odometer,
    required String fuelTypeName,
    required String gasStationName,
    required String priceText,
    required String quantityText,
    required String totalText,
    required String odometerText,
    required TextEditingController quantityController,
    required TextEditingController totalController,
    required Future<bool> Function(EventOdometerWarning details)
        confirmOdometer,
  }) async {
    if (_saving) return const FuelingFormSubmitOutcome.busy();

    final prepared = prepareFuelingSave(
      carId: carId,
      fuelTypeName: fuelTypeName,
      gasStationName: gasStationName,
      fueledAt: _fueledAt,
      priceText: priceText,
      quantityText: quantityText,
      totalText: totalText,
      odometerText: odometerText,
      currencyCode: _currencyCode,
      volumeUnit: volumeUnit,
      distanceUnit: distanceUnit,
      lastEdited: _amountSync.lastEdited,
      existingId: existing?.id,
    );

    if (!prepared.isReady) {
      _errors.apply(prepared.error);
      notifyListeners();
      return FuelingFormSubmitOutcome.fieldError(prepared.error!);
    }

    _amountSync.writePrepared(
      quantityController: quantityController,
      totalController: totalController,
      quantity: prepared.quantity!,
      total: prepared.total!,
    );

    final input = prepared.input!;
    final odometerKm = input.odometerKm;

    _errors.clearAll();
    _saving = true;
    notifyListeners();

    try {
      final proceed = await confirmEventOdometerIfNeeded(
        odometer: odometer,
        carId: carId,
        at: _fueledAt,
        odometerKm: odometerKm,
        confirmOdometer: confirmOdometer,
        editingSource:
            existing?.id == null ? null : OdometerEventSource.fueling,
        excludingId: existing?.id,
      );
      if (!proceed) {
        return const FuelingFormSubmitOutcome.cancelled();
      }

      final result = await save(input);
      if (result.isSuccess) {
        return const FuelingFormSubmitOutcome.success();
      }

      final fieldError = result.failure;
      _errors.apply(fieldError);
      notifyListeners();
      if (fieldError != null) {
        return FuelingFormSubmitOutcome.fieldError(fieldError);
      }
      return const FuelingFormSubmitOutcome.cancelled();
    } catch (e, st) {
      reportCaughtError(e, st, context: 'FuelingFormNotifier.submit');
      return const FuelingFormSubmitOutcome.unexpected();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<FuelingFormSubmitOutcome> delete(
    DeleteFuelingUseCase deleteUseCase,
  ) async {
    final id = deleteId;
    if (id == null || _saving) {
      return const FuelingFormSubmitOutcome.cancelled();
    }
    _saving = true;
    notifyListeners();
    try {
      await deleteUseCase(id);
      return const FuelingFormSubmitOutcome.success();
    } catch (e, st) {
      reportCaughtError(e, st, context: 'FuelingFormNotifier.delete');
      return const FuelingFormSubmitOutcome.unexpected();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
