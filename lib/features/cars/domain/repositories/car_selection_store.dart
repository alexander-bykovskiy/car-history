import 'dart:async';

/// Persists which car is currently selected in the UI.
abstract class CarSelectionStore {
  Future<int?> getSelectedCarId();

  Future<void> setSelectedCarId(int id);

  Future<void> clearSelectedCarId();

  /// Fires when the selected id changes so watchers can re-resolve.
  Stream<void> get changes;
}
