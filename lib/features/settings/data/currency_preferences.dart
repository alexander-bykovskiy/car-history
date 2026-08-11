import 'package:shared_preferences/shared_preferences.dart';

import '../domain/currency_code.dart';
import '../domain/repositories/currency_preferences_store.dart';

export '../domain/currency_code.dart';

class PrefsCurrencyPreferencesStore implements CurrencyPreferencesStore {
  static const _currencyKey = 'currency_code';
  static const _currencyCodesKey = 'currency_codes';

  @override
  Future<String> currencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    final raw = prefs.getString(_currencyKey);
    final normalized = CurrencyCode.normalize(raw ?? '');
    return normalized ?? CurrencyCode.defaultCode;
  }

  @override
  Future<List<String>> currencyCodes() async {
    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    return List<String>.from(prefs.getStringList(_currencyCodesKey) ?? const []);
  }

  @override
  Future<void> setCurrencyCode(String raw) async {
    final normalized = CurrencyCode.normalize(raw);
    if (normalized == null) return;
    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    final codes = List<String>.from(
      prefs.getStringList(_currencyCodesKey) ?? const <String>[],
    );
    if (!codes.contains(normalized)) {
      codes.add(normalized);
      await prefs.setStringList(_currencyCodesKey, codes);
    }
    await prefs.setString(_currencyKey, normalized);
  }

  @override
  Future<bool> addCurrencyCode(String raw) async {
    final normalized = CurrencyCode.normalize(raw);
    if (normalized == null) return false;
    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    final codes = List<String>.from(
      prefs.getStringList(_currencyCodesKey) ?? const <String>[],
    );
    if (codes.contains(normalized)) return false;
    codes.add(normalized);
    await prefs.setStringList(_currencyCodesKey, codes);
    if (codes.length == 1) {
      await prefs.setString(_currencyKey, normalized);
    }
    return true;
  }

  @override
  Future<bool> updateCurrencyCode(String from, String to) async {
    final fromNorm = CurrencyCode.normalize(from);
    final toNorm = CurrencyCode.normalize(to);
    if (fromNorm == null || toNorm == null) return false;
    if (fromNorm == toNorm) return true;

    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    final codes = List<String>.from(
      prefs.getStringList(_currencyCodesKey) ?? const <String>[],
    );
    final index = codes.indexOf(fromNorm);
    if (index < 0) return false;
    if (codes.contains(toNorm)) return false;

    codes[index] = toNorm;
    await prefs.setStringList(_currencyCodesKey, codes);

    final active = prefs.getString(_currencyKey);
    if (active == fromNorm) {
      await prefs.setString(_currencyKey, toNorm);
    }
    return true;
  }

  @override
  Future<bool> removeCurrencyCode(String raw) async {
    final normalized = CurrencyCode.normalize(raw);
    if (normalized == null) return false;
    final prefs = await SharedPreferences.getInstance();
    await _ensureCodesMigrated(prefs);
    final codes = List<String>.from(
      prefs.getStringList(_currencyCodesKey) ?? const <String>[],
    );
    if (!codes.contains(normalized)) return false;
    if (codes.length <= 1) return false;

    codes.remove(normalized);
    await prefs.setStringList(_currencyCodesKey, codes);

    final active = prefs.getString(_currencyKey);
    if (active == normalized) {
      await prefs.setString(_currencyKey, codes.first);
    }
    return true;
  }

  @override
  Future<void> setCurrencyCodes(List<String> rawCodes) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = <String>[];
    for (final raw in rawCodes) {
      final normalized = CurrencyCode.normalize(raw);
      if (normalized == null) continue;
      if (!codes.contains(normalized)) codes.add(normalized);
    }
    if (codes.isEmpty) codes.add(CurrencyCode.defaultCode);
    await prefs.setStringList(_currencyCodesKey, codes);

    final active = CurrencyCode.normalize(prefs.getString(_currencyKey) ?? '');
    if (active == null || !codes.contains(active)) {
      await prefs.setString(_currencyKey, codes.first);
    }
  }

  Future<void> _ensureCodesMigrated(SharedPreferences prefs) async {
    if (prefs.containsKey(_currencyCodesKey)) {
      final existing = prefs.getStringList(_currencyCodesKey);
      if (existing != null && existing.isNotEmpty) {
        final cleaned = <String>[];
        for (final raw in existing) {
          final normalized = CurrencyCode.normalize(raw);
          if (normalized != null && !cleaned.contains(normalized)) {
            cleaned.add(normalized);
          }
        }
        if (cleaned.isEmpty) cleaned.add(CurrencyCode.defaultCode);
        if (cleaned.length != existing.length ||
            !_sameOrder(cleaned, existing)) {
          await prefs.setStringList(_currencyCodesKey, cleaned);
        }
        final active =
            CurrencyCode.normalize(prefs.getString(_currencyKey) ?? '');
        if (active == null || !cleaned.contains(active)) {
          await prefs.setString(_currencyKey, cleaned.first);
        }
        return;
      }
    }

    final active = CurrencyCode.normalize(prefs.getString(_currencyKey) ?? '') ??
        CurrencyCode.defaultCode;
    await prefs.setStringList(_currencyCodesKey, [active]);
    await prefs.setString(_currencyKey, active);
  }

  static bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
