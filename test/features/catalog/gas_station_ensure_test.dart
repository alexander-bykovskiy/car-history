import 'package:car_history/features/catalog/data/gas_station_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_center_repository_impl.dart';
import 'package:car_history/features/catalog/domain/entities/named_place.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GasStationRepository ensure/delete edges', () {
    test('ensureFromInput creates chain+location inside outer transaction',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);
      final tx = DriftTransactionRunner(db);

      final outcome = await tx.runInTransaction(
        () => stations.ensureFromInput('Shell · Downtown'),
      );

      expect(outcome.result, CatalogSaveResult.created);
      expect(outcome.location, isNotNull);
      expect(outcome.location!.address, 'Downtown');

      final chain = await stations.getChainById(outcome.location!.chainId);
      expect(chain?.name, 'Shell');
    });

    test('ensureFromInput reuses active chain and restores soft-deleted location',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);
      final tx = DriftTransactionRunner(db);

      final created = await tx.runInTransaction(
        () => stations.ensureFromInput('BP · North'),
      );
      final location = created.location!;
      await (db.update(db.gasStationLocations)
            ..where((t) => t.id.equals(location.id)))
          .write(
        const GasStationLocationsCompanion(isDeleted: Value(true)),
      );

      final again = await tx.runInTransaction(
        () => stations.ensureFromInput('BP · North'),
      );
      expect(again.result, CatalogSaveResult.restored);
      expect(again.location?.id, location.id);
      expect(again.location?.isDeleted, isFalse);
    });

    test('deleteLocation hard-deletes when unreferenced', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);

      final chain = (await stations.createChain('Solo')).chain!;
      final location = (await stations.ensureLocation(
        chainId: chain.id,
        address: 'A',
      ))
          .location!;

      await stations.deleteLocation(location);

      expect(await stations.getLocationById(location.id), isNull);
    });

    test('restoreLocation normalizes blank address to null', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);

      final chain = (await stations.createChain('BlankRestore')).chain!;
      final location = (await stations.ensureLocation(
        chainId: chain.id,
        address: 'Keep Me',
      ))
          .location!;

      await stations.restoreLocation(location, address: '   ');
      final restored = await stations.getLocationById(location.id);
      expect(restored?.isDeleted, isFalse);
      expect(restored?.address, isNull);
    });

    test('createChain asks restore confirm for soft-deleted name', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);

      final created = await stations.createChain('Shell');
      final chain = created.chain!;
      await (db.update(db.gasStationChains)..where((t) => t.id.equals(chain.id)))
          .write(
        const GasStationChainsCompanion(isDeleted: Value(true)),
      );

      final again = await stations.createChain('shell');
      expect(again.result, CatalogSaveResult.needsRestoreConfirm);
      expect(again.chain?.id, chain.id);
      expect((await stations.getChainById(chain.id))!.isDeleted, isTrue);
    });

    test('createLocation asks restore confirm for soft-deleted address',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);

      final chain = (await stations.createChain('BP')).chain!;
      final location = (await stations.createLocation(
        chainId: chain.id,
        address: 'North',
      ))
          .location!;

      // Soft-delete by referencing via a fake path: deleteLocation hard-deletes
      // when unreferenced, so mark deleted directly.
      await (db.update(db.gasStationLocations)
            ..where((t) => t.id.equals(location.id)))
          .write(
        const GasStationLocationsCompanion(isDeleted: Value(true)),
      );

      final again = await stations.createLocation(
        chainId: chain.id,
        address: 'north',
      );
      expect(again.result, CatalogSaveResult.needsRestoreConfirm);
      expect(again.location?.id, location.id);
    });

    test('updateLocation asks restore confirm for soft-deleted sibling',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);

      final chain = (await stations.createChain('Q8')).chain!;
      final active = (await stations.createLocation(
        chainId: chain.id,
        address: 'A',
      ))
          .location!;
      final deleted = (await stations.createLocation(
        chainId: chain.id,
        address: 'B',
      ))
          .location!;
      await (db.update(db.gasStationLocations)
            ..where((t) => t.id.equals(deleted.id)))
          .write(
        const GasStationLocationsCompanion(isDeleted: Value(true)),
      );

      final outcome = await stations.updateLocation(active, address: 'B');
      expect(outcome.result, CatalogSaveResult.needsRestoreConfirm);
      expect(outcome.location?.id, deleted.id);
      expect((await stations.getLocationById(active.id))?.address, 'A');
    });

    test('ensureChain still auto-restores soft-deleted name', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final stations = GasStationRepositoryImpl(db);
      final tx = DriftTransactionRunner(db);

      final created = await stations.createChain('Auto');
      await (db.update(db.gasStationChains)
            ..where((t) => t.id.equals(created.chain!.id)))
          .write(
        const GasStationChainsCompanion(isDeleted: Value(true)),
      );

      final ensured = await tx.runInTransaction(
        () => stations.ensureChain('Auto'),
      );
      expect(ensured.result, CatalogSaveResult.restored);
      expect(ensured.chain?.isDeleted, isFalse);
    });
  });

  group('ServiceCenterRepository delete', () {
    test('hard-deletes because places have no event references', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final repo = ServiceCenterRepositoryImpl(db);

      final created = await repo.create(rawName: 'Workshop A', address: '  ');
      expect(created.result, CatalogSaveResult.created);
      expect(created.item?.address, isNull);

      final item = created.item!;
      await repo.delete(item);
      expect(await repo.getById(item.id), isNull);
    });
  });
}
