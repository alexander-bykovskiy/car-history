import '../entities/named_catalog_item.dart';

/// Shared write surface for car-scoped named catalogs (fuel type, part).
abstract class NamedCatalogCarScopedWrites {
  /// Finds or creates by name and links to [carId] only when creating/restoring.
  Future<NamedCatalogSaveOutcome> ensureForCar(String rawName, int carId);

  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  });

  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  });

  Future<void> restore(
    NamedCatalogItem item, {
    List<int>? carIds,
    bool appliesToAll = true,
  });

  Future<void> delete(NamedCatalogItem item);
}
