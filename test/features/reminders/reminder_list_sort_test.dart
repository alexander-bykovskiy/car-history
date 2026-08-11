import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/domain/reminder_list_sort.dart';
import 'package:flutter_test/flutter_test.dart';

ReminderListItem _item({
  required int id,
  required String title,
  required int carId,
  bool isCompleted = false,
  bool isDeleted = false,
  DateTime? dueAt,
  double? dueOdometerKm,
  int? remindBeforeDays,
  double? remindBeforeKm,
}) {
  return ReminderListItem(
    reminder: ReminderRecord(
      id: id,
      carId: carId,
      title: title,
      isCompleted: isCompleted,
      isDeleted: isDeleted,
      dueAt: dueAt,
      dueOdometerKm: dueOdometerKm,
      remindBeforeDays: remindBeforeDays,
      remindBeforeKm: remindBeforeKm,
    ),
    carLabel: 'Car $carId',
  );
}

void main() {
  final now = DateTime(2026, 8, 10, 12);

  test('sorts due → soon → none → completed → deleted', () {
    final due = _item(
      id: 1,
      title: 'B due',
      carId: 1,
      dueAt: DateTime(2026, 8, 9),
    );
    final soon = _item(
      id: 2,
      title: 'A soon',
      carId: 1,
      dueAt: DateTime(2026, 8, 15),
      remindBeforeDays: 7,
    );
    final none = _item(
      id: 3,
      title: 'C far',
      carId: 1,
      dueAt: DateTime(2026, 9, 1),
      remindBeforeDays: 7,
    );
    final completed = _item(
      id: 4,
      title: 'Done',
      carId: 1,
      isCompleted: true,
      dueAt: DateTime(2026, 8, 1),
    );
    final deleted = _item(
      id: 5,
      title: 'Gone',
      carId: 1,
      isDeleted: true,
      dueAt: DateTime(2026, 8, 1),
    );

    final sorted = [deleted, completed, none, soon, due]
      ..sort(
        (a, b) => compareRemindersByAlertPriority(
          a,
          b,
          now: now,
          odometersByCar: const {1: 1000},
        ),
      );

    expect(
      sorted.map((e) => e.reminder.id).toList(),
      [1, 2, 3, 4, 5],
    );
  });
}
