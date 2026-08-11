import '../../../shared/data/db/app_database.dart';
import '../domain/entities/named_catalog_item.dart';
import '../domain/repositories/fuel_type_repository.dart';
import 'named_catalog_car_scoped_drift.dart';
import 'named_catalog_car_scoped_store.dart';

class FuelTypeRepositoryImpl implements FuelTypeRepository {
  FuelTypeRepositoryImpl(AppDatabase db)
      : _store = buildFuelTypeCarScopedStore(db);

  final NamedCatalogCarScopedStore _store;

  @override
  Stream<List<NamedCatalogItem>> watchAll() => _store.watchAll();

  @override
  Future<List<NamedCatalogItem>> listAll() => _store.listAll();

  @override
  Future<List<NamedCatalogItem>> listForCar(int carId) =>
      _store.listForCar(carId);

  @override
  Future<List<int>> carIdsForFuelType(int fuelTypeId) =>
      _store.carIdsFor(fuelTypeId);

  @override
  Future<NamedCatalogItem?> getById(int id) => _store.getById(id);

  @override
  Future<List<NamedCatalogItem>> searchForCar(int carId, String query) =>
      _store.searchForCar(carId, query);

  @override
  Future<NamedCatalogSaveOutcome> ensureForCar(
    String rawName,
    int carId,
  ) =>
      _store.ensureForCar(rawName, carId);

  @override
  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return _store.create(
      rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
    );
  }

  @override
  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return _store.update(
      current,
      rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
    );
  }

  @override
  Future<void> restore(
    NamedCatalogItem item, {
    List<int>? carIds,
    bool appliesToAll = true,
  }) {
    return _store.restore(item, carIds: carIds, appliesToAll: appliesToAll);
  }

  @override
  Future<void> delete(NamedCatalogItem item) => _store.delete(item);
}
