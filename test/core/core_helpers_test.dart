import 'package:car_history/core/event_date_limits.dart';
import 'package:car_history/core/name_normalizer.dart';
import 'package:car_history/core/number_formatting.dart';
import 'package:car_history/core/odometer_sequence.dart';
import 'package:car_history/shared/domain/event_odometer_warning.dart';
import 'package:car_history/shared/domain/odometer_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NameNormalizer', () {
    test('trims and lowercases', () {
      expect(NameNormalizer.normalize('  Diesel  '), 'diesel');
    });
  });

  group('kMinEventDate', () {
    test('is year 1990', () {
      expect(kMinEventDate.year, 1990);
      expect(kMinEventDate.month, 1);
      expect(kMinEventDate.day, 1);
    });
  });

  group('formatFlexibleDouble', () {
    test('formats whole numbers without decimals', () {
      expect(formatFlexibleDouble(10), '10');
      expect(formatFlexibleDouble(10.0), '10');
    });

    test('trims trailing zeros', () {
      expect(formatFlexibleDouble(1.5), '1.5');
      expect(formatFlexibleDouble(1.250), '1.25');
    });
  });

  group('eventOdometerWarning', () {
    test('returns null when sequence is fine', () async {
      final repo = _FakeOdometerRepository(
        const OdometerNeighbors(previousKm: 100, nextKm: 200),
      );
      final result = await eventOdometerWarning(
        odometer: repo,
        carId: 1,
        at: DateTime(2024, 1, 1),
        odometerKm: 150,
      );
      expect(result, isNull);
    });

    test('returns warning when lower than earlier', () async {
      final repo = _FakeOdometerRepository(
        const OdometerNeighbors(previousKm: 200, nextKm: null),
      );
      final result = await eventOdometerWarning(
        odometer: repo,
        carId: 1,
        at: DateTime(2024, 1, 1),
        odometerKm: 100,
      );
      expect(result, isNotNull);
      expect(result!.warning.lowerThanEarlier, isTrue);
      expect(result.neighbors.previousKm, 200);
    });
  });
}

class _FakeOdometerRepository implements OdometerRepository {
  _FakeOdometerRepository(this._neighbors);

  final OdometerNeighbors _neighbors;

  @override
  Future<double?> maxOdometerKm(
    int carId, {
    int? excludingFuelingId,
    int? excludingMaintenanceId,
  }) async =>
      null;

  @override
  Future<OdometerNeighbors> odometerNeighbors({
    required int carId,
    required DateTime at,
    OdometerEventSource? editingSource,
    int? excludingId,
  }) async =>
      _neighbors;
}
