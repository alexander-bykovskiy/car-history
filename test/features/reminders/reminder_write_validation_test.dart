import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/domain/reminder_write_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validateReminderWrite rejects empty title and trigger', () {
    expect(
      validateReminderWrite(title: '  ', dueAt: DateTime(2024)),
      ReminderSaveResult.emptyTitle,
    );
    expect(
      validateReminderWrite(title: 'Oil'),
      ReminderSaveResult.emptyTrigger,
    );
  });

  test('validateReminderWrite rejects invalid remind-before', () {
    expect(
      validateReminderWrite(
        title: 'Oil',
        dueAt: DateTime(2024),
        remindBeforeDays: -1,
      ),
      ReminderSaveResult.invalidRemindBefore,
    );
    expect(
      validateReminderWrite(
        title: 'Oil',
        dueOdometerKm: 1000,
        remindBeforeKm: -5,
      ),
      ReminderSaveResult.invalidRemindBefore,
    );
    expect(
      validateReminderWrite(
        title: 'Oil',
        dueOdometerKm: 1000,
        remindBeforeDays: 7,
      ),
      ReminderSaveResult.invalidRemindBefore,
    );
  });

  test('validateReminderWrite rejects negative due odometer', () {
    expect(
      validateReminderWrite(
        title: 'Oil',
        dueOdometerKm: -1,
      ),
      ReminderSaveResult.invalidOdometer,
    );
  });

  test('validateReminderWrite accepts valid date and/or odometer', () {
    expect(
      validateReminderWrite(title: 'Oil', dueAt: DateTime(2024)),
      isNull,
    );
    expect(
      validateReminderWrite(title: 'Oil', dueOdometerKm: 12000),
      isNull,
    );
    expect(
      validateReminderWrite(
        title: 'Oil',
        dueAt: DateTime(2024),
        dueOdometerKm: 12000,
        remindBeforeDays: 7,
        remindBeforeKm: 500,
      ),
      isNull,
    );
  });
}
