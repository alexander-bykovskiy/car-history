import '../entities/named_place.dart';
import '../repositories/service_center_repository.dart';

class SaveServiceCenterUseCase {
  SaveServiceCenterUseCase(this._repository);

  final ServiceCenterRepository _repository;

  Future<PlaceCatalogSaveOutcome> create({
    required String rawName,
    String? address,
  }) =>
      _repository.create(rawName: rawName, address: address);

  Future<PlaceCatalogSaveOutcome> update(
    PlaceCatalogItem current, {
    required String rawName,
    String? address,
  }) =>
      _repository.update(current, rawName: rawName, address: address);
}

class RestoreServiceCenterUseCase {
  RestoreServiceCenterUseCase(this._repository);

  final ServiceCenterRepository _repository;

  Future<void> call(PlaceCatalogItem item, {String? address}) =>
      _repository.restore(item, address: address);
}

class DeleteServiceCenterUseCase {
  DeleteServiceCenterUseCase(this._repository);

  final ServiceCenterRepository _repository;

  Future<void> call(PlaceCatalogItem item) => _repository.delete(item);
}
