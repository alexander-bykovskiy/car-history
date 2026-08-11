import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/units.dart';
import '../domain/app_locale_option.dart';
import '../domain/currency_code.dart';
import 'preference_store_providers.dart';

export 'preference_store_providers.dart'
    show
        currencyPreferencesStoreProvider,
        lastPartUnitStoreProvider,
        localePreferencesStoreProvider,
        tipPreferencesStoreProvider,
        unitPreferencesStoreProvider;

// Prefer importing unit types from `core/units.dart` directly in feature code.

final fuelVolumeUnitProvider =
    AsyncNotifierProvider<FuelVolumeUnitNotifier, FuelVolumeUnit>(
  FuelVolumeUnitNotifier.new,
);

final distanceUnitProvider =
    AsyncNotifierProvider<DistanceUnitNotifier, DistanceUnit>(
  DistanceUnitNotifier.new,
);

final currencyCodeProvider =
    AsyncNotifierProvider<CurrencyCodeNotifier, String>(
  CurrencyCodeNotifier.new,
);

final currencyCodesProvider =
    AsyncNotifierProvider<CurrencyCodesNotifier, List<String>>(
  CurrencyCodesNotifier.new,
);

final showSwipeDeleteTipProvider =
    AsyncNotifierProvider<ShowSwipeDeleteTipNotifier, bool>(
  ShowSwipeDeleteTipNotifier.new,
);

final showDoubleTapEditTipProvider =
    AsyncNotifierProvider<ShowDoubleTapEditTipNotifier, bool>(
  ShowDoubleTapEditTipNotifier.new,
);

final lastPartUnitIdProvider =
    AsyncNotifierProvider<LastPartUnitIdNotifier, int?>(
  LastPartUnitIdNotifier.new,
);

final appLocalePreferenceProvider =
    AsyncNotifierProvider<AppLocalePreferenceNotifier, AppLocaleOption>(
  AppLocalePreferenceNotifier.new,
);

/// Re-reads SharedPreferences after an external write (e.g. backup import).
void invalidateAppPreferences(WidgetRef ref) {
  ref.invalidate(fuelVolumeUnitProvider);
  ref.invalidate(distanceUnitProvider);
  ref.invalidate(currencyCodeProvider);
  ref.invalidate(currencyCodesProvider);
  ref.invalidate(showSwipeDeleteTipProvider);
  ref.invalidate(showDoubleTapEditTipProvider);
  ref.invalidate(lastPartUnitIdProvider);
  ref.invalidate(appLocalePreferenceProvider);
}

class FuelVolumeUnitNotifier extends AsyncNotifier<FuelVolumeUnit> {
  @override
  Future<FuelVolumeUnit> build() =>
      ref.watch(unitPreferencesStoreProvider).fuelVolumeUnit();

  Future<void> set(FuelVolumeUnit unit) async {
    await ref.read(unitPreferencesStoreProvider).setFuelVolumeUnit(unit);
    state = AsyncData(unit);
  }
}

class DistanceUnitNotifier extends AsyncNotifier<DistanceUnit> {
  @override
  Future<DistanceUnit> build() =>
      ref.watch(unitPreferencesStoreProvider).distanceUnit();

  Future<void> set(DistanceUnit unit) async {
    await ref.read(unitPreferencesStoreProvider).setDistanceUnit(unit);
    state = AsyncData(unit);
  }
}

class CurrencyCodeNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() =>
      ref.watch(currencyPreferencesStoreProvider).currencyCode();

  Future<void> set(String raw) async {
    final normalized = CurrencyCode.normalize(raw);
    if (normalized == null) return;
    final store = ref.read(currencyPreferencesStoreProvider);
    await store.setCurrencyCode(normalized);
    state = AsyncData(normalized);
    // Keep list in sync without AsyncLoading flash.
    ref.read(currencyCodesProvider.notifier).replace(await store.currencyCodes());
  }
}

class CurrencyCodesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() =>
      ref.watch(currencyPreferencesStoreProvider).currencyCodes();

  void replace(List<String> codes) {
    state = AsyncData(List<String>.from(codes));
  }

  Future<bool> add(String raw) async {
    final store = ref.read(currencyPreferencesStoreProvider);
    final ok = await store.addCurrencyCode(raw);
    if (!ok) return false;
    state = AsyncData(await store.currencyCodes());
    ref.invalidate(currencyCodeProvider);
    return true;
  }

  Future<bool> rename(String from, String to) async {
    final store = ref.read(currencyPreferencesStoreProvider);
    final ok = await store.updateCurrencyCode(from, to);
    if (!ok) return false;
    state = AsyncData(await store.currencyCodes());
    ref.invalidate(currencyCodeProvider);
    return true;
  }

  Future<bool> remove(String raw) async {
    final store = ref.read(currencyPreferencesStoreProvider);
    final ok = await store.removeCurrencyCode(raw);
    if (!ok) return false;
    state = AsyncData(await store.currencyCodes());
    ref.invalidate(currencyCodeProvider);
    return true;
  }
}

class ShowSwipeDeleteTipNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.watch(tipPreferencesStoreProvider).shouldShowSwipeDeleteTip();

  Future<void> dismiss() async {
    await ref.read(tipPreferencesStoreProvider).hideSwipeDeleteTip();
    state = const AsyncData(false);
  }
}

class ShowDoubleTapEditTipNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.watch(tipPreferencesStoreProvider).shouldShowDoubleTapEditTip();

  Future<void> dismiss() async {
    await ref.read(tipPreferencesStoreProvider).hideDoubleTapEditTip();
    state = const AsyncData(false);
  }
}

class LastPartUnitIdNotifier extends AsyncNotifier<int?> {
  @override
  Future<int?> build() =>
      ref.watch(lastPartUnitStoreProvider).lastPartUnitId();

  Future<void> set(int id) async {
    await ref.read(lastPartUnitStoreProvider).setLastPartUnitId(id);
    state = AsyncData(id);
  }
}

class AppLocalePreferenceNotifier extends AsyncNotifier<AppLocaleOption> {
  @override
  Future<AppLocaleOption> build() async {
    final code = await ref.watch(localePreferencesStoreProvider).languageCode();
    return AppLocaleOption.fromStoredCode(code);
  }

  Future<void> set(AppLocaleOption option) async {
    await ref
        .read(localePreferencesStoreProvider)
        .setLanguageCode(option.languageCode);
    state = AsyncData(option);
  }
}
