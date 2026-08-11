import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/last_part_unit_store.dart';

/// SharedPreferences implementation of [LastPartUnitStore].
class PrefsLastPartUnitStore implements LastPartUnitStore {
  static const prefsKey = 'last_part_unit_id';

  @override
  Future<int?> lastPartUnitId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(prefsKey);
  }

  @override
  Future<void> setLastPartUnitId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefsKey, id);
  }
}
