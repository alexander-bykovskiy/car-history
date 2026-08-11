import 'package:drift/drift.dart';

import '../../../core/reminder_alert_policy.dart';
import '../../../shared/data/db/app_database.dart';
import '../../../shared/domain/odometer_repository.dart';
import '../../../shared/domain/expenses_change_source.dart';
import '../domain/entities/reminder.dart';
import '../domain/reminder_write_validation.dart';
import '../domain/repositories/reminder_repository.dart';

ReminderRecord reminderRecordFromRow(Reminder row) {
  return ReminderRecord(
    id: row.id,
    carId: row.carId,
    title: row.title,
    dueAt: row.dueAt,
    dueOdometerKm: row.dueOdometerKm,
    remindBeforeDays: row.remindBeforeDays,
    remindBeforeKm: row.remindBeforeKm,
    isCompleted: row.isCompleted,
    isDeleted: row.isDeleted,
  );
}

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(
    this._db, {
    required OdometerRepository odometerRepository,
    ExpensesChangeSource? expensesChangeSource,
  })  : _odometer = odometerRepository,
        _expenses = expensesChangeSource;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final ExpensesChangeSource? _expenses;

  @override
  Stream<List<ReminderListItem>> watchAll() {
    final query = _db.select(_db.reminders).join([
      innerJoin(
        _db.cars,
        _db.cars.id.equalsExp(_db.reminders.carId),
      ),
      innerJoin(
        _db.carBrands,
        _db.carBrands.id.equalsExp(_db.cars.brandId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.reminders.isCompleted),
        OrderingTerm.asc(_db.reminders.isDeleted),
        OrderingTerm.desc(_db.reminders.dueAt),
        OrderingTerm.desc(_db.reminders.dueOdometerKm),
        OrderingTerm.asc(_db.reminders.title),
      ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final reminder = row.readTable(_db.reminders);
        final car = row.readTable(_db.cars);
        final brand = row.readTable(_db.carBrands);
        final label = [
          brand.name,
          if (car.model != null && car.model!.isNotEmpty) car.model!,
        ].join(' ');
        return ReminderListItem(
          reminder: reminderRecordFromRow(reminder),
          carLabel: label,
        );
      }).toList();
    });
  }

  @override
  Stream<List<ReminderRecord>> watchActiveForCar(int carId) {
    return (_db.select(_db.reminders)
          ..where(
            (t) =>
                t.carId.equals(carId) &
                t.isDeleted.equals(false) &
                t.isCompleted.equals(false),
          ))
        .watch()
        .map((rows) => rows.map(reminderRecordFromRow).toList());
  }

  @override
  Stream<ReminderAlertLevel> watchAlertLevel(int carId) {
    return Stream.multi((controller) {
      List<ReminderRecord> reminders = const [];
      var readyReminders = false;

      Future<void> emit() async {
        if (!readyReminders) return;
        final odometerKm = await _odometer.maxOdometerKm(carId);
        final level = highestReminderAlertLevel(
          reminders: reminders.map((r) => r.toAlertInput()).toList(),
          now: DateTime.now(),
          currentOdometerKm: odometerKm,
        );
        if (!controller.isClosed) controller.add(level);
      }

      final remSub = watchActiveForCar(carId).listen((rows) {
        reminders = rows;
        readyReminders = true;
        emit();
      });
      // Same expense invalidation path as statistics (fuelings + maintenances).
      final expenseSub = (_expenses?.watchExpensesChanged() ??
              const Stream<void>.empty())
          .listen((_) => emit());

      controller.onCancel = () async {
        await remSub.cancel();
        await expenseSub.cancel();
      };
    });
  }

  @override
  Future<ReminderRecord?> getById(int id) async {
    final row = await (_db.select(_db.reminders)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : reminderRecordFromRow(row);
  }

  @override
  Future<ReminderSaveOutcome> create(ReminderInput input) async {
    final validated = validateReminderWrite(
      title: input.title,
      dueAt: input.dueAt,
      dueOdometerKm: input.dueOdometerKm,
      remindBeforeDays: input.remindBeforeDays,
      remindBeforeKm: input.remindBeforeKm,
    );
    if (validated != null) {
      return ReminderSaveOutcome(validated);
    }

    final now = DateTime.now();
    final id = await _db.into(_db.reminders).insert(
          RemindersCompanion.insert(
            carId: input.carId,
            title: input.title.trim(),
            dueAt: Value(input.dueAt),
            dueOdometerKm: Value(input.dueOdometerKm),
            remindBeforeDays: Value(input.remindBeforeDays),
            remindBeforeKm: Value(input.remindBeforeKm),
            isCompleted: Value(input.isCompleted),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    final created = await getById(id);
    return ReminderSaveOutcome(
      ReminderSaveResult.created,
      reminder: created,
    );
  }

  @override
  Future<ReminderSaveOutcome> update(int id, ReminderInput input) async {
    final validated = validateReminderWrite(
      title: input.title,
      dueAt: input.dueAt,
      dueOdometerKm: input.dueOdometerKm,
      remindBeforeDays: input.remindBeforeDays,
      remindBeforeKm: input.remindBeforeKm,
    );
    if (validated != null) {
      return ReminderSaveOutcome(validated);
    }

    final now = DateTime.now();
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        carId: Value(input.carId),
        title: Value(input.title.trim()),
        dueAt: Value(input.dueAt),
        dueOdometerKm: Value(input.dueOdometerKm),
        remindBeforeDays: Value(input.remindBeforeDays),
        remindBeforeKm: Value(input.remindBeforeKm),
        isCompleted: Value(input.isCompleted),
        updatedAt: Value(now),
      ),
    );
    final updated = await getById(id);
    return ReminderSaveOutcome(
      ReminderSaveResult.updated,
      reminder: updated,
    );
  }

  @override
  Future<void> restore(int id) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

}
