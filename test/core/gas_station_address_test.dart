import 'package:car_history/core/gas_station_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GasStationAddress', () {
    test('normalize turns blank into null and trims', () {
      expect(GasStationAddress.normalize(null), isNull);
      expect(GasStationAddress.normalize(''), isNull);
      expect(GasStationAddress.normalize('  '), isNull);
      expect(GasStationAddress.normalize('  Main St  '), 'Main St');
    });

    test('same matches case-insensitively and treats blank as bare', () {
      expect(GasStationAddress.same(null, null), isTrue);
      expect(GasStationAddress.same('', '  '), isTrue);
      expect(GasStationAddress.same('Main St', 'main st'), isTrue);
      expect(GasStationAddress.same('Main St', 'Other'), isFalse);
      expect(GasStationAddress.same(null, 'Main'), isFalse);
    });

    test('findLocationIn matches chain + address and can exclude id', () {
      final rows = [
        (id: 1, chainId: 10, address: 'Main St', isDeleted: false),
        (id: 2, chainId: 10, address: 'Other', isDeleted: false),
        (id: 3, chainId: 11, address: 'Main St', isDeleted: false),
      ];
      expect(
        GasStationAddress.findLocationIn(
          rows: rows,
          chainIdOf: (r) => r.chainId,
          addressOf: (r) => r.address,
          isDeletedOf: (r) => r.isDeleted,
          idOf: (r) => r.id,
          chainId: 10,
          address: 'main st',
        )?.id,
        1,
      );
      expect(
        GasStationAddress.findLocationIn(
          rows: rows,
          chainIdOf: (r) => r.chainId,
          addressOf: (r) => r.address,
          isDeletedOf: (r) => r.isDeleted,
          idOf: (r) => r.id,
          chainId: 10,
          address: 'main st',
          excludeId: 1,
        ),
        isNull,
      );
    });

    test('findLocationIn prefers active over soft-deleted', () {
      final softDeletedFirst = [
        (id: 1, chainId: 10, address: 'Main St', isDeleted: true),
        (id: 2, chainId: 10, address: 'Main St', isDeleted: false),
      ];
      final activeFirst = [
        (id: 2, chainId: 10, address: 'Main St', isDeleted: false),
        (id: 1, chainId: 10, address: 'Main St', isDeleted: true),
      ];

      expect(
        GasStationAddress.findLocationIn(
          rows: softDeletedFirst,
          chainIdOf: (r) => r.chainId,
          addressOf: (r) => r.address,
          isDeletedOf: (r) => r.isDeleted,
          chainId: 10,
          address: 'main st',
        )?.id,
        2,
      );
      expect(
        GasStationAddress.findLocationIn(
          rows: activeFirst,
          chainIdOf: (r) => r.chainId,
          addressOf: (r) => r.address,
          isDeletedOf: (r) => r.isDeleted,
          chainId: 10,
          address: 'main st',
        )?.id,
        2,
      );
    });

    test('findLocationIn returns soft-deleted when no active match', () {
      final rows = [
        (id: 7, chainId: 10, address: 'Main St', isDeleted: true),
      ];
      expect(
        GasStationAddress.findLocationIn(
          rows: rows,
          chainIdOf: (r) => r.chainId,
          addressOf: (r) => r.address,
          isDeletedOf: (r) => r.isDeleted,
          chainId: 10,
          address: 'Main St',
        )?.id,
        7,
      );
    });
  });
}
