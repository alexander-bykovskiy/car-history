import 'package:drift/drift.dart';

import '../../../core/name_normalizer.dart';
import '../../../shared/data/db/app_database.dart';
import '../domain/entities/gas_station.dart';
import 'gas_station_mappers.dart';

/// Read/watch/search for gas station chains and locations.
class GasStationQueryStore {
  GasStationQueryStore(this._db);

  final AppDatabase _db;

  Stream<List<GasStationChainWithLocations>> watchChainsWithLocations() {
    final query = _db.select(_db.gasStationChains).join([
      leftOuterJoin(
        _db.gasStationLocations,
        _db.gasStationLocations.chainId.equalsExp(_db.gasStationChains.id),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.gasStationChains.isDeleted),
        OrderingTerm.asc(_db.gasStationChains.name),
        OrderingTerm.asc(_db.gasStationLocations.isDeleted),
        OrderingTerm.asc(_db.gasStationLocations.address),
      ]);

    return query.watch().map(groupChainsWithLocations);
  }

  Stream<GasStationChainWithLocations?> watchChainWithLocations(int chainId) {
    final query = (_db.select(_db.gasStationChains).join([
      leftOuterJoin(
        _db.gasStationLocations,
        _db.gasStationLocations.chainId.equalsExp(_db.gasStationChains.id),
      ),
    ])
      ..where(_db.gasStationChains.id.equals(chainId))
      ..orderBy([
        OrderingTerm.asc(_db.gasStationLocations.isDeleted),
        OrderingTerm.asc(_db.gasStationLocations.address),
      ]));

    return query.watch().map((rows) {
      final grouped = groupChainsWithLocations(rows);
      return grouped.isEmpty ? null : grouped.first;
    });
  }

  List<GasStationChainWithLocations> groupChainsWithLocations(
    List<TypedResult> rows,
  ) {
    final order = <int>[];
    final byId = <int, GasStationChainWithLocations>{};

    for (final row in rows) {
      final chain = row.readTable(_db.gasStationChains);
      final location = row.readTableOrNull(_db.gasStationLocations);
      final existing = byId[chain.id];
      if (existing == null) {
        order.add(chain.id);
        byId[chain.id] = GasStationChainWithLocations(
          chain: mapGasStationChain(chain),
          locations: [
            if (location != null) mapGasStationLocation(location),
          ],
        );
      } else if (location != null) {
        existing.locations.add(mapGasStationLocation(location));
      }
    }

    return [for (final id in order) byId[id]!];
  }

  Future<GasStationLocationItem?> getLocationById(int id) async {
    final row = await (_db.select(_db.gasStationLocations)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : mapGasStationLocation(row);
  }

  Future<GasStationChainItem?> getChainById(int id) async {
    final row = await (_db.select(_db.gasStationChains)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : mapGasStationChain(row);
  }

  Future<GasStationPickOption?> optionForLocationId(int locationId) async {
    final location = await getLocationById(locationId);
    if (location == null) return null;
    final chain = await getChainById(location.chainId);
    if (chain == null) return null;
    return GasStationPickOption(
      locationId: location.id,
      chainName: chain.name,
      address: location.address,
    );
  }

  Future<List<GasStationPickOption>> searchOptions(String query) async {
    final normalized = NameNormalizer.normalize(query);
    final chains = await (_db.select(_db.gasStationChains)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();

    final options = <GasStationPickOption>[];
    for (final chain in chains) {
      final locations = await (_db.select(_db.gasStationLocations)
            ..where(
              (t) =>
                  t.chainId.equals(chain.id) & t.isDeleted.equals(false),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.address)]))
          .get();

      GasStationLocation? bare;
      for (final location in locations) {
        final address = location.address?.trim();
        if (address == null || address.isEmpty) {
          bare ??= location;
          continue;
        }
        options.add(
          GasStationPickOption(
            locationId: location.id,
            chainName: chain.name,
            address: address,
          ),
        );
      }

      options.add(
        GasStationPickOption(
          locationId: bare?.id,
          chainName: chain.name,
        ),
      );
    }

    options.sort((a, b) {
      final byName =
          a.chainName.toLowerCase().compareTo(b.chainName.toLowerCase());
      if (byName != 0) return byName;
      final aBare = a.address == null || a.address!.isEmpty;
      final bBare = b.address == null || b.address!.isEmpty;
      if (aBare != bBare) return aBare ? -1 : 1;
      return (a.address ?? '').compareTo(b.address ?? '');
    });

    if (normalized.isEmpty) return options;
    return options
        .where(
          (option) =>
              NameNormalizer.normalize(option.label).contains(normalized),
        )
        .toList();
  }
}
