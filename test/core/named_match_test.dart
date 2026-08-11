import 'package:car_history/core/named_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('matchNamedCatalogRow', () {
    test('matches normalized names and ignores empty raw', () {
      final rows = [
        (id: 1, name: 'Alpha', isDeleted: false),
        (id: 2, name: 'Beta', isDeleted: false),
      ];
      expect(
        matchNamedCatalogRow(
          rows: rows,
          nameOf: (r) => r.name,
          isDeletedOf: (r) => r.isDeleted,
          rawName: '  alpha ',
        )?.id,
        1,
      );
      expect(
        matchNamedCatalogRow(
          rows: rows,
          nameOf: (r) => r.name,
          isDeletedOf: (r) => r.isDeleted,
          rawName: '   ',
        ),
        isNull,
      );
    });

    test('prefers active over soft-deleted with the same name', () {
      final softDeletedFirst = [
        (id: 1, name: 'Oil', isDeleted: true),
        (id: 2, name: 'Oil', isDeleted: false),
      ];
      final activeFirst = [
        (id: 2, name: 'Oil', isDeleted: false),
        (id: 1, name: 'Oil', isDeleted: true),
      ];

      expect(
        matchNamedCatalogRow(
          rows: softDeletedFirst,
          nameOf: (r) => r.name,
          isDeletedOf: (r) => r.isDeleted,
          rawName: 'oil',
        )?.id,
        2,
      );
      expect(
        matchNamedCatalogRow(
          rows: activeFirst,
          nameOf: (r) => r.name,
          isDeletedOf: (r) => r.isDeleted,
          rawName: 'oil',
        )?.id,
        2,
      );
    });

    test('returns soft-deleted when no active match exists', () {
      final rows = [(id: 7, name: 'Oil', isDeleted: true)];
      expect(
        matchNamedCatalogRow(
          rows: rows,
          nameOf: (r) => r.name,
          isDeletedOf: (r) => r.isDeleted,
          rawName: 'Oil',
        )?.id,
        7,
      );
    });
  });
}
