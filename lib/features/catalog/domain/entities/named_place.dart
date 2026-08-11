import 'catalog_save_result.dart';

export 'catalog_save_result.dart'
    show CatalogSaveResult, SoftDeleteMatchKind, softDeleteMatchKind, catalogCreateConflictResult;

/// Soft-deletable service-center row (name + optional address).
///
/// Gas-station chains/locations use [GasStationChainItem] /
/// [GasStationLocationItem] instead.
class PlaceCatalogItem {
  const PlaceCatalogItem({
    required this.id,
    required this.name,
    required this.isDeleted,
    this.address,
  });

  final int id;
  final String name;
  final bool isDeleted;
  final String? address;
}

class PlaceCatalogSaveOutcome {
  const PlaceCatalogSaveOutcome(this.result, {this.item});

  final CatalogSaveResult result;
  final PlaceCatalogItem? item;
}
