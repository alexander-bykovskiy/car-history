import '../entities/service_catalog_item.dart';
import '../repositories/service_repository.dart';

class SaveServiceUseCase {
  SaveServiceUseCase(this._repository);

  final ServiceRepository _repository;

  Future<ServiceCatalogSaveOutcome> create(
    String rawName, {
    String? iconKey,
  }) =>
      _repository.create(rawName, iconKey: iconKey);

  Future<ServiceCatalogSaveOutcome> update(
    ServiceCatalogItem current,
    String rawName, {
    String? iconKey,
  }) =>
      _repository.update(current, rawName, iconKey: iconKey);
}

class RestoreServiceUseCase {
  RestoreServiceUseCase(this._repository);

  final ServiceRepository _repository;

  Future<void> call(
    ServiceCatalogItem item, {
    String? name,
    String? iconKey,
  }) =>
      _repository.restore(item, name: name, iconKey: iconKey);
}

class DeleteServiceUseCase {
  DeleteServiceUseCase(this._repository);

  final ServiceRepository _repository;

  Future<void> call(ServiceCatalogItem item) => _repository.delete(item);
}
