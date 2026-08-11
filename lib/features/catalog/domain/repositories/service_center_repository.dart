import '../entities/named_place.dart';

abstract class ServiceCenterRepository {
  Stream<List<PlaceCatalogItem>> watchAll();

  Future<PlaceCatalogSaveOutcome> create({
    required String rawName,
    String? address,
  });

  Future<PlaceCatalogSaveOutcome> update(
    PlaceCatalogItem current, {
    required String rawName,
    String? address,
  });

  Future<void> restore(
    PlaceCatalogItem item, {
    String? address,
  });

  Future<void> delete(PlaceCatalogItem item);
}
