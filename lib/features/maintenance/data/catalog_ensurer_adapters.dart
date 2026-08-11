import '../../catalog/domain/ensurer_outcome_mapping.dart';
import '../../catalog/domain/repositories/part_repository.dart';
import '../../catalog/domain/repositories/service_repository.dart';
import '../domain/repositories/catalog_ports.dart';

class ServiceEnsurerAdapter implements ServiceEnsurer {
  ServiceEnsurerAdapter(this._repository);

  final ServiceRepository _repository;

  @override
  Future<EnsuredCatalogItem?> ensure(String rawName) async {
    final outcome = await _repository.ensure(rawName);
    return ensuredCatalogItemFromSave(
      result: outcome.result,
      id: outcome.item?.id,
      name: outcome.item?.name,
    );
  }
}

class PartEnsurerAdapter implements PartEnsurer {
  PartEnsurerAdapter(this._repository);

  final PartRepository _repository;

  @override
  Future<EnsuredCatalogItem?> ensureForCar(String rawName, int carId) async {
    final outcome = await _repository.ensureForCar(rawName, carId);
    return ensuredCatalogItemFromSave(
      result: outcome.result,
      id: outcome.item?.id,
      name: outcome.item?.name,
    );
  }
}
