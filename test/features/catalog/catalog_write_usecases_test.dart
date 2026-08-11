import 'package:car_history/features/catalog/data/fuel_type_repository_impl.dart';
import 'package:car_history/features/catalog/data/part_repository_impl.dart';
import 'package:car_history/features/catalog/domain/entities/named_catalog_item.dart';
import 'package:car_history/features/catalog/domain/usecases/catalog_write_usecases.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Catalog multi-step use cases', () {
    late AppDatabase db;

    setUp(() async {
      db = await openInMemoryDatabase();
    });

    tearDown(() async {
      await db.close();
    });

    test('rolls back fuel type when write fails inside use case tx', () async {
      final carId = (await db.select(db.cars).getSingle()).id;
      final save = SaveFuelTypeUseCase(
        _AbortingFuelTypeRepository(db),
        DriftTransactionRunner(db),
      );
      const name = 'Tx Rollback Fuel Type';

      await expectLater(
        save.create(name, carIds: [carId], appliesToAll: false),
        throwsA(isA<StateError>()),
      );

      final after = await db.select(db.fuelTypes).get();
      expect(after.any((row) => row.name == name), isFalse);
      final links = await db.select(db.fuelTypeCars).get();
      expect(links.where((row) => row.carId == carId), isEmpty);
    });

    test('rolls back part when write fails inside use case tx', () async {
      final carId = (await db.select(db.cars).getSingle()).id;
      final save = SavePartUseCase(
        _AbortingPartRepository(db),
        DriftTransactionRunner(db),
      );
      const name = 'Tx Rollback Part';

      await expectLater(
        save.create(name, carIds: [carId], appliesToAll: false),
        throwsA(isA<StateError>()),
      );

      final after = await db.select(db.parts).get();
      expect(after.any((row) => row.name == name), isFalse);
    });
  });
}

/// Completes a real create, then throws so the outer use-case transaction rolls back.
class _AbortingFuelTypeRepository extends FuelTypeRepositoryImpl {
  _AbortingFuelTypeRepository(super.db);

  @override
  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) async {
    await super.create(
      rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
    );
    throw StateError('force rollback after fuel type create');
  }
}

class _AbortingPartRepository extends PartRepositoryImpl {
  _AbortingPartRepository(super.db);

  @override
  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) async {
    await super.create(
      rawName,
      carIds: carIds,
      appliesToAll: appliesToAll,
    );
    throw StateError('force rollback after part create');
  }
}
