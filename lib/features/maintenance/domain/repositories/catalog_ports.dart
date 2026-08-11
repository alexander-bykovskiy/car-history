/// Catalog ensure ports used by [SaveMaintenanceUseCase].
library;

import '../../../../shared/domain/ensured_catalog_item.dart';

export '../../../../shared/domain/ensured_catalog_item.dart';

abstract class ServiceEnsurer {
  Future<EnsuredCatalogItem?> ensure(String rawName);
}

abstract class PartEnsurer {
  Future<EnsuredCatalogItem?> ensureForCar(String rawName, int carId);
}
