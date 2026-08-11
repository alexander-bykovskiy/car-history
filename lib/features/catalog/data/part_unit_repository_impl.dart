import '../../../shared/data/db/app_database.dart';
import '../domain/entities/named_catalog_item.dart';
import '../domain/repositories/part_unit_repository.dart';
import 'named_catalog_simple_drift.dart';
import 'named_catalog_simple_store.dart';

class PartUnitRepositoryImpl implements PartUnitRepository {
  PartUnitRepositoryImpl(AppDatabase db)
      : _store = buildPartUnitSimpleStore(db);

  final NamedCatalogSimpleStore<NamedCatalogItem> _store;

  @override
  Stream<List<NamedCatalogItem>> watchAll() => _store.watchAll();

  @override
  Future<List<NamedCatalogItem>> listActive() => _store.listAll();

  @override
  Future<NamedCatalogItem?> getById(int id) => _store.getById(id);

  @override
  Future<NamedCatalogSaveOutcome> create(String rawName) =>
      _store.create(rawName);

  @override
  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName,
  ) {
    return _store.update(current, rawName);
  }

  @override
  Future<void> restore(NamedCatalogItem item) => _store.restore(item);

  @override
  Future<void> delete(NamedCatalogItem item) => _store.delete(item);
}
