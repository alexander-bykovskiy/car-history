import '../entities/reminder.dart';

abstract class ReminderRepository {
  Stream<List<ReminderListItem>> watchAll();

  Stream<List<ReminderRecord>> watchActiveForCar(int carId);

  Stream<ReminderAlertLevel> watchAlertLevel(int carId);

  Future<ReminderRecord?> getById(int id);

  Future<ReminderSaveOutcome> create(ReminderInput input);

  Future<ReminderSaveOutcome> update(int id, ReminderInput input);

  Future<void> restore(int id);

  Future<void> delete(int id);
}
