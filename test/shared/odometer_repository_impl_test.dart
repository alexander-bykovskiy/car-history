import 'package:car_history/features/fueling/data/fueling_repository_impl.dart';
import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OdometerRepositoryImpl', () {
    late AppDatabase db;
    late OdometerRepositoryImpl odometer;
    late FuelingRepositoryImpl fuelings;
    late MaintenanceRepositoryImpl maintenances;
    late int carId;
    late int fuelTypeId;
    late int serviceId;

    setUp(() async {
      db = await openInMemoryDatabase();
      odometer = OdometerRepositoryImpl(db);
      fuelings = FuelingRepositoryImpl(db);
      maintenances = MaintenanceRepositoryImpl(db);
      carId = (await db.select(db.cars).getSingle()).id;
      fuelTypeId = (await (db.select(db.fuelTypes)..limit(1)).getSingle()).id;
      final service = await db.into(db.services).insertReturning(
            ServicesCompanion.insert(name: 'Oil'),
          );
      serviceId = service.id;
    });

    tearDown(() async {
      await db.close();
    });

    test('maxOdometerKm spans fuelings and maintenances', () async {
      await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 2, 1),
        pricePerLiter: 1,
        liters: 1,
        totalAmount: 1,
        currencyCode: 'EUR',
        odometerKm: 100,
      );
      await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 2, 2),
        currencyCode: 'EUR',
        odometerKm: 250,
      );

      expect(await odometer.maxOdometerKm(carId), 250);
    });

    test('neighbors use combined timeline', () async {
      await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 3, 1),
        pricePerLiter: 1,
        liters: 1,
        totalAmount: 1,
        currencyCode: 'EUR',
        odometerKm: 100,
      );
      await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 3, 10),
        currencyCode: 'EUR',
        odometerKm: 200,
      );

      final neighbors = await odometer.odometerNeighbors(
        carId: carId,
        at: DateTime(2024, 3, 5),
      );
      expect(neighbors.previousKm, 100);
      expect(neighbors.nextKm, 200);
    });

    test('create treats same-timestamp readings as previous', () async {
      await fuelings.create(
        carId: carId,
        fuelTypeId: fuelTypeId,
        fueledAt: DateTime(2024, 4, 1),
        pricePerLiter: 1,
        liters: 1,
        totalAmount: 1,
        currencyCode: 'EUR',
        odometerKm: 300,
      );

      final neighbors = await odometer.odometerNeighbors(
        carId: carId,
        at: DateTime(2024, 4, 1),
      );
      expect(neighbors.previousKm, 300);
      expect(neighbors.nextKm, isNull);
    });
  });
}
