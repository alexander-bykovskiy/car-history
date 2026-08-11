import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  test('restore applies name and iconKey in one write', () async {
    final db = await openInMemoryDatabase();
    addTearDown(db.close);

    final repo = ServiceRepositoryImpl(db);
    final created = await repo.create('Oil change', iconKey: 'build');
    final item = created.item!;

    // Soft-delete (hard delete removes the row when there are no references).
    await (db.update(db.services)..where((t) => t.id.equals(item.id))).write(
      const ServicesCompanion(isDeleted: Value(true)),
    );

    await repo.restore(item, name: 'Full service', iconKey: 'car_repair');

    final restored = await repo.getById(item.id);
    expect(restored, isNotNull);
    expect(restored!.isDeleted, isFalse);
    expect(restored.name, 'Full service');
    expect(restored.iconKey, 'car_repair');
  });
}
