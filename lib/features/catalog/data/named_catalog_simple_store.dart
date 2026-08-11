import '../domain/entities/named_catalog_item.dart';
import '../../../core/named_match.dart';
import 'named_catalog_write_helpers.dart';

/// Shared query + write surface for soft-deletable named catalogs without a
/// car junction (part units, services, service centers).
///
/// Table-specific Drift I/O and domain mapping are injected once. Extra fields
/// (iconKey, address) stay in insert/write/restore callbacks on the repository.
///
/// When [requireWriteOverrides] is true (service centers), [create] / [update] /
/// [restore] must pass field overrides — the name-only defaults throw so a
/// missing override cannot silently drop address (or similar) columns.
class NamedCatalogSimpleStore<T> {
  NamedCatalogSimpleStore._(
    this._asNamed,
    this._findMatching,
    this._getById,
    this._insertNamed,
    this._writeName,
    this._markRestored,
    this._softDelete,
    this._hardDelete,
    this._hasReferences,
    this._watchAll,
    this._listAll, {
    required this._requireWriteOverrides,
  });

  final NamedCatalogItem Function(T item) _asNamed;
  final Future<T?> Function(String rawName) _findMatching;
  final Future<T?> Function(int id) _getById;
  final Future<int> Function(String name) _insertNamed;
  final Future<void> Function(int id, String name) _writeName;
  final Future<void> Function(int id) _markRestored;
  final Future<void> Function(int id) _softDelete;
  final Future<void> Function(int id) _hardDelete;
  final Future<bool> Function(int id) _hasReferences;
  final Stream<List<T>> Function() _watchAll;
  final Future<List<T>> Function() _listAll;
  final bool _requireWriteOverrides;

  Stream<List<T>> watchAll() => _watchAll();

  Future<List<T>> listAll() => _listAll();

  Future<T?> getById(int id) => _getById(id);

  Future<T?> findMatching(String rawName) => _findMatching(rawName);

  Future<NamedCatalogItem?> _asNamedMatch(String rawName) async {
    final match = await _findMatching(rawName);
    return match == null ? null : _asNamed(match);
  }

  Future<NamedCatalogItem?> _asNamedById(int id) async {
    final item = await _getById(id);
    return item == null ? null : _asNamed(item);
  }

  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    Future<int> Function(String name)? insertNamed,
  }) {
    if (_requireWriteOverrides && insertNamed == null) {
      throw StateError(
        'NamedCatalogSimpleStore.create requires insertNamed when '
        'requireWriteOverrides is true',
      );
    }
    return createNamedCatalogSimple(
      rawName: rawName,
      findMatching: _asNamedMatch,
      insertNamed: insertNamed ?? _insertNamed,
      getById: _asNamedById,
    );
  }

  Future<NamedCatalogSaveOutcome> update(
    T current,
    String rawName, {
    Future<void> Function(String name)? writeName,
  }) {
    if (_requireWriteOverrides && writeName == null) {
      throw StateError(
        'NamedCatalogSimpleStore.update requires writeName when '
        'requireWriteOverrides is true',
      );
    }
    final named = _asNamed(current);
    return updateNamedCatalogSimple(
      current: named,
      rawName: rawName,
      findMatching: _asNamedMatch,
      writeName: writeName ?? ((name) => _writeName(named.id, name)),
      getById: _asNamedById,
    );
  }

  Future<NamedCatalogSaveOutcome> ensure(String rawName) {
    if (_requireWriteOverrides) {
      throw StateError(
        'NamedCatalogSimpleStore.ensure is unavailable when '
        'requireWriteOverrides is true',
      );
    }
    return ensureNamedCatalogSimple(
      rawName: rawName,
      findMatching: _asNamedMatch,
      getById: _asNamedById,
      restore: (item) => _markRestored(item.id),
      create: (name) => create(name),
    );
  }

  /// Soft-undelete. Pass [markRestored] when the row needs extra fields in the
  /// same write (iconKey, address, optional name) — same override style as
  /// [create]'s [insertNamed] / [update]'s [writeName].
  Future<void> restore(
    T item, {
    Future<void> Function()? markRestored,
  }) {
    if (_requireWriteOverrides && markRestored == null) {
      throw StateError(
        'NamedCatalogSimpleStore.restore requires markRestored when '
        'requireWriteOverrides is true',
      );
    }
    return (markRestored ?? () => _markRestored(_asNamed(item).id))();
  }

  Future<void> delete(T item) {
    final id = _asNamed(item).id;
    return softOrHardDeleteNamedCatalog(
      hasReferences: () => _hasReferences(id),
      softDelete: () => _softDelete(id),
      hardDelete: () => _hardDelete(id),
    );
  }
}

/// Builds a [NamedCatalogSimpleStore] from table-specific Drift I/O.
///
/// Set [requireWriteOverrides] for catalogs whose rows carry fields beyond
/// name (e.g. service-center address). Callers must then pass write overrides
/// on every create/update/restore.
NamedCatalogSimpleStore<T> buildNamedCatalogSimpleStore<T, TRow>({
  required Stream<List<TRow>> Function() watchAllRowsOrdered,
  required Future<List<TRow>> Function() listAllRowsOrdered,
  required Future<TRow?> Function(int id) loadRowById,
  required Future<List<TRow>> Function() loadAllRowsForMatch,
  required T Function(TRow row) mapRow,
  required NamedCatalogItem Function(T item) asNamed,
  required String Function(TRow row) nameOf,
  required bool Function(TRow row) isDeletedOf,
  required Future<int> Function(String name) insertNamed,
  required Future<void> Function(int id, String name) writeName,
  required Future<void> Function(int id, bool isDeleted) setDeleted,
  required Future<void> Function(int id) hardDelete,
  required Future<bool> Function(int id) hasReferences,
  bool requireWriteOverrides = false,
}) {
  Future<T?> getById(int id) async {
    final row = await loadRowById(id);
    return row == null ? null : mapRow(row);
  }

  return NamedCatalogSimpleStore._(
    asNamed,
    (rawName) => findNamedCatalogMatch(
      loadAll: loadAllRowsForMatch,
      nameOf: nameOf,
      isDeletedOf: isDeletedOf,
      rawName: rawName,
    ).then((row) => row == null ? null : mapRow(row)),
    getById,
    insertNamed,
    writeName,
    (id) => setDeleted(id, false),
    (id) => setDeleted(id, true),
    hardDelete,
    hasReferences,
    () => watchAllRowsOrdered().map((rows) => rows.map(mapRow).toList()),
    () async {
      final rows = await listAllRowsOrdered();
      return rows.map(mapRow).toList();
    },
    requireWriteOverrides: requireWriteOverrides,
  );
}
