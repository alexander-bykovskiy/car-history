import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/car_selection_store.dart';

/// Persists the selected car id in SharedPreferences (key [prefsKey]).
class PrefsCarSelectionStore implements CarSelectionStore {
  static const prefsKey = 'selected_car_id';

  final _tick = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _tick.stream;

  @override
  Future<int?> getSelectedCarId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(prefsKey);
  }

  @override
  Future<void> setSelectedCarId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefsKey, id);
    if (!_tick.isClosed) _tick.add(null);
  }

  @override
  Future<void> clearSelectedCarId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsKey);
    if (!_tick.isClosed) _tick.add(null);
  }

  void dispose() {
    _tick.close();
  }
}
