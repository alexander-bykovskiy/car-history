import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class SaveReminderUseCase {
  SaveReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<ReminderSaveOutcome> create(ReminderInput input) =>
      _repository.create(input);

  Future<ReminderSaveOutcome> update(int id, ReminderInput input) =>
      _repository.update(id, input);
}

class DeleteReminderUseCase {
  DeleteReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<void> call(int id) => _repository.delete(id);
}

class RestoreReminderUseCase {
  RestoreReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<void> call(int id) => _repository.restore(id);
}
