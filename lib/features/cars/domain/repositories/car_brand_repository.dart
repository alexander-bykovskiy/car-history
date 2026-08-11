import '../entities/car_brand.dart';

abstract class CarBrandRepository {
  Stream<List<CarBrandItem>> watchAll();

  Future<List<CarBrandItem>> search(String query);

  Future<CarBrandItem?> findByName(String rawName);

  /// Returns existing brand or inserts a new one with the given name.
  Future<CarBrandItem> findOrCreate(String rawName);
}
