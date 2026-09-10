import 'package:flutter/foundation.dart';

import '../../../../core/number_parsing.dart';
import '../../../catalog/domain/entities/named_catalog_item.dart';
import '../../../catalog/domain/repositories/part_unit_repository.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/maintenance_write_validation.dart';
import '../../domain/usecases/save_maintenance.dart';
import '../models/draft_part_line.dart';

class MaintenancePartPrepareResult {
  const MaintenancePartPrepareResult._({this.error, this.line});

  const MaintenancePartPrepareResult.error(SaveMaintenanceFailure error)
      : this._(error: error);

  const MaintenancePartPrepareResult.ready(DraftPartLine line)
      : this._(line: line);

  final SaveMaintenanceFailure? error;
  final DraftPartLine? line;

  bool get isReady => line != null;
}

/// Parses part form fields into a [DraftPartLine].
MaintenancePartPrepareResult prepareMaintenancePartLine({
  required String nameText,
  required String quantityText,
  required String amountText,
  required String commentText,
  required int localId,
  required int? unitId,
  required String? unitName,
}) {
  final name = nameText.trim();
  if (name.isEmpty) {
    return const MaintenancePartPrepareResult.error(
      SaveMaintenanceFailure.emptyPart,
    );
  }

  final quantityInput = parseFlexibleDouble(quantityText.trim());
  if (quantityInput == null) {
    return const MaintenancePartPrepareResult.error(
      SaveMaintenanceFailure.invalidPartQuantity,
    );
  }

  final amountRaw = amountText.trim();
  final amountInput =
      amountRaw.isEmpty ? null : parseFlexibleDouble(amountRaw);
  if (amountRaw.isNotEmpty && amountInput == null) {
    return const MaintenancePartPrepareResult.error(
      SaveMaintenanceFailure.invalidPartAmount,
    );
  }

  final writeError = validateMaintenanceWrite(
    parts: [
      MaintenancePartInput(
        partId: 0,
        quantity: quantityInput,
        amount: amountInput,
      ),
    ],
  );
  if (writeError != null) {
    final failure = mapMaintenanceSaveResultToFailure(writeError);
    if (failure != null) {
      return MaintenancePartPrepareResult.error(failure);
    }
  }

  final comment = commentText.trim();
  return MaintenancePartPrepareResult.ready(
    DraftPartLine(
      localId: localId,
      name: name,
      quantity: quantityInput,
      unitId: unitId,
      unitName: unitName,
      amount: amountInput,
      comment: comment.isEmpty ? null : comment,
    ),
  );
}

/// Units load + field errors for [MaintenancePartFormPage].
class MaintenancePartDialogNotifier extends ChangeNotifier {
  MaintenancePartDialogNotifier({
    required this.nextLocalId,
    this.existing,
  }) : _unitId = existing?.unitId;

  final int nextLocalId;
  final DraftPartLine? existing;

  List<NamedCatalogItem> _units = const [];
  int? _unitId;
  bool _unitsLoading = true;
  SaveMaintenanceFailure? _nameError;
  SaveMaintenanceFailure? _quantityError;
  SaveMaintenanceFailure? _amountError;

  List<NamedCatalogItem> get units => _units;
  int? get unitId => _unitId;
  bool get unitsLoading => _unitsLoading;
  SaveMaintenanceFailure? get nameError => _nameError;
  SaveMaintenanceFailure? get quantityError => _quantityError;
  SaveMaintenanceFailure? get amountError => _amountError;

  Future<void> loadUnits({
    required PartUnitRepository units,
    required Future<int?> Function() readLastUnitId,
  }) async {
    final loaded = await units.listActive();
    var selected = _unitId;
    if (selected != null && !loaded.any((unit) => unit.id == selected)) {
      selected = null;
    }
    if (selected == null && existing == null) {
      final lastId = await readLastUnitId();
      if (lastId != null && loaded.any((unit) => unit.id == lastId)) {
        selected = lastId;
      }
    }
    selected ??= loaded.isEmpty ? null : loaded.first.id;

    _units = loaded;
    _unitId = selected;
    _unitsLoading = false;
    notifyListeners();
  }

  void setUnitId(int? value) {
    if (_unitId == value) return;
    _unitId = value;
    notifyListeners();
  }

  void clearNameError() {
    if (_nameError == null) return;
    _nameError = null;
    notifyListeners();
  }

  void clearQuantityError() {
    if (_quantityError == null) return;
    _quantityError = null;
    notifyListeners();
  }

  void clearAmountError() {
    if (_amountError == null) return;
    _amountError = null;
    notifyListeners();
  }

  void _applyError(SaveMaintenanceFailure error) {
    _nameError = null;
    _quantityError = null;
    _amountError = null;
    switch (error) {
      case SaveMaintenanceFailure.emptyPart:
        _nameError = error;
      case SaveMaintenanceFailure.invalidPartQuantity:
        _quantityError = error;
      case SaveMaintenanceFailure.invalidPartAmount:
        _amountError = error;
      case SaveMaintenanceFailure.emptyService ||
            SaveMaintenanceFailure.invalidTotal ||
            SaveMaintenanceFailure.invalidOdometer ||
            SaveMaintenanceFailure.reminderSyncFailed:
        break;
    }
    notifyListeners();
  }

  /// Validates and optionally persists last unit. Returns the line or null.
  Future<DraftPartLine?> submit({
    required String nameText,
    required String quantityText,
    required String amountText,
    required String commentText,
    required Future<void> Function(int unitId) persistLastUnit,
  }) async {
    NamedCatalogItem? unit;
    for (final item in _units) {
      if (item.id == _unitId) {
        unit = item;
        break;
      }
    }

    final prepared = prepareMaintenancePartLine(
      nameText: nameText,
      quantityText: quantityText,
      amountText: amountText,
      commentText: commentText,
      localId: existing?.localId ?? nextLocalId,
      unitId: unit?.id,
      unitName: unit?.name,
    );

    if (!prepared.isReady) {
      _applyError(prepared.error!);
      return null;
    }

    final unitId = unit?.id;
    if (unitId != null) {
      await persistLastUnit(unitId);
    }
    return prepared.line;
  }
}
