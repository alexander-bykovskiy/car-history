import 'package:drift/drift.dart';

import '../../../core/name_normalizer.dart';
import '../../../shared/data/db/app_database.dart';
import '../domain/entities/service_catalog_item.dart';
import '../domain/repositories/service_repository.dart';
import 'named_catalog_simple_drift.dart';
import 'named_catalog_simple_store.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl(this._db) : _store = buildServiceSimpleStore(_db);

  final AppDatabase _db;
  final NamedCatalogSimpleStore<ServiceCatalogItem> _store;

  @override
  Stream<List<ServiceCatalogItem>> watchAll() => _store.watchAll();

  @override
  Future<List<ServiceCatalogItem>> listAll() => _store.listAll();

  @override
  Future<ServiceCatalogItem?> getById(int id) => _store.getById(id);

  @override
  Future<List<ServiceCatalogItem>> searchActive(String query) async {
    final normalized = NameNormalizer.normalize(query);
    final rows = await _store.listAll();
    final active = rows.where((row) => !row.isDeleted);
    if (normalized.isEmpty) return active.toList();

    return active
        .where((row) => NameNormalizer.normalize(row.name).contains(normalized))
        .toList();
  }

  @override
  Future<ServiceCatalogSaveOutcome> ensure(String rawName) async {
    final outcome = await _store.ensure(rawName);
    return ServiceCatalogSaveOutcome(
      outcome.result,
      item: outcome.item == null ? null : await getById(outcome.item!.id),
    );
  }

  @override
  Future<ServiceCatalogSaveOutcome> create(
    String rawName, {
    String? iconKey,
  }) async {
    final outcome = await _store.create(
      rawName,
      insertNamed: (name) async {
        final now = DateTime.now();
        return _db.into(_db.services).insert(
              ServicesCompanion.insert(
                name: name,
                iconKey: Value(iconKey),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      },
    );
    return ServiceCatalogSaveOutcome(
      outcome.result,
      item: outcome.item == null ? null : await getById(outcome.item!.id),
    );
  }

  @override
  Future<ServiceCatalogSaveOutcome> update(
    ServiceCatalogItem current,
    String rawName, {
    String? iconKey,
  }) async {
    final outcome = await _store.update(
      current,
      rawName,
      writeName: (name) async {
        final now = DateTime.now();
        await (_db.update(_db.services)..where((t) => t.id.equals(current.id)))
            .write(
          ServicesCompanion(
            name: Value(name),
            iconKey: Value(iconKey),
            updatedAt: Value(now),
          ),
        );
      },
    );
    return ServiceCatalogSaveOutcome(
      outcome.result,
      item: outcome.item == null ? null : await getById(outcome.item!.id),
    );
  }

  @override
  Future<void> restore(
    ServiceCatalogItem item, {
    String? name,
    String? iconKey,
  }) {
    return _store.restore(
      item,
      markRestored: () async {
        final trimmedName = name?.trim();
        await (_db.update(_db.services)..where((t) => t.id.equals(item.id)))
            .write(
          ServicesCompanion(
            isDeleted: const Value(false),
            name: trimmedName == null || trimmedName.isEmpty
                ? const Value.absent()
                : Value(trimmedName),
            iconKey: iconKey == null ? const Value.absent() : Value(iconKey),
            updatedAt: Value(DateTime.now()),
          ),
        );
      },
    );
  }

  @override
  Future<void> delete(ServiceCatalogItem item) => _store.delete(item);
}
