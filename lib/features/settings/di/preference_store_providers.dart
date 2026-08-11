import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/currency_preferences.dart';
import '../data/locale_preferences.dart';
import '../data/last_part_unit_preferences.dart';
import '../data/tip_preferences.dart';
import '../data/unit_preferences.dart';
import '../domain/repositories/currency_preferences_store.dart';
import '../domain/repositories/last_part_unit_store.dart';
import '../domain/repositories/locale_preferences_store.dart';
import '../domain/repositories/tip_preferences_store.dart';
import '../domain/repositories/unit_preferences_store.dart';

/// Prefs-backed store providers (defaults work before DB bootstrap).

final unitPreferencesStoreProvider =
    Provider<UnitPreferencesStore>((ref) => PrefsUnitPreferencesStore());

final currencyPreferencesStoreProvider =
    Provider<CurrencyPreferencesStore>(
        (ref) => PrefsCurrencyPreferencesStore());

final tipPreferencesStoreProvider =
    Provider<TipPreferencesStore>((ref) => PrefsTipPreferencesStore());

final lastPartUnitStoreProvider =
    Provider<LastPartUnitStore>((ref) => PrefsLastPartUnitStore());

final localePreferencesStoreProvider =
    Provider<LocalePreferencesStore>((ref) => PrefsLocalePreferencesStore());
