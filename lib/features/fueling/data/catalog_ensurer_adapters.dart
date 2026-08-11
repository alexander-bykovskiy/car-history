import '../../catalog/domain/ensurer_outcome_mapping.dart';
import '../../catalog/domain/repositories/fuel_type_repository.dart';
import '../../catalog/domain/repositories/gas_station_repository.dart';
import '../domain/repositories/catalog_ports.dart';

class FuelTypeEnsurerAdapter implements FuelTypeEnsurer {
  FuelTypeEnsurerAdapter(this._repository);

  final FuelTypeRepository _repository;

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

class GasStationEnsurerAdapter implements GasStationEnsurer {
  GasStationEnsurerAdapter(this._repository);

  final GasStationRepository _repository;

  @override
  Future<int?> ensureFromInput(String rawName) async {
    if (rawName.trim().isEmpty) return null;
    final outcome = await _repository.ensureFromInput(rawName);
    return outcome.location?.id;
  }
}
