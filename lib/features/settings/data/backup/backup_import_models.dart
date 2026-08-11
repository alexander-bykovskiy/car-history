/// Mutable added/skipped counters shared across import section helpers.
class BackupImportCounters {
  int added = 0;
  int skipped = 0;
}

/// ID remaps produced while merging named catalogs and gas-station locations.
class BackupCatalogIdMaps {
  const BackupCatalogIdMaps({
    required this.fuelTypeIdMap,
    required this.partIdMap,
    required this.partUnitIdMap,
    required this.serviceIdMap,
    required this.locationIdMap,
  });

  final Map<int, int> fuelTypeIdMap;
  final Map<int, int> partIdMap;
  final Map<int, int> partUnitIdMap;
  final Map<int, int> serviceIdMap;
  final Map<int, int> locationIdMap;
}
