import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_locale_option.dart';
import '../domain/repositories/locale_preferences_store.dart';

class PrefsLocalePreferencesStore implements LocalePreferencesStore {
  static const _key = 'app_language_code';

  @override
  Future<String?> languageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    return AppLocaleOption.isSupportedCode(raw) ? raw : null;
  }

  @override
  Future<void> setLanguageCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await prefs.remove(_key);
      return;
    }
    if (!AppLocaleOption.isSupportedCode(code)) return;
    await prefs.setString(_key, code);
  }
}
