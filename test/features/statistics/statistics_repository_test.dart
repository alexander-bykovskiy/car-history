import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/statistics/data/statistics_repository_impl.dart';
import 'package:car_history/features/statistics/domain/entities/statistics.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StatisticsRepositoryImpl', () {
    late AppDatabase db;
    late StatisticsRepositoryImpl stats;
    late int carId;
    late int fuelTypeId;

    setUp(() async {
      db = await openInMemoryDatabase();
      stats = StatisticsRepositoryImpl(db);
      carId = (await db.select(db.cars).getSingle()).id;
      fuelTypeId = (await (db.select(db.fuelTypes)..limit(1)).getSingle()).id;
    });

    tearDown(() async {
      await db.close();
    });

    test('availableYears and monthly buckets include fueling totals', () async {
      final fuelings = FuelingRepositoryImpl(db);
      final created = await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 3, 15),
        pricePerLiter: 2,
        liters: 10,
        totalAmount: 20,
        currencyCode: 'EUR',
      );
      expect(created.item, isNotNull);

      final years = await stats.availableYears(carId);
      expect(years, contains(2024));

      final buckets = await stats.bucketsForCar(
        carId,
        groupBy: StatsGroupBy.months,
        focusYear: 2024,
      );
      expect(buckets, hasLength(12));
      final march = buckets[2];
      expect(march.fuelByCurrency['EUR'], 20);
    });
  });
}
