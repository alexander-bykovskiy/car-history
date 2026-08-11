import '../entities/named_catalog_item.dart';
import 'named_catalog_car_scoped_writes.dart';

abstract class PartRepository implements NamedCatalogCarScopedWrites {
  Stream<List<NamedCatalogItem>> watchAll();

  Future<List<NamedCatalogItem>> listAll();

  /// Active parts available for [carId] (all-cars or explicitly linked).
  Future<List<NamedCatalogItem>> listForCar(int carId);

  /// Empty list means the part applies to every car.
  Future<List<int>> carIdsForPart(int partId);

  Future<NamedCatalogItem?> getById(int id);

  /// Active parts available for [carId], filtered by [query] (empty ⇒ all).
  Future<List<NamedCatalogItem>> searchForCar(int carId, String query);
}
