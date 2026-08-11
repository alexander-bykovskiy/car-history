import '../domain/entities/named_catalog_item.dart';
import 'named_catalog_car_scope.dart';
import '../../../core/named_match.dart';
import 'named_catalog_write_helpers.dart';

/// Shared query + write surface for soft-deletable named catalogs with a car
/// junction (parts, fuel types). Table-specific Drift I/O is injected once.
class NamedCatalogCarScopedStore {
  NamedCatalogCarScopedStore._(
    this._carScope,
    this._findMatching,
    this._getById,
    this._insertNamed,
    this._writeName,
    this._markRestored,
    this._softDelete,
    this._hardDelete,
    this._hasReferences,
    this._watchAll,
    this._listAll,
  );

  final NamedCatalogCarScope _carScope;
  final Future<NamedCatalogItem?> Function(String rawName) _findMatching;
  final Future<NamedCatalogItem?> Function(int id) _getById;
  final Future<int> Function(String name) _insertNamed;
  final Future<void> Function(int id, String name) _writeName;
  final Future<void> Function(int id) _markRestored;
  final Future<void> Function(int id) _softDelete;
  final Future<void> Function(int id) _hardDelete;
  final Future<bool> Function(int id) _hasReferences;
  final Stream<List<NamedCatalogItem>> Function() _watchAll;
  final Future<List<NamedCatalogItem>> Function() _listAll;

  Stream<List<NamedCatalogItem>> watchAll() => _watchAll();

  Future<List<NamedCatalogItem>> listAll() => _listAll();

  Future<NamedCatalogItem?> getById(int id) => _getById(id);

  Future<List<NamedCatalogItem>> listForCar(int carId) =>
      _carScope.listForCar(carId);

  Future<List<int>> carIdsFor(int itemId) => _carScope.carIdsFor(itemId);

  Future<void> setCars(
    int itemId, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return _carScope.setCars(
      itemId,
      carIds: carIds,
      appliesToAll: appliesToAll,
    );
  }

  Future<List<NamedCatalogItem>> searchForCar(int carId, String query) =>
      _carScope.searchForCar(carId, query);

  Future<NamedCatalogSaveOutcome> ensureForCar(String rawName, int carId) {
    return ensureNamedCatalogForCar(
      rawName: rawName,
      carId: carId,
      findMatching: _findMatching,
      getById: _getById,
      carIdsFor: carIdsFor,
      setCars: setCars,
      restore: restore,
      create: create,
    );
  }

  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return createNamedCatalogCarScoped(
      rawName: rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
      findMatching: _findMatching,
      insertNamed: _insertNamed,
      setCars: setCars,
      getById: _getById,
    );
  }

  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return updateNamedCatalogCarScoped(
      current: current,
      rawName: rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
      findMatching: _findMatching,
      writeName: (name) => _writeName(current.id, name),
      setCars: setCars,
      getById: _getById,
    );
  }

  Future<void> restore(
    NamedCatalogItem item, {
    List<int>? carIds,
    bool appliesToAll = true,
  }) async {
    await _markRestored(item.id);
    if (carIds != null) {
      await setCars(
        item.id,
        carIds: carIds,
        appliesToAll: appliesToAll,
      );
    }
  }

  Future<void> delete(NamedCatalogItem item) {
    return softOrHardDeleteNamedCatalog(
      hasReferences: () => _hasReferences(item.id),
      softDelete: () => _softDelete(item.id),
      hardDelete: () => _hardDelete(item.id),
    );
  }
}

/// Maps a Drift (or other) named catalog row into the domain item.
NamedCatalogItem mapNamedCatalogItem({
  required int id,
  required String name,
  required bool isDeleted,
}) {
  return NamedCatalogItem(id: id, name: name, isDeleted: isDeleted);
}

/// Finds a matching row and maps it to [NamedCatalogItem].
Future<NamedCatalogItem?> findMappedNamedCatalogMatch<T>({
  required Future<List<T>> Function() loadAll,
  required String Function(T) nameOf,
  required bool Function(T) isDeletedOf,
  required NamedCatalogItem Function(T) map,
  required String rawName,
}) {
  return findNamedCatalogMatch(
    loadAll: loadAll,
    nameOf: nameOf,
    isDeletedOf: isDeletedOf,
    rawName: rawName,
  ).then((row) => row == null ? null : map(row));
}

/// Builds a [NamedCatalogCarScopedStore] from table-specific Drift I/O.
NamedCatalogCarScopedStore buildNamedCatalogCarScopedStore<TRow>({
  required Future<List<TRow>> Function() loadActiveOrderedRows,
  required Future<List<TRow>> Function() loadAllRowsOrdered,
  required Stream<List<TRow>> Function() watchAllRowsOrdered,
  required Future<TRow?> Function(int id) loadRowById,
  required Future<List<TRow>> Function() loadAllRowsForMatch,
  required NamedCatalogItem Function(TRow row) mapRow,
  required String Function(TRow row) nameOf,
  required Future<int> Function(String name) insertNamed,
  required Future<void> Function(int id, String name) writeName,
  required Future<void> Function(int id, bool isDeleted) setDeleted,
  required Future<void> Function(int id) hardDelete,
  required Future<List<({int itemId, int carId})>> Function() loadAllLinks,
  required Future<List<int>> Function(int itemId) loadCarIdsForItem,
  required Future<void> Function(int itemId) clearLinksForItem,
  required Future<void> Function(int itemId, List<int> carIds)
      insertLinksForItem,
  required Future<bool> Function(int id) hasReferences,
}) {
  Future<NamedCatalogItem?> getById(int id) async {
    final row = await loadRowById(id);
    return row == null ? null : mapRow(row);
  }

  return NamedCatalogCarScopedStore._(
    NamedCatalogCarScope(
      loadActiveOrdered: () async {
        final rows = await loadActiveOrderedRows();
        return rows.map(mapRow).toList();
      },
      loadAllLinks: loadAllLinks,
      loadCarIdsForItem: loadCarIdsForItem,
      clearLinksForItem: clearLinksForItem,
      insertLinksForItem: insertLinksForItem,
    ),
    (rawName) => findMappedNamedCatalogMatch(
      loadAll: loadAllRowsForMatch,
      nameOf: nameOf,
      isDeletedOf: (row) => mapRow(row).isDeleted,
      map: mapRow,
      rawName: rawName,
    ),
    getById,
    insertNamed,
    writeName,
    (id) => setDeleted(id, false),
    (id) => setDeleted(id, true),
    hardDelete,
    hasReferences,
    () => watchAllRowsOrdered().map(
          (rows) => rows.map(mapRow).toList(),
        ),
    () async {
      final rows = await loadAllRowsOrdered();
      return rows.map(mapRow).toList();
    },
  );
}
