/// Persists the last selected part unit id for maintenance part dialogs.
abstract class LastPartUnitStore {
  Future<int?> lastPartUnitId();

  Future<void> setLastPartUnitId(int id);
}
