/// Persisted default currency and user-managed currency list.
abstract class CurrencyPreferencesStore {
  Future<String> currencyCode();
  Future<List<String>> currencyCodes();
  Future<void> setCurrencyCode(String raw);
  Future<bool> addCurrencyCode(String raw);
  Future<bool> updateCurrencyCode(String from, String to);
  Future<bool> removeCurrencyCode(String raw);
  Future<void> setCurrencyCodes(List<String> rawCodes);
}