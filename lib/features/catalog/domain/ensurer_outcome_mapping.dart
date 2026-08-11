import '../../../shared/domain/ensured_catalog_item.dart';
import 'entities/catalog_save_result.dart';

/// Maps a catalog ensure/create outcome to the cross-feature ensurer DTO.
///
/// Shared by fueling / maintenance ensurer adapters so empty-name and missing
/// item cases stay aligned. Lives in catalog domain so sibling feature data
/// layers do not import `catalog/data`.
EnsuredCatalogItem? ensuredCatalogItemFromSave({
  required CatalogSaveResult result,
  required int? id,
  required String? name,
}) {
  if (id == null ||
      name == null ||
      result == CatalogSaveResult.emptyName) {
    return null;
  }
  return EnsuredCatalogItem(id: id, name: name);
}
