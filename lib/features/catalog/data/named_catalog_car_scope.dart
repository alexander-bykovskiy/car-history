import '../../../core/name_normalizer.dart';
import '../domain/entities/named_catalog_item.dart';

/// Shared car-scope logic for named catalog items with optional junction links.
///
/// Empty link set for an item ⇒ the item applies to every car.
class NamedCatalogCarScope {
  NamedCatalogCarScope({
    required this.loadActiveOrdered,
    required this.loadAllLinks,
    required this.loadCarIdsForItem,
    required this.clearLinksForItem,
    required this.insertLinksForItem,
  });

  final Future<List<NamedCatalogItem>> Function() loadActiveOrdered;
  final Future<List<({int itemId, int carId})>> Function() loadAllLinks;
  final Future<List<int>> Function(int itemId) loadCarIdsForItem;
  final Future<void> Function(int itemId) clearLinksForItem;
  final Future<void> Function(int itemId, List<int> carIds) insertLinksForItem;

  /// Active items available for [carId] (all-cars or explicitly linked).
  ///
  /// Two queries total — not N+1.
  Future<List<NamedCatalogItem>> listForCar(int carId) async {
    final active = await loadActiveOrdered();
    final links = await loadAllLinks();
    final byItem = <int, List<int>>{};
    for (final link in links) {
      byItem.putIfAbsent(link.itemId, () => []).add(link.carId);
    }

    return [
      for (final item in active)
        if (_availableForCar(byItem[item.id], carId)) item,
    ];
  }

  Future<List<int>> carIdsFor(int itemId) => loadCarIdsForItem(itemId);

  Future<void> setCars(
    int itemId, {
    required List<int> carIds,
    required bool appliesToAll,
  }) async {
    await clearLinksForItem(itemId);
    if (appliesToAll || carIds.isEmpty) return;
    await insertLinksForItem(itemId, carIds);
  }

  Future<List<NamedCatalogItem>> searchForCar(int carId, String query) async {
    return filterByNormalizedQuery(await listForCar(carId), query);
  }

  static bool _availableForCar(List<int>? links, int carId) {
    return links == null || links.isEmpty || links.contains(carId);
  }

  static List<NamedCatalogItem> filterByNormalizedQuery(
    List<NamedCatalogItem> items,
    String query,
  ) {
    final normalized = NameNormalizer.normalize(query);
    if (normalized.isEmpty) return items;
    return items
        .where(
          (row) => NameNormalizer.normalize(row.name).contains(normalized),
        )
        .toList();
  }

  static List<NamedCatalogItem> filterActiveByNormalizedQuery(
    List<NamedCatalogItem> activeItems,
    String query,
  ) {
    return filterByNormalizedQuery(activeItems, query);
  }
}
