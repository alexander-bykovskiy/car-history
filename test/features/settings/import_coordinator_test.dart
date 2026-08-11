import 'package:car_history/features/settings/data/backup/import_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImportCoordinator', () {
    test('mergeNamedCatalog maps and skips duplicates', () async {
      final existing = <({int id, String name, bool isDeleted})>[
        (id: 1, name: 'Petrol', isDeleted: false),
      ];
      var added = 0;
      var skipped = 0;
      final map = await ImportCoordinator.mergeNamedCatalog(
        items: [
          {'id': 10, 'name': 'Petrol'},
          {'id': 11, 'name': 'Diesel'},
        ],
        selectAll: () async => existing,
        nameOf: (row) => row.name,
        idOf: (row) => row.id,
        isDeletedOf: (row) => row.isDeleted,
        insert: (name, isDeleted, createdAt, updatedAt) async {
          final id = 100 + added;
          existing.add((id: id, name: name, isDeleted: isDeleted));
          return id;
        },
        undelete: (_) async {},
        onAdded: () => added++,
        onSkipped: () => skipped++,
      );

      expect(map[10], 1);
      expect(map[11], 100);
      expect(added, 1);
      expect(skipped, 1);
    });

    test('mergeNamedCatalog merges duplicate names inside one backup file',
        () async {
      final existing = <({int id, String name, bool isDeleted})>[];
      var added = 0;
      var skipped = 0;
      final map = await ImportCoordinator.mergeNamedCatalog(
        items: [
          {'id': 1, 'name': 'Diesel'},
          {'id': 2, 'name': 'diesel'},
          {'id': 3, 'name': 'Diesel'},
        ],
        selectAll: () async => existing,
        nameOf: (row) => row.name,
        idOf: (row) => row.id,
        isDeletedOf: (row) => row.isDeleted,
        insert: (name, isDeleted, createdAt, updatedAt) async {
          final id = 50 + added;
          existing.add((id: id, name: name, isDeleted: isDeleted));
          return id;
        },
        undelete: (_) async {},
        onAdded: () => added++,
        onSkipped: () => skipped++,
      );

      expect(map[1], 50);
      expect(map[2], 50);
      expect(map[3], 50);
      expect(added, 1);
      expect(skipped, 2);
      expect(existing, hasLength(1));
    });

    test('mergeNamedCatalog undeletes soft-deleted match for active backup row',
        () async {
      final existing = <({int id, String name, bool isDeleted})>[
        (id: 7, name: 'Oil', isDeleted: true),
      ];
      var undeletedId = -1;
      final map = await ImportCoordinator.mergeNamedCatalog(
        items: [
          {'id': 1, 'name': 'Oil', 'isDeleted': false},
        ],
        selectAll: () async => existing,
        nameOf: (row) => row.name,
        idOf: (row) => row.id,
        isDeletedOf: (row) => row.isDeleted,
        insert: (name, isDeleted, createdAt, updatedAt) async {
          fail('should not insert when soft-deleted match exists');
        },
        undelete: (id) async {
          undeletedId = id;
          existing[0] = (id: 7, name: 'Oil', isDeleted: false);
        },
        onAdded: () {},
        onSkipped: () {},
      );

      expect(map[1], 7);
      expect(undeletedId, 7);
    });

    test('mergeNamedCatalog prefers active when soft-deleted shares the name',
        () async {
      for (final existing in [
        <({int id, String name, bool isDeleted})>[
          (id: 1, name: 'Oil', isDeleted: true),
          (id: 2, name: 'Oil', isDeleted: false),
        ],
        <({int id, String name, bool isDeleted})>[
          (id: 2, name: 'Oil', isDeleted: false),
          (id: 1, name: 'Oil', isDeleted: true),
        ],
      ]) {
        var undeleteCalls = 0;
        final map = await ImportCoordinator.mergeNamedCatalog(
          items: [
            {'id': 10, 'name': 'Oil', 'isDeleted': false},
          ],
          selectAll: () async => existing,
          nameOf: (row) => row.name,
          idOf: (row) => row.id,
          isDeletedOf: (row) => row.isDeleted,
          insert: (name, isDeleted, createdAt, updatedAt) async {
            fail('should not insert when active match exists');
          },
          undelete: (_) async {
            undeleteCalls++;
          },
          onAdded: () {},
          onSkipped: () {},
        );

        expect(map[10], 2);
        expect(undeleteCalls, 0);
      }
    });
  });
}
