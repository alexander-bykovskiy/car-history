/// Catalog ensure ports used by [SaveFuelingUseCase].
library;

import '../../../../shared/domain/ensured_catalog_item.dart';

export '../../../../shared/domain/ensured_catalog_item.dart';

abstract class FuelTypeEnsurer {
  /// Returns null when [rawName] is empty / invalid.
  Future<EnsuredCatalogItem?> ensureForCar(String rawName, int carId);
}

abstract class GasStationEnsurer {
  /// Returns location id when ensure succeeds.
  /// Returns null when [rawName] is empty (optional field omitted).
  /// Returns null when [rawName] is non-empty but ensure fails — callers must
  /// treat that as [SaveFuelingFailure.gasStationEnsureFailed], not silent drop.
  ///
  /// Must run inside an outer [TransactionRunner] (e.g. [SaveFuelingUseCase]).
  Future<int?> ensureFromInput(String rawName);
}
