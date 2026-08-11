import 'name_normalizer.dart';

/// Sync scan for a row whose normalized name equals [rawName].
///
/// When several rows share the same normalized name (active + soft-deleted),
/// prefers an active row; otherwise returns the first soft-deleted match.
T? matchNamedCatalogRow<T>({
  required Iterable<T> rows,
  required String Function(T row) nameOf,
  required bool Function(T row) isDeletedOf,
  required String rawName,
}) {
  final normalized = NameNormalizer.normalize(rawName);
  if (normalized.isEmpty) return null;
  T? softDeletedMatch;
  for (final row in rows) {
    if (NameNormalizer.normalize(nameOf(row)) != normalized) continue;
    if (!isDeletedOf(row)) return row;
    softDeletedMatch ??= row;
  }
  return softDeletedMatch;
}

/// Finds a row whose normalized name equals [rawName] among [loadAll] results.
///
/// See [matchNamedCatalogRow] for active-over-soft-deleted preference.
Future<T?> findNamedCatalogMatch<T>({
  required Future<List<T>> Function() loadAll,
  required String Function(T row) nameOf,
  required bool Function(T row) isDeletedOf,
  required String rawName,
}) async {
  return matchNamedCatalogRow(
    rows: await loadAll(),
    nameOf: nameOf,
    isDeletedOf: isDeletedOf,
    rawName: rawName,
  );
}
