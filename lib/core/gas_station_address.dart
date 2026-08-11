import 'name_normalizer.dart';
import 'optional_string.dart';

/// Gas-station location address helpers shared by runtime ensure/update and
/// backup import so uniqueness stays aligned with the SQLite index
/// `(chain_id, lower(trim(coalesce(address,'')))) WHERE is_deleted = 0`.
abstract final class GasStationAddress {
  /// Empty / whitespace-only → null (bare location, no street).
  static String? normalize(String? address) => OptionalString.normalize(address);

  /// Case-insensitive equality after [normalize].
  static bool same(String? a, String? b) {
    final na = normalize(a);
    final nb = normalize(b);
    if (na == null && nb == null) return true;
    if (na == null || nb == null) return false;
    return NameNormalizer.normalize(na) == NameNormalizer.normalize(nb);
  }

  /// Row with matching [chainId] + normalized address, or null.
  ///
  /// When several rows share the same address (active + soft-deleted), prefers
  /// an active row; otherwise returns the first soft-deleted match.
  static T? findLocationIn<T>({
    required Iterable<T> rows,
    required int Function(T row) chainIdOf,
    required String? Function(T row) addressOf,
    required bool Function(T row) isDeletedOf,
    required int chainId,
    required String? address,
    int? excludeId,
    int Function(T row)? idOf,
  }) {
    final normalized = normalize(address);
    T? softDeletedMatch;
    for (final row in rows) {
      if (excludeId != null && idOf != null && idOf(row) == excludeId) {
        continue;
      }
      if (chainIdOf(row) != chainId) continue;
      if (!same(addressOf(row), normalized)) continue;
      if (!isDeletedOf(row)) return row;
      softDeletedMatch ??= row;
    }
    return softDeletedMatch;
  }
}
