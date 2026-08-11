import 'package:car_history/features/catalog/data/named_catalog_simple_drift.dart';
import 'package:car_history/features/catalog/data/service_center_repository_impl.dart';
import 'package:car_history/features/catalog/domain/entities/named_place.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  test('restore applies address in one write via store', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final repo = ServiceCenterRepositoryImpl(db);
    final created = await repo.create(
      rawName: 'North Garage',
      address: 'Old street',
    );
    final item = created.item!;

    await (db.update(db.serviceCenters)..where((t) => t.id.equals(item.id)))
        .write(
      const ServiceCentersCompanion(isDeleted: Value(true)),
    );

    await repo.restore(item, address: '  New street  ');

    final restored = await repo.getById(item.id);
    expect(restored, isNotNull);
    expect(restored!.isDeleted, isFalse);
    expect(restored.address, 'New street');
  });

  test('store create/update/restore without overrides throw', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final store = buildServiceCenterSimpleStore(db);
    expect(
      () => store.create('Solo'),
      throwsA(isA<StateError>()),
    );

    final item = PlaceCatalogItem(
      id: 1,
      name: 'Solo',
      isDeleted: false,
    );
    expect(
      () => store.update(item, 'Solo 2'),
      throwsA(isA<StateError>()),
    );
    expect(
      () => store.restore(item),
      throwsA(isA<StateError>()),
    );
    expect(
      () => store.ensure('Solo'),
      throwsA(isA<StateError>()),
    );
  });

  test('create and update persist address via overrides', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final repo = ServiceCenterRepositoryImpl(db);
    final created = await repo.create(
      rawName: 'South Garage',
      address: '  First Ave  ',
    );
    expect(created.item?.address, 'First Ave');

    final updated = await repo.update(
      created.item!,
      rawName: 'South Garage',
      address: 'Second Ave',
    );
    expect(updated.item?.address, 'Second Ave');

    final loaded = await repo.getById(created.item!.id);
    expect(loaded?.address, 'Second Ave');
  });
}
