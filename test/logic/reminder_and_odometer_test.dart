import 'package:car_history/core/odometer_sequence.dart';
import 'package:car_history/core/reminder_alert_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('reminderAlertLevelFor', () {
    final now = DateTime(2026, 8, 5, 12);

    test('completed or deleted → none', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: true,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 1),
          ),
          now: now,
          currentOdometerKm: null,
        ),
        ReminderAlertLevel.none,
      );
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: true,
            dueAt: DateTime(2026, 8, 1),
          ),
          now: now,
          currentOdometerKm: null,
        ),
        ReminderAlertLevel.none,
      );
    });

    test('date due today or past → due', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 5),
          ),
          now: now,
          currentOdometerKm: null,
        ),
        ReminderAlertLevel.due,
      );
    });

    test('date within remindBeforeDays → soon', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 10),
            remindBeforeDays: 7,
          ),
          now: now,
          currentOdometerKm: null,
        ),
        ReminderAlertLevel.soon,
      );
    });

    test('date far → none', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 9, 1),
            remindBeforeDays: 7,
          ),
          now: now,
          currentOdometerKm: null,
        ),
        ReminderAlertLevel.none,
      );
    });

    test('odometer due → due', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueOdometerKm: 10000,
          ),
          now: now,
          currentOdometerKm: 10000,
        ),
        ReminderAlertLevel.due,
      );
    });

    test('odometer within remindBeforeKm → soon', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueOdometerKm: 10000,
            remindBeforeKm: 500,
          ),
          now: now,
          currentOdometerKm: 9600,
        ),
        ReminderAlertLevel.soon,
      );
    });

    test('date soon + odometer due → due wins', () {
      expect(
        reminderAlertLevelFor(
          reminder: ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 10),
            remindBeforeDays: 7,
            dueOdometerKm: 10000,
          ),
          now: now,
          currentOdometerKm: 10000,
        ),
        ReminderAlertLevel.due,
      );
    });
  });

  group('highestReminderAlertLevel', () {
    final now = DateTime(2026, 8, 5);

    test('due wins over soon', () {
      final level = highestReminderAlertLevel(
        reminders: [
          ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 10),
            remindBeforeDays: 7,
          ),
          ReminderAlertInput(
            isCompleted: false,
            isDeleted: false,
            dueAt: DateTime(2026, 8, 1),
          ),
        ],
        now: now,
        currentOdometerKm: null,
      );
      expect(level, ReminderAlertLevel.due);
    });
  });

  group('checkOdometerSequence', () {
    test('no neighbors → no warning', () {
      final result = checkOdometerSequence(
        odometerKm: 1000,
        neighbors: const OdometerNeighbors(),
      );
      expect(result.hasWarning, isFalse);
    });

    test('lower than earlier → warning', () {
      final result = checkOdometerSequence(
        odometerKm: 900,
        neighbors: const OdometerNeighbors(previousKm: 1000),
      );
      expect(result.lowerThanEarlier, isTrue);
      expect(result.higherThanLater, isFalse);
    });

    test('higher than later → warning', () {
      final result = checkOdometerSequence(
        odometerKm: 1200,
        neighbors: const OdometerNeighbors(nextKm: 1100),
      );
      expect(result.lowerThanEarlier, isFalse);
      expect(result.higherThanLater, isTrue);
    });

    test('equal to neighbors → no warning', () {
      final result = checkOdometerSequence(
        odometerKm: 1000,
        neighbors: const OdometerNeighbors(previousKm: 1000, nextKm: 1000),
      );
      expect(result.hasWarning, isFalse);
    });
  });
}

