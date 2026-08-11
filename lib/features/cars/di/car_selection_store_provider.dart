import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/car_selection_preferences.dart';
import '../domain/repositories/car_selection_store.dart';

/// Selected-car id store (SharedPreferences). Defaults work before DB bootstrap.
final carSelectionStoreProvider = Provider<CarSelectionStore>((ref) {
  final store = PrefsCarSelectionStore();
  ref.onDispose(store.dispose);
  return store;
});
