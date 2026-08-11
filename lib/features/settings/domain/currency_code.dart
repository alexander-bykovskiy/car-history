/// Currency code helpers (ISO-like 3-letter A–Z).
abstract final class CurrencyCode {
  static const defaultCode = 'EUR';

  /// Uppercases and validates a 3-letter A–Z code. Returns null if invalid.
  static String? normalize(String raw) {
    final code = raw.trim().toUpperCase();
    if (code.length != 3) return null;
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(code)) return null;
    return code;
  }
}
