import '../entities/named_catalog_item.dart';
import '../repositories/part_unit_repository.dart';

class SavePartUnitUseCase {
  SavePartUnitUseCase(this._repository);

  final PartUnitRepository _repository;

  Future<NamedCatalogSaveOutcome> create(String rawName) =>
      _repository.create(rawName);

  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName,
  ) =>
      _repository.update(current, rawName);
}

class RestorePartUnitUseCase {
  RestorePartUnitUseCase(this._repository);

  final PartUnitRepository _repository;

  Future<void> call(NamedCatalogItem item) => _repository.restore(item);
}

class DeletePartUnitUseCase {
  DeletePartUnitUseCase(this._repository);

  final PartUnitRepository _repository;

  Future<void> call(NamedCatalogItem item) => _repository.delete(item);
}
