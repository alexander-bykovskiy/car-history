import 'catalog_save_result.dart';

export 'catalog_save_result.dart'
    show CatalogSaveResult, SoftDeleteMatchKind, softDeleteMatchKind, catalogCreateConflictResult;

/// Soft-deletable named catalog row (fuel types, parts, …).
class NamedCatalogItem {
  const NamedCatalogItem({
    required this.id,
    required this.name,
    required this.isDeleted,
  });

  final int id;
  final String name;
  final bool isDeleted;
}

class NamedCatalogSaveOutcome {
  const NamedCatalogSaveOutcome(this.result, {this.item});

  final CatalogSaveResult result;
  final NamedCatalogItem? item;
}
