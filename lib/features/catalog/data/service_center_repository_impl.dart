import 'package:drift/drift.dart';

import '../../../core/optional_string.dart';
import '../../../shared/data/db/app_database.dart';
import '../domain/entities/named_place.dart';
import '../domain/repositories/service_center_repository.dart';
import 'named_catalog_simple_drift.dart';
import 'named_catalog_simple_store.dart';

class ServiceCenterRepositoryImpl implements ServiceCenterRepository {
  ServiceCenterRepositoryImpl(this._db)
      : _store = buildServiceCenterSimpleStore(_db);

  final AppDatabase _db;
  final NamedCatalogSimpleStore<PlaceCatalogItem> _store;

  @override
  Stream<List<PlaceCatalogItem>> watchAll() => _store.watchAll();

  /// Used by catalog tests / diagnostics; not on the domain port.
  Future<PlaceCatalogItem?> getById(int id) => _store.getById(id);

  @override
  Future<PlaceCatalogSaveOutcome> create({
    required String rawName,
    String? address,
  }) async {
    final normalizedAddress = OptionalString.normalize(address);
    final outcome = await _store.create(
      rawName,
      insertNamed: (name) async {
        final now = DateTime.now();
        return _db.into(_db.serviceCenters).insert(
              ServiceCentersCompanion.insert(
                name: name,
                address: Value(normalizedAddress),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      },
    );
    return PlaceCatalogSaveOutcome(
      outcome.result,
      item: outcome.item == null
          ? null
          : await _store.getById(outcome.item!.id),
    );
  }

  @override
  Future<PlaceCatalogSaveOutcome> update(
    PlaceCatalogItem current, {
    required String rawName,
    String? address,
  }) async {
    final normalizedAddress = OptionalString.normalize(address);
    final outcome = await _store.update(
      current,
      rawName,
      writeName: (name) async {
        await (_db.update(_db.serviceCenters)
              ..where((t) => t.id.equals(current.id)))
            .write(
          ServiceCentersCompanion(
            name: Value(name),
            address: Value(normalizedAddress),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
    );
    return PlaceCatalogSaveOutcome(
      outcome.result,
      item: outcome.item == null
          ? null
          : await _store.getById(outcome.item!.id),
    );
  }

  @override
  Future<void> restore(
    PlaceCatalogItem item, {
    String? address,
  }) {
    return _store.restore(
      item,
      markRestored: () async {
        final addressCompanion = address == null
            ? const Value<String?>.absent()
            : Value<String?>(OptionalString.normalize(address));
        await (_db.update(_db.serviceCenters)
              ..where((t) => t.id.equals(item.id)))
            .write(
          ServiceCentersCompanion(
            isDeleted: const Value(false),
            address: addressCompanion,
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
    );
  }

  @override
  Future<void> delete(PlaceCatalogItem item) => _store.delete(item);
}
