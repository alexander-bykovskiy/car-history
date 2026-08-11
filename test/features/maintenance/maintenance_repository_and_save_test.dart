import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance_save.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MaintenanceRepositoryImpl', () {
    late AppDatabase db;
    late MaintenanceRepositoryImpl maintenances;
    late int carId;
    late int serviceId;
    late int partId;

    setUp(() async {
      db = await openInMemoryDatabase();
      maintenances = MaintenanceRepositoryImpl(db);
      carId = (await db.select(db.cars).getSingle()).id;
      final now = DateTime.now();
      serviceId = await db.into(db.services).insert(
            ServicesCompanion.insert(
              name: 'Test Service',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      partId = await db.into(db.parts).insert(
            PartsCompanion.insert(
              name: 'Test Part',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    });

    tearDown(() async {
      await db.close();
    });

    test('create validates total/parts and persists with month totals', () async {
      final invalid = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 1, 1),
        currencyCode: 'EUR',
        totalAmount: 0,
      );
      expect(invalid.result, MaintenanceSaveResult.invalidTotal);

      final invalidPart = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 1, 1),
        currencyCode: 'EUR',
        parts: [
          MaintenancePartInput(partId: partId, quantity: 0, amount: 10),
        ],
      );
      expect(invalidPart.result, MaintenanceSaveResult.invalidPartQuantity);

      final ok = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 1, 2),
        currencyCode: 'EUR',
        totalAmount: 50,
        odometerKm: 12000,
        parts: [
          MaintenancePartInput(
            partId: partId,
            quantity: 2,
            amount: 15,
          ),
        ],
      );
      expect(ok.result, MaintenanceSaveResult.created);
      expect(ok.item?.totalAmount, 50);
      expect(ok.item?.odometerKm, 12000);

      final lines = await maintenances.partsForMaintenance(ok.item!.id);
      expect(lines, hasLength(1));
      expect(lines.single.quantity, 2);
      expect(lines.single.amount, 15);

      final totals = await maintenances.monthTotalsForCar(carId);
      // labor 50 + parts 2*15 = 80
      expect(totals[(2024, 1)], {'EUR': 80});
    });

    test('update replaces parts; delete removes maintenance row', () async {
      final created = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 3, 1),
        currencyCode: 'USD',
        totalAmount: 10,
        parts: [
          MaintenancePartInput(partId: partId, quantity: 1, amount: 5),
        ],
      );
      final id = created.item!.id;

      final updated = await maintenances.update(
        id: id,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 3, 2),
        currencyCode: 'USD',
        totalAmount: 20,
        parts: [
          MaintenancePartInput(partId: partId, quantity: 3, amount: 4),
        ],
      );
      expect(updated.result, MaintenanceSaveResult.updated);

      final lines = await maintenances.partsForMaintenance(id);
      expect(lines, hasLength(1));
      expect(lines.single.quantity, 3);
      expect(lines.single.amount, 4);

      final reminderId = await maintenances.delete(id);
      expect(reminderId, isNull);
      expect(await db.select(db.maintenances).get(), isEmpty);
    });

    test('create rejects invalid odometer and invalid part amount', () async {
      final badOdo = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 4, 1),
        currencyCode: 'EUR',
        odometerKm: -1,
      );
      expect(badOdo.result, MaintenanceSaveResult.invalidOdometer);

      final badAmount = await maintenances.create(
        carId: carId,
        serviceId: serviceId,
        servicedAt: DateTime(2024, 4, 1),
        currencyCode: 'EUR',
        parts: [
          MaintenancePartInput(partId: partId, quantity: 1, amount: 0),
        ],
      );
      expect(badAmount.result, MaintenanceSaveResult.invalidPartAmount);
    });
  });
}
