/// Persisted UI language preference.
///
/// [null] means follow the device/system locale (Flutter default).
abstract class LocalePreferencesStore {
  /// BCP 47 language code (`en`, `ru`, `es`, `hy`) or null for system.
  Future<String?> languageCode();

  /// Pass null to clear the override and follow the system locale.
  Future<void> setLanguageCode(String? code);
}
