import '../../../shared/data/db/app_database.dart';
import '../domain/entities/gas_station.dart';
import '../domain/repositories/gas_station_repository.dart';
import 'gas_station_ensure.dart';
import 'gas_station_query_store.dart';
import 'gas_station_write_store.dart';

class GasStationRepositoryImpl implements GasStationRepository {
  GasStationRepositoryImpl(AppDatabase db)
      : _query = GasStationQueryStore(db) {
    _write = GasStationWriteStore(db, _query);
    _ensure = GasStationEnsure(_query, _write);
  }

  final GasStationQueryStore _query;
  late final GasStationWriteStore _write;
  late final GasStationEnsure _ensure;

  @override
  Stream<List<GasStationChainWithLocations>> watchChainsWithLocations() =>
      _query.watchChainsWithLocations();

  @override
  Stream<GasStationChainWithLocations?> watchChainWithLocations(int chainId) =>
      _query.watchChainWithLocations(chainId);

  @override
  Future<GasStationLocationItem?> getLocationById(int id) =>
      _query.getLocationById(id);

  @override
  Future<GasStationChainItem?> getChainById(int id) => _query.getChainById(id);

  @override
  Future<GasStationPickOption?> optionForLocationId(int locationId) =>
      _query.optionForLocationId(locationId);

  @override
  Future<List<GasStationPickOption>> searchOptions(String query) =>
      _query.searchOptions(query);

  @override
  Future<GasStationLocationSaveOutcome> ensureFromInput(String raw) =>
      _ensure.ensureFromInput(raw);

  @override
  Future<GasStationChainSaveOutcome> ensureChain(String rawName) =>
      _ensure.ensureChain(rawName);

  @override
  Future<GasStationLocationSaveOutcome> ensureLocation({
    required int chainId,
    String? address,
  }) =>
      _ensure.ensureLocation(chainId: chainId, address: address);

  @override
  Future<GasStationChainSaveOutcome> createChain(String rawName) =>
      _write.createChain(rawName);

  @override
  Future<GasStationLocationSaveOutcome> createLocation({
    required int chainId,
    String? address,
  }) =>
      _write.createLocation(chainId: chainId, address: address);

  @override
  Future<GasStationChainSaveOutcome> updateChain(
    GasStationChainItem current,
    String rawName,
  ) =>
      _write.updateChain(current, rawName);

  @override
  Future<GasStationLocationSaveOutcome> updateLocation(
    GasStationLocationItem current, {
    String? address,
  }) =>
      _write.updateLocation(current, address: address);

  @override
  Future<void> restoreChain(GasStationChainItem chain, {String? name}) =>
      _write.restoreChain(chain, name: name);

  @override
  Future<void> restoreLocation(
    GasStationLocationItem location, {
    String? address,
  }) =>
      _write.restoreLocation(location, address: address);

  @override
  Future<void> deleteChain(GasStationChainItem chain) =>
      _write.deleteChain(chain);

  @override
  Future<void> deleteLocation(GasStationLocationItem location) =>
      _write.deleteLocation(location);
}
