/// Empty / whitespace-only optional string → null.
///
/// Shared by gas-station addresses, service-center addresses, and other
/// nullable free-text columns that treat blank as absent.
abstract final class OptionalString {
  static String? normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
