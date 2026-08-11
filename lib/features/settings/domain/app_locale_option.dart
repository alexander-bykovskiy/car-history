/// Fixed UI languages the app ships with (plus system = no override).
enum AppLocaleOption {
  system,
  en,
  ru,
  es,
  hy;

  /// Native endonym for the language picker (not localized).
  String get nativeLabel => switch (this) {
        AppLocaleOption.system => '',
        AppLocaleOption.en => 'English',
        AppLocaleOption.ru => 'Русский',
        AppLocaleOption.es => 'Español',
        AppLocaleOption.hy => 'Հայերեն',
      };

  String? get languageCode => switch (this) {
        AppLocaleOption.system => null,
        AppLocaleOption.en => 'en',
        AppLocaleOption.ru => 'ru',
        AppLocaleOption.es => 'es',
        AppLocaleOption.hy => 'hy',
      };

  static const supportedCodes = {'en', 'ru', 'es', 'hy'};

  static bool isSupportedCode(String code) => supportedCodes.contains(code);

  static AppLocaleOption fromStoredCode(String? code) {
    if (code == null || code.isEmpty) return AppLocaleOption.system;
    return switch (code) {
      'en' => AppLocaleOption.en,
      'ru' => AppLocaleOption.ru,
      'es' => AppLocaleOption.es,
      'hy' => AppLocaleOption.hy,
      _ => AppLocaleOption.system,
    };
  }
}
