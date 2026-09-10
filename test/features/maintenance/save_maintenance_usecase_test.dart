import 'package:car_history/features/catalog/data/part_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/features/maintenance/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/maintenance/data/reminder_linker_adapter.dart';
import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/features/maintenance/domain/entities/maintenance_save.dart';
import 'package:car_history/features/maintenance/domain/entities/reminder_draft.dart';
import 'package:car_history/features/maintenance/domain/usecases/save_maintenance.dart';
import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SaveMaintenanceUseCase', () {
    late AppDatabase db;
    late SaveMaintenanceUseCase saveMaintenance;
    late int carId;

    setUp(() async {
      db = await openInMemoryDatabase();
      carId = (await db.select(db.cars).getSingle()).id;
      saveMaintenance = SaveMaintenanceUseCase(
        maintenanceRepository: MaintenanceRepositoryImpl(db),
        serviceEnsurer: ServiceEnsurerAdapter(ServiceRepositoryImpl(db)),
        partEnsurer: PartEnsurerAdapter(PartRepositoryImpl(db)),
        reminderLinker: ReminderLinkerAdapter(
          ReminderRepositoryImpl(db, odometerRepository: OdometerRepositoryImpl(db)),
        ),
        transactionRunner: DriftTransactionRunner(db),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('creates maintenance and ensures service', () async {
      final result = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Oil Change',
          servicedAt: DateTime(2024, 6, 1),
          totalAmount: 50,
          currencyCode: 'EUR',
        ),
      );
      expect(result.isSuccess, isTrue);
      expect(result.outcome?.result, MaintenanceSaveResult.created);
    });

    test('fails on empty service', () async {
      final result = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: ' ',
          servicedAt: DateTime(2024, 6, 1),
          currencyCode: 'EUR',
        ),
      );
      expect(result.failure, SaveMaintenanceFailure.emptyService);
    });

    test('rolls back reminder soft-delete when save fails', () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Brake Service',
          servicedAt: DateTime(2024, 6, 2),
          totalAmount: 80,
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(
            dueAt: DateTime(2024, 12, 1),
          ),
        ),
      );
      expect(created.isSuccess, isTrue);
      final maintenanceId = created.outcome!.item!.id;
      final reminderId = created.outcome!.item!.reminderId;
      expect(reminderId, isNotNull);

      final failed = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Brake Service',
          servicedAt: DateTime(2024, 6, 2),
          totalAmount: -1,
          currencyCode: 'EUR',
          reminderDraft: null,
          linkedReminderId: reminderId,
          existingId: maintenanceId,
        ),
      );
      expect(failed.failure, SaveMaintenanceFailure.invalidTotal);

      final reminder = await (db.select(db.reminders)
            ..where((t) => t.id.equals(reminderId!)))
          .getSingle();
      expect(reminder.isDeleted, isFalse);

      final maintenance = await (db.select(db.maintenances)
            ..where((t) => t.id.equals(maintenanceId)))
          .getSingle();
      expect(maintenance.reminderId, reminderId);
      expect(maintenance.totalAmount, 80);
    });

    test('creates maintenance with reminder and parts atomically', () async {
      final result = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Full Service',
          servicedAt: DateTime(2024, 7, 1),
          totalAmount: 100,
          currencyCode: 'EUR',
          parts: const [
            SaveMaintenancePartDraft(name: 'Oil Filter', quantity: 1, amount: 12),
          ],
          reminderDraft: ReminderDraft(dueOdometerKm: 15000),
        ),
      );
      expect(result.isSuccess, isTrue);
      final id = result.outcome!.item!.id;
      expect(result.outcome!.item!.reminderId, isNotNull);

      final parts = await MaintenanceRepositoryImpl(db).partsForMaintenance(id);
      expect(parts, hasLength(1));
      expect(parts.first.partName, 'Oil Filter');
    });

    test('fails on empty part name and rolls back', () async {
      final beforeServices = await db.select(db.services).get();
      final result = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Unique Rollback Service',
          servicedAt: DateTime(2024, 8, 1),
          currencyCode: 'EUR',
          parts: const [
            SaveMaintenancePartDraft(name: '  ', quantity: 1),
          ],
        ),
      );
      expect(result.failure, SaveMaintenanceFailure.emptyPart);
      final afterServices = await db.select(db.services).get();
      expect(afterServices.length, beforeServices.length);
      final maintenances = await db.select(db.maintenances).get();
      expect(
        maintenances.any((row) => row.servicedAt == DateTime(2024, 8, 1)),
        isFalse,
      );
    });

    test('aborts when reminder sync fails', () async {
      final before = await db.select(db.maintenances).get();
      final result = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Reminder Fail Service',
          servicedAt: DateTime(2024, 9, 1),
          currencyCode: 'EUR',
          // No dueAt / dueOdometerKm → ReminderRepository rejects empty trigger.
          reminderDraft: const ReminderDraft(),
        ),
      );
      expect(result.failure, SaveMaintenanceFailure.reminderSyncFailed);
      final after = await db.select(db.maintenances).get();
      expect(after.length, before.length);
      final reminders = await db.select(db.reminders).get();
      expect(
        reminders.any((row) => row.title == 'Reminder Fail Service'),
        isFalse,
      );
    });

    test('reminder sync preserves isCompleted on linked reminder', () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Completed Reminder Service',
          servicedAt: DateTime(2024, 7, 1),
          totalAmount: 40,
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(
            dueAt: DateTime(2024, 10, 1),
          ),
        ),
      );
      expect(created.isSuccess, isTrue);
      final reminderId = created.outcome?.item?.reminderId;
      expect(reminderId, isNotNull);

      final reminders = ReminderRepositoryImpl(
        db,
        odometerRepository: OdometerRepositoryImpl(db),
      );
      final marked = await reminders.update(
        reminderId!,
        ReminderInput(
          carId: carId,
          title: 'Completed Reminder Service',
          dueAt: DateTime(2024, 10, 1),
          isCompleted: true,
        ),
      );
      expect(marked.reminder?.isCompleted, isTrue);

      final maintenanceId = created.outcome!.item!.id;
      final updated = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          existingId: maintenanceId,
          serviceName: 'Completed Reminder Service',
          servicedAt: DateTime(2024, 7, 2),
          totalAmount: 45,
          currencyCode: 'EUR',
          linkedReminderId: reminderId,
          reminderDraft: ReminderDraft(
            reminderId: reminderId,
            dueAt: DateTime(2024, 11, 1),
          ),
        ),
      );
      expect(updated.isSuccess, isTrue);

      final after = await reminders.getById(reminderId);
      expect(after?.isCompleted, isTrue);
      expect(after?.dueAt, DateTime(2024, 11, 1));
    });

    test('edit with draft missing reminderId updates via linkedReminderId',
        () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Oil Change',
          servicedAt: DateTime(2024, 5, 1),
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(dueAt: DateTime(2024, 8, 1)),
        ),
      );
      expect(created.isSuccess, isTrue);
      final maintenanceId = created.outcome!.item!.id;
      final reminderId = created.outcome!.item!.reminderId!;

      final updated = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          existingId: maintenanceId,
          serviceName: 'Oil Change',
          servicedAt: DateTime(2024, 5, 2),
          currencyCode: 'EUR',
          linkedReminderId: reminderId,
          // Draft without reminderId — form used to drop it and create a duplicate.
          reminderDraft: ReminderDraft(dueAt: DateTime(2024, 9, 1)),
        ),
      );
      expect(updated.isSuccess, isTrue);
      expect(updated.outcome!.item!.reminderId, reminderId);

      final rows = await db.select(db.reminders).get();
      final active = rows.where((r) => !r.isDeleted).toList();
      expect(active, hasLength(1));
      expect(active.single.id, reminderId);
      expect(active.single.dueAt, DateTime(2024, 9, 1));
    });

    test('edit restores soft-deleted linked reminder instead of duplicating',
        () async {
      final created = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          serviceName: 'Filter',
          servicedAt: DateTime(2024, 4, 1),
          currencyCode: 'EUR',
          reminderDraft: ReminderDraft(dueAt: DateTime(2024, 6, 1)),
        ),
      );
      final reminderId = created.outcome!.item!.reminderId!;
      final maintenanceId = created.outcome!.item!.id;

      final reminders = ReminderRepositoryImpl(
        db,
        odometerRepository: OdometerRepositoryImpl(db),
      );
      await reminders.delete(reminderId);

      final updated = await saveMaintenance(
        SaveMaintenanceInput(
          carId: carId,
          existingId: maintenanceId,
          serviceName: 'Filter',
          servicedAt: DateTime(2024, 4, 2),
          currencyCode: 'EUR',
          linkedReminderId: reminderId,
          reminderDraft: ReminderDraft(
            reminderId: reminderId,
            dueAt: DateTime(2024, 7, 1),
          ),
        ),
      );
      expect(updated.isSuccess, isTrue);
      expect(updated.outcome!.item!.reminderId, reminderId);

      final rows = await db.select(db.reminders).get();
      expect(rows, hasLength(1));
      expect(rows.single.isDeleted, isFalse);
      expect(rows.single.dueAt, DateTime(2024, 7, 1));
    });
  });
}
