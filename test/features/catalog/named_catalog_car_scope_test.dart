import 'package:car_history/features/catalog/data/named_catalog_car_scope.dart';
import 'package:car_history/features/catalog/domain/entities/named_catalog_item.dart';
import 'package:flutter_test/flutter_test.dart';

NamedCatalogItem _item(int id, String name) => NamedCatalogItem(
      id: id,
      name: name,
      isDeleted: false,
    );

void main() {
  group('NamedCatalogCarScope', () {
    test('listForCar returns all-car items and linked items only', () async {
      final scope = NamedCatalogCarScope(
        loadActiveOrdered: () async => [
          _item(1, 'A-all'),
          _item(2, 'B-car1'),
          _item(3, 'C-car2'),
        ],
        loadAllLinks: () async => [
          (itemId: 2, carId: 1),
          (itemId: 3, carId: 2),
        ],
        loadCarIdsForItem: (id) async => const [],
        clearLinksForItem: (_) async {},
        insertLinksForItem: (_, _) async {},
      );

      final forCar1 = await scope.listForCar(1);
      expect(forCar1.map((e) => e.id), [1, 2]);

      final forCar2 = await scope.listForCar(2);
      expect(forCar2.map((e) => e.id), [1, 3]);
    });

    test('filterByNormalizedQuery is case-insensitive', () {
      final items = [_item(1, 'Diesel'), _item(2, 'Petrol')];
      final filtered =
          NamedCatalogCarScope.filterByNormalizedQuery(items, 'die');
      expect(filtered.single.name, 'Diesel');
    });
  });
}
