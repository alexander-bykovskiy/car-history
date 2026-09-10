import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:car_history/features/reminders/domain/usecases/reminder_write_usecases.dart';
import 'package:car_history/features/reminders/presentation/controllers/reminder_form_notifier.dart';
import 'package:car_history/core/units.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReminderFormNotifier', () {
    test('save happy path creates reminder', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final carId = (await db.select(db.cars).getSingle()).id;
      final save = SaveReminderUseCase(
        ReminderRepositoryImpl(
          db,
          odometerRepository: OdometerRepositoryImpl(db),
        ),
      );
      final form = ReminderFormNotifier(
        existing: null,
        distanceUnit: DistanceUnit.kilometers,
        initialCarId: carId,
      );

      final outcome = await form.save(
        titleText: 'Oil due',
        remindBeforeDaysText: '',
        odometerText: '',
        remindBeforeKmText: '',
        saveUseCase: save,
      );

      expect(outcome, isA<ReminderFormSubmitSuccess>());
      expect(form.saving, isFalse);
      final rows = await db.select(db.reminders).get();
      expect(rows.any((r) => r.title == 'Oil due'), isTrue);
    });

    test('save rejects empty title', () async {
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final carId = (await db.select(db.cars).getSingle()).id;
      final save = SaveReminderUseCase(
        ReminderRepositoryImpl(
          db,
          odometerRepository: OdometerRepositoryImpl(db),
        ),
      );
      final form = ReminderFormNotifier(
        existing: null,
        distanceUnit: DistanceUnit.kilometers,
        initialCarId: carId,
      );

      final outcome = await form.save(
        titleText: '  ',
        remindBeforeDaysText: '',
        odometerText: '',
        remindBeforeKmText: '',
        saveUseCase: save,
      );

      expect(outcome, isA<ReminderFormSubmitFieldError>());
      expect(form.titleError, ReminderFormTitleError.required);
    });

    test('save returns unexpected when use case throws', () async {
      final form = ReminderFormNotifier(
        existing: null,
        distanceUnit: DistanceUnit.kilometers,
        initialCarId: 1,
      );

      final outcome = await form.save(
        titleText: 'Oil due',
        remindBeforeDaysText: '',
        odometerText: '',
        remindBeforeKmText: '',
        saveUseCase: SaveReminderUseCase(_ThrowingReminderRepository()),
      );

      expect(outcome, isA<ReminderFormSubmitUnexpected>());
      expect(form.saving, isFalse);
    });

    test('delete returns unexpected when repository throws', () async {
      final form = ReminderFormNotifier(
        existing: const ReminderRecord(
          id: 42,
          carId: 1,
          title: 'Oil due',
          dueAt: null,
          dueOdometerKm: null,
          remindBeforeDays: null,
          remindBeforeKm: null,
          isCompleted: false,
          isDeleted: false,
        ),
        distanceUnit: DistanceUnit.kilometers,
      );

      final outcome = await form.delete(
        DeleteReminderUseCase(_ThrowingReminderRepository()),
      );

      expect(outcome, isA<ReminderFormSubmitUnexpected>());
      expect(form.saving, isFalse);
    });
  });
}

class _ThrowingReminderRepository implements ReminderRepository {
  @override
  Future<ReminderSaveOutcome> create(ReminderInput input) {
    throw StateError('create failed');
  }

  @override
  Future<ReminderSaveOutcome> update(int id, ReminderInput input) {
    throw StateError('update failed');
  }

  @override
  Future<void> delete(int id) => throw UnimplementedError();

  @override
  Future<ReminderRecord?> getById(int id) => throw UnimplementedError();

  @override
  Future<void> restore(int id) => throw UnimplementedError();

  @override
  Stream<List<ReminderListItem>> watchAll() => throw UnimplementedError();

  @override
  Stream<List<ReminderRecord>> watchActiveForCar(int carId) {
    throw UnimplementedError();
  }

  @override
  Stream<ReminderAlertLevel> watchAlertLevel(int carId) {
    throw UnimplementedError();
  }
}
