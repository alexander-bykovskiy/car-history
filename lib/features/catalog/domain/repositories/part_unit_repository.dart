import '../entities/named_catalog_item.dart';

abstract class PartUnitRepository {
  Stream<List<NamedCatalogItem>> watchAll();

  Future<List<NamedCatalogItem>> listActive();

  Future<NamedCatalogItem?> getById(int id);

  Future<NamedCatalogSaveOutcome> create(String rawName);

  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName,
  );

  Future<void> restore(NamedCatalogItem item);

  Future<void> delete(NamedCatalogItem item);
}
