import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/tip_preferences_store.dart';

class PrefsTipPreferencesStore implements TipPreferencesStore {
  static const _hideSwipeDeleteTip = 'hide_swipe_delete_tip';
  static const _legacyHideCarsSwipeDeleteTip = 'hide_cars_swipe_delete_tip';
  static const _hideDoubleTapEditTip = 'hide_double_tap_edit_tip';

  @override
  Future<bool> shouldShowSwipeDeleteTip() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_hideSwipeDeleteTip) == true) return false;

    // Migrate previous cars-only flag into the shared marker.
    if (prefs.getBool(_legacyHideCarsSwipeDeleteTip) == true) {
      await prefs.setBool(_hideSwipeDeleteTip, true);
      return false;
    }
    return true;
  }

  @override
  Future<void> hideSwipeDeleteTip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideSwipeDeleteTip, true);
  }

  @override
  Future<bool> shouldShowDoubleTapEditTip() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hideDoubleTapEditTip) != true;
  }

  @override
  Future<void> hideDoubleTapEditTip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideDoubleTapEditTip, true);
  }
}
