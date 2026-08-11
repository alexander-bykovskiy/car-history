import '../../../../shared/domain/transaction_runner.dart';
import '../repositories/maintenance_repository.dart';
import '../repositories/reminder_linker.dart';

class DeleteMaintenanceUseCase {
  DeleteMaintenanceUseCase({
    required MaintenanceRepository maintenanceRepository,
    required ReminderLinker reminderLinker,
    required TransactionRunner transactionRunner,
  })  : _maintenances = maintenanceRepository,
        _reminders = reminderLinker,
        _tx = transactionRunner;

  final MaintenanceRepository _maintenances;
  final ReminderLinker _reminders;
  final TransactionRunner _tx;

  Future<void> call(int id) {
    return _tx.runInTransaction(() async {
      final reminderId = await _maintenances.delete(id);
      if (reminderId != null) {
        await _reminders.delete(reminderId);
      }
    });
  }
}
