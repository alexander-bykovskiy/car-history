/// Ensured catalog row id + display name.
///
/// Shared shape for feature ensurer ports (fueling / maintenance). Feature-specific
/// ensurer interfaces stay in each feature's `catalog_ports.dart`.
class EnsuredCatalogItem {
  const EnsuredCatalogItem({required this.id, required this.name});

  final int id;
  final String name;
}
