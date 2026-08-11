import '../entities/gas_station.dart';

abstract class GasStationRepository {
  Stream<List<GasStationChainWithLocations>> watchChainsWithLocations();

  Stream<GasStationChainWithLocations?> watchChainWithLocations(int chainId);

  Future<GasStationLocationItem?> getLocationById(int id);

  Future<GasStationChainItem?> getChainById(int id);

  Future<GasStationPickOption?> optionForLocationId(int locationId);

  Future<List<GasStationPickOption>> searchOptions(String query);

  /// Ensures chain + location from a free-text pick string.
  ///
  /// Call only inside an outer use-case transaction (e.g. SaveFueling).
  Future<GasStationLocationSaveOutcome> ensureFromInput(String raw);

  Future<GasStationChainSaveOutcome> ensureChain(String rawName);

  Future<GasStationLocationSaveOutcome> ensureLocation({
    required int chainId,
    String? address,
  });

  Future<GasStationChainSaveOutcome> createChain(String rawName);

  Future<GasStationLocationSaveOutcome> createLocation({
    required int chainId,
    String? address,
  });

  Future<GasStationChainSaveOutcome> updateChain(
    GasStationChainItem current,
    String rawName,
  );

  Future<GasStationLocationSaveOutcome> updateLocation(
    GasStationLocationItem current, {
    String? address,
  });

  Future<void> restoreChain(GasStationChainItem chain, {String? name});

  Future<void> restoreLocation(
    GasStationLocationItem location, {
    String? address,
  });

  Future<void> deleteChain(GasStationChainItem chain);

  Future<void> deleteLocation(GasStationLocationItem location);
}
