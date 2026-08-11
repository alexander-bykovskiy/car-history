import 'catalog_save_result.dart';

export 'catalog_save_result.dart' show CatalogSaveResult;

/// Soft-deletable service catalog row with optional icon key.
class ServiceCatalogItem {
  const ServiceCatalogItem({
    required this.id,
    required this.name,
    required this.isDeleted,
    this.iconKey,
  });

  final int id;
  final String name;
  final bool isDeleted;
  final String? iconKey;
}

class ServiceCatalogSaveOutcome {
  const ServiceCatalogSaveOutcome(this.result, {this.item});

  final CatalogSaveResult result;
  final ServiceCatalogItem? item;
}
