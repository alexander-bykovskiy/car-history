import 'package:car_history/features/catalog/data/gas_station_pick_parse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseGasStationPickInput', () {
    test('empty → empty chain', () {
      final parsed = parseGasStationPickInput('  ');
      expect(parsed.chainName, '');
      expect(parsed.address, isNull);
    });

    test('chain only', () {
      final parsed = parseGasStationPickInput('Shell');
      expect(parsed.chainName, 'Shell');
      expect(parsed.address, isNull);
    });

    test('chain · address', () {
      final parsed = parseGasStationPickInput('Shell · Main St 1');
      expect(parsed.chainName, 'Shell');
      expect(parsed.address, 'Main St 1');
    });

    test('chain | address', () {
      final parsed = parseGasStationPickInput('BP|Downtown');
      expect(parsed.chainName, 'BP');
      expect(parsed.address, 'Downtown');
    });
  });
}
