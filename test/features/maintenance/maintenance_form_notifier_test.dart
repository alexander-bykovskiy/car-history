import 'package:car_history/core/units.dart';
import 'package:car_history/features/catalog/data/part_repository_impl.dart';
import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/features/maintenance/data/catalog_ensurer_adapters.dart';
import 'package:car_history/features/maintenance/data/reminder_linker_adapter.dart';
import 'package:car_history/features/maintenance/data/maintenance_repository_impl.dart';
import 'package:car_history/features/maintenance/domain/usecases/save_maintenance.dart';
import 'package:car_history/features/maintenance/presentation/controllers/maintenance_form_notifier.dart';
import 'package:car_history/features/maintenance/presentation/models/draft_part_line.dart';
import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MaintenanceFormNotifier', () {
    test('submit returns fieldError for empty service without writing',
        () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final carId = (await db.select(db.cars).getSingle()).id;
      final odometer = OdometerRepositoryImpl(db);
      final save = SaveMaintenanceUseCase(
        maintenanceRepository: MaintenanceRepositoryImpl(db),
        serviceEnsurer: ServiceEnsurerAdapter(ServiceRepositoryImpl(db)),
        partEnsurer: PartEnsurerAdapter(PartRepositoryImpl(db)),
        reminderLinker: ReminderLinkerAdapter(
          ReminderRepositoryImpl(db, odometerRepository: odometer),
        ),
        transactionRunner: DriftTransactionRunner(db),
      );
      final form = MaintenanceFormNotifier(
        carId: carId,
        distanceUnit: DistanceUnit.kilometers,
        currencyCode: 'EUR',
        existing: null,
        deleteId: null,
        initialServiceName: null,
      );
      addTearDown(form.dispose);

      final outcome = await form.submit(
        save: save,
        odometer: odometer,
        serviceName: '',
        totalText: '',
        odometerText: '',
        confirmOdometer: (_) async => true,
      );

      expect(outcome, isA<MaintenanceFormSubmitFieldError>());
      expect(
        (outcome as MaintenanceFormSubmitFieldError).error,
        SaveMaintenanceFailure.emptyService,
      );
      expect(form.serviceError, SaveMaintenanceFailure.emptyService);
      expect(await db.select(db.maintenances).get(), isEmpty);
    });

    test('submit returns snack for prepare part quantity failure', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final carId = (await db.select(db.cars).getSingle()).id;
      final odometer = OdometerRepositoryImpl(db);
      final save = SaveMaintenanceUseCase(
        maintenanceRepository: MaintenanceRepositoryImpl(db),
        serviceEnsurer: ServiceEnsurerAdapter(ServiceRepositoryImpl(db)),
        partEnsurer: PartEnsurerAdapter(PartRepositoryImpl(db)),
        reminderLinker: ReminderLinkerAdapter(
          ReminderRepositoryImpl(db, odometerRepository: odometer),
        ),
        transactionRunner: DriftTransactionRunner(db),
      );
      final form = MaintenanceFormNotifier(
        carId: carId,
        distanceUnit: DistanceUnit.kilometers,
        currencyCode: 'EUR',
        existing: null,
        deleteId: null,
        initialServiceName: null,
      );
      addTearDown(form.dispose);

      form.upsertPart(
        const DraftPartLine(
          localId: 1,
          name: 'Oil filter',
          quantity: 0,
        ),
      );

      final outcome = await form.submit(
        save: save,
        odometer: odometer,
        serviceName: 'Oil change',
        totalText: '',
        odometerText: '',
        confirmOdometer: (_) async => true,
      );

      expect(outcome, isA<MaintenanceFormSubmitSnack>());
      expect(
        (outcome as MaintenanceFormSubmitSnack).error,
        SaveMaintenanceFailure.invalidPartQuantity,
      );
      expect(form.serviceError, isNull);
      expect(await db.select(db.maintenances).get(), isEmpty);
    });
  });
}
