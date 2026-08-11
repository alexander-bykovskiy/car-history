import 'package:drift/drift.dart';

import '../../../core/gas_station_address.dart';
import '../../../shared/data/db/app_database.dart';
import '../domain/entities/gas_station.dart';
import '../domain/entities/named_place.dart';
import 'gas_station_mappers.dart';
import 'gas_station_query_store.dart';
import '../../../core/named_match.dart';

/// Chain/location create/update/restore/delete and reference checks.
class GasStationWriteStore {
  GasStationWriteStore(this._db, this._query);

  final AppDatabase _db;
  final GasStationQueryStore _query;

  Future<bool> hasLocationReferences(int locationId) async {
    final fueling = await (_db.select(_db.fuelings)
          ..where((t) => t.gasStationId.equals(locationId))
          ..limit(1))
        .getSingleOrNull();
    return fueling != null;
  }

  Future<bool> hasChainReferences(int chainId) async {
    final locations = await (_db.select(_db.gasStationLocations)
          ..where((t) => t.chainId.equals(chainId)))
        .get();
    for (final location in locations) {
      if (await hasLocationReferences(location.id)) return true;
    }
    return false;
  }

  Future<GasStationChainItem?> findChainMatching(String rawName) {
    return findNamedCatalogMatch(
      loadAll: () => _db.select(_db.gasStationChains).get(),
      nameOf: (row) => row.name,
      isDeletedOf: (row) => row.isDeleted,
      rawName: rawName,
    ).then((row) => row == null ? null : mapGasStationChain(row));
  }

  /// Inserts a new chain row. Caller must already resolve name conflicts.
  Future<GasStationChainSaveOutcome> insertNewChain(String name) async {
    final now = DateTime.now();
    final id = await _db.into(_db.gasStationChains).insert(
          GasStationChainsCompanion.insert(
            name: name,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final created = await _query.getChainById(id);
    return GasStationChainSaveOutcome(
      CatalogSaveResult.created,
      chain: created,
    );
  }

  /// Inserts a new location. [normalizedAddress] must already be normalized.
  Future<GasStationLocationSaveOutcome> insertNewLocation({
    required int chainId,
    required String? normalizedAddress,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.gasStationLocations).insert(
          GasStationLocationsCompanion.insert(
            chainId: chainId,
            address: Value(normalizedAddress),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final created = await _query.getLocationById(id);
    return GasStationLocationSaveOutcome(
      CatalogSaveResult.created,
      location: created,
    );
  }

  Future<GasStationLocationItem?> findLocationMatching({
    required int chainId,
    required String? normalizedAddress,
    int? excludeId,
  }) async {
    final siblings = await (_db.select(_db.gasStationLocations)
          ..where((t) => t.chainId.equals(chainId)))
        .get();
    final row = GasStationAddress.findLocationIn(
      rows: siblings,
      chainIdOf: (r) => r.chainId,
      addressOf: (r) => r.address,
      isDeletedOf: (r) => r.isDeleted,
      idOf: (r) => r.id,
      chainId: chainId,
      address: normalizedAddress,
      excludeId: excludeId,
    );
    return row == null ? null : mapGasStationLocation(row);
  }

  /// Explicit catalog create: soft-deleted name → [needsRestoreConfirm], not auto-restore.
  Future<GasStationChainSaveOutcome> createChain(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      return const GasStationChainSaveOutcome(CatalogSaveResult.emptyName);
    }

    final existing = await findChainMatching(name);
    final conflict = catalogCreateConflictResult(
      softDeleteMatchKind(existing?.isDeleted),
    );
    if (conflict != null) {
      return GasStationChainSaveOutcome(conflict, chain: existing);
    }

    return insertNewChain(name);
  }

  /// Explicit location create: soft-deleted address → [needsRestoreConfirm].
  Future<GasStationLocationSaveOutcome> createLocation({
    required int chainId,
    String? address,
  }) async {
    final normalizedAddress = GasStationAddress.normalize(address);

    final existing = await findLocationMatching(
      chainId: chainId,
      normalizedAddress: normalizedAddress,
    );
    final conflict = catalogCreateConflictResult(
      softDeleteMatchKind(existing?.isDeleted),
    );
    if (conflict != null) {
      return GasStationLocationSaveOutcome(conflict, location: existing);
    }

    return insertNewLocation(
      chainId: chainId,
      normalizedAddress: normalizedAddress,
    );
  }

  Future<GasStationChainSaveOutcome> updateChain(
    GasStationChainItem current,
    String rawName,
  ) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      return const GasStationChainSaveOutcome(CatalogSaveResult.emptyName);
    }

    final existing = await findChainMatching(name);
    if (existing != null && existing.id != current.id) {
      final conflict = catalogCreateConflictResult(
        softDeleteMatchKind(existing.isDeleted),
      );
      if (conflict != null) {
        return GasStationChainSaveOutcome(conflict, chain: existing);
      }
    }

    await (_db.update(_db.gasStationChains)
          ..where((t) => t.id.equals(current.id)))
        .write(
      GasStationChainsCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await _query.getChainById(current.id);
    return GasStationChainSaveOutcome(
      CatalogSaveResult.updated,
      chain: updated,
    );
  }

  Future<GasStationLocationSaveOutcome> updateLocation(
    GasStationLocationItem current, {
    String? address,
  }) async {
    final normalizedAddress = GasStationAddress.normalize(address);

    final existing = await findLocationMatching(
      chainId: current.chainId,
      normalizedAddress: normalizedAddress,
      excludeId: current.id,
    );
    final conflict = catalogCreateConflictResult(
      softDeleteMatchKind(existing?.isDeleted),
    );
    if (conflict != null) {
      return GasStationLocationSaveOutcome(conflict, location: existing);
    }

    await (_db.update(_db.gasStationLocations)
          ..where((t) => t.id.equals(current.id)))
        .write(
      GasStationLocationsCompanion(
        address: Value(normalizedAddress),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await _query.getLocationById(current.id);
    return GasStationLocationSaveOutcome(
      CatalogSaveResult.updated,
      location: updated,
    );
  }

  /// Undeletes the chain and every soft-deleted location under it.
  ///
  /// Mirrors [deleteChain] cascade soft-delete so ensure / catalog restore do
  /// not leave hidden null-address locations soft-deleted.
  Future<void> restoreChain(GasStationChainItem chain, {String? name}) async {
    final trimmedName = name?.trim();
    final now = DateTime.now();
    await (_db.update(_db.gasStationChains)..where((t) => t.id.equals(chain.id)))
        .write(
      GasStationChainsCompanion(
        isDeleted: const Value(false),
        name: trimmedName == null || trimmedName.isEmpty
            ? const Value.absent()
            : Value(trimmedName),
        updatedAt: Value(now),
      ),
    );
    await (_db.update(_db.gasStationLocations)
          ..where(
            (t) => t.chainId.equals(chain.id) & t.isDeleted.equals(true),
          ))
        .write(
      GasStationLocationsCompanion(
        isDeleted: const Value(false),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> restoreLocation(
    GasStationLocationItem location, {
    String? address,
  }) async {
    // null argument = keep existing address; non-null goes through normalize
    // (blank → SQL null) so restore matches ensure/update uniqueness.
    final addressCompanion = address == null
        ? const Value<String?>.absent()
        : Value<String?>(GasStationAddress.normalize(address));
    await (_db.update(_db.gasStationLocations)
          ..where((t) => t.id.equals(location.id)))
        .write(
      GasStationLocationsCompanion(
        isDeleted: const Value(false),
        address: addressCompanion,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteChain(GasStationChainItem chain) async {
    if (await hasChainReferences(chain.id)) {
      await (_db.update(_db.gasStationChains)
            ..where((t) => t.id.equals(chain.id)))
          .write(
        GasStationChainsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (_db.update(_db.gasStationLocations)
            ..where((t) => t.chainId.equals(chain.id)))
          .write(
        GasStationLocationsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await (_db.delete(_db.gasStationLocations)
            ..where((t) => t.chainId.equals(chain.id)))
          .go();
      await (_db.delete(_db.gasStationChains)..where((t) => t.id.equals(chain.id)))
          .go();
    }
  }

  Future<void> deleteLocation(GasStationLocationItem location) async {
    if (await hasLocationReferences(location.id)) {
      await (_db.update(_db.gasStationLocations)
            ..where((t) => t.id.equals(location.id)))
          .write(
        GasStationLocationsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await (_db.delete(_db.gasStationLocations)
            ..where((t) => t.id.equals(location.id)))
          .go();
    }
  }
}
