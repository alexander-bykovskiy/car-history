import '../../../core/gas_station_address.dart';
import '../domain/entities/gas_station.dart';
import '../domain/entities/named_place.dart';
import 'gas_station_pick_parse.dart';
import 'gas_station_query_store.dart';
import 'gas_station_write_store.dart';

/// Ensure chain/location helpers (must run inside an outer use-case transaction).
class GasStationEnsure {
  GasStationEnsure(this._query, this._write);

  final GasStationQueryStore _query;
  final GasStationWriteStore _write;

  Future<GasStationLocationSaveOutcome> ensureFromInput(String raw) async {
    final parsed = parseGasStationPickInput(raw);
    if (parsed.chainName.isEmpty) {
      return const GasStationLocationSaveOutcome(CatalogSaveResult.emptyName);
    }

    final chainOutcome = await ensureChain(parsed.chainName);
    final chain = chainOutcome.chain;
    if (chain == null) {
      return const GasStationLocationSaveOutcome(CatalogSaveResult.emptyName);
    }

    return ensureLocation(chainId: chain.id, address: parsed.address);
  }

  Future<GasStationChainSaveOutcome> ensureChain(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      return const GasStationChainSaveOutcome(CatalogSaveResult.emptyName);
    }

    final existing = await _write.findChainMatching(name);
    switch (softDeleteMatchKind(existing?.isDeleted)) {
      case SoftDeleteMatchKind.softDeleted:
        await _write.restoreChain(existing!);
        final restored = await _query.getChainById(existing.id);
        return GasStationChainSaveOutcome(
          CatalogSaveResult.restored,
          chain: restored,
        );
      case SoftDeleteMatchKind.active:
        return GasStationChainSaveOutcome(
          CatalogSaveResult.alreadyExists,
          chain: existing,
        );
      case SoftDeleteMatchKind.missing:
        return _write.insertNewChain(name);
    }
  }

  Future<GasStationLocationSaveOutcome> ensureLocation({
    required int chainId,
    String? address,
  }) async {
    final normalizedAddress = GasStationAddress.normalize(address);

    final existing = await _write.findLocationMatching(
      chainId: chainId,
      normalizedAddress: normalizedAddress,
    );
    switch (softDeleteMatchKind(existing?.isDeleted)) {
      case SoftDeleteMatchKind.softDeleted:
        await _write.restoreLocation(existing!);
        final restored = await _query.getLocationById(existing.id);
        return GasStationLocationSaveOutcome(
          CatalogSaveResult.restored,
          location: restored,
        );
      case SoftDeleteMatchKind.active:
        return GasStationLocationSaveOutcome(
          CatalogSaveResult.alreadyExists,
          location: existing,
        );
      case SoftDeleteMatchKind.missing:
        return _write.insertNewLocation(
          chainId: chainId,
          normalizedAddress: normalizedAddress,
        );
    }
  }
}
