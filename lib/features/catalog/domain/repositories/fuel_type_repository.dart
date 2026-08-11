import '../entities/named_catalog_item.dart';
import 'named_catalog_car_scoped_writes.dart';

abstract class FuelTypeRepository implements NamedCatalogCarScopedWrites {
  Stream<List<NamedCatalogItem>> watchAll();

  Future<List<NamedCatalogItem>> listAll();

  Future<List<NamedCatalogItem>> listForCar(int carId);

  Future<List<NamedCatalogItem>> searchForCar(int carId, String query);

  Future<List<int>> carIdsForFuelType(int fuelTypeId);

  Future<NamedCatalogItem?> getById(int id);
}
