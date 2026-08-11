import '../entities/service_catalog_item.dart';

abstract class ServiceRepository {
  Stream<List<ServiceCatalogItem>> watchAll();

  Future<List<ServiceCatalogItem>> listAll();

  Future<ServiceCatalogItem?> getById(int id);

  Future<List<ServiceCatalogItem>> searchActive(String query);

  Future<ServiceCatalogSaveOutcome> ensure(String rawName);

  Future<ServiceCatalogSaveOutcome> create(
    String rawName, {
    String? iconKey,
  });

  Future<ServiceCatalogSaveOutcome> update(
    ServiceCatalogItem current,
    String rawName, {
    String? iconKey,
  });

  Future<void> restore(
    ServiceCatalogItem item, {
    String? name,
    String? iconKey,
  });

  Future<void> delete(ServiceCatalogItem item);
}
