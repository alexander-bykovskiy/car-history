import 'package:car_history/core/units.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/presentation/controllers/reminders_list_controller.dart';
import 'package:car_history/l10n/app_localizations_en.dart';
import 'package:car_history/shared/domain/odometer_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOdometerRepository implements OdometerRepository {
  _FakeOdometerRepository(this.odometers);

  final Map<int, double?> odometers;
  int loadCount = 0;

  @override
  Future<double?> maxOdometerKm(
    int carId, {
    int? excludingFuelingId,
    int? excludingMaintenanceId,
  }) async {
    loadCount++;
    return odometers[carId];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ReminderListItem _item({
  required int id,
  required String title,
  required int carId,
  DateTime? dueAt,
  bool isCompleted = false,
  bool isDeleted = false,
}) {
  return ReminderListItem(
    reminder: ReminderRecord(
      id: id,
      carId: carId,
      title: title,
      isCompleted: isCompleted,
      isDeleted: isDeleted,
      dueAt: dueAt,
    ),
    carLabel: 'Car $carId',
  );
}

void main() {
  test('onItemsChanged loads once for the same car-id set', () async {
    final controller = RemindersListController();
    final odometer = _FakeOdometerRepository({1: 12000});
    final items = [_item(id: 1, title: 'A', carId: 1)];

    controller.onItemsChanged(odometer, items);
    await Future<void>.delayed(Duration.zero);
    controller.onItemsChanged(odometer, items);
    await Future<void>.delayed(Duration.zero);

    expect(odometer.loadCount, 1);
    expect(controller.odometersByCar, {1: 12000});
    controller.dispose();
  });

  test('refreshOdometers reloads after invalidate', () async {
    final controller = RemindersListController();
    final odometer = _FakeOdometerRepository({1: 100});
    final items = [_item(id: 1, title: 'A', carId: 1)];

    controller.onItemsChanged(odometer, items);
    await Future<void>.delayed(Duration.zero);
    controller.refreshOdometers(odometer, items);
    await Future<void>.delayed(Duration.zero);

    expect(odometer.loadCount, 2);
    controller.dispose();
  });

  test('loadOdometers fills map and notifies', () async {
    final controller = RemindersListController();
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.loadOdometers(
      _FakeOdometerRepository({1: 12000, 2: null}),
      [1, 2],
    );

    expect(controller.odometersByCar, {1: 12000, 2: null});
    expect(notified, 1);
    controller.dispose();
  });

  test('markerLevel hides completed and surfaces due', () {
    final controller = RemindersListController();
    final now = DateTime(2026, 8, 10, 12);
    final due = ReminderRecord(
      id: 1,
      carId: 1,
      title: 'Due',
      isCompleted: false,
      isDeleted: false,
      dueAt: DateTime(2026, 8, 9),
    );
    final done = ReminderRecord(
      id: 2,
      carId: 1,
      title: 'Done',
      isCompleted: true,
      isDeleted: false,
      dueAt: DateTime(2026, 8, 9),
    );

    expect(controller.markerLevel(done, now: now), isNull);
    expect(controller.markerLevel(due, now: now), ReminderAlertLevel.due);
    controller.dispose();
  });

  test('detailsLine joins car, date, and odometer', () {
    final controller = RemindersListController();
    final l10n = AppLocalizationsEn();
    final line = controller.detailsLine(
      _item(
        id: 1,
        title: 'Service',
        carId: 1,
        dueAt: null,
      ).copyWithOdometer(5000),
      l10n: l10n,
      locale: 'en',
      unit: DistanceUnit.kilometers,
    );

    expect(line, 'Car 1 · 5000 km');
    controller.dispose();
  });

  test('sortedItems puts due ahead of far', () {
    final controller = RemindersListController();
    final now = DateTime(2026, 8, 10, 12);
    final due = _item(
      id: 1,
      title: 'B',
      carId: 1,
      dueAt: DateTime(2026, 8, 9),
    );
    final far = _item(
      id: 2,
      title: 'A',
      carId: 1,
      dueAt: DateTime(2026, 9, 1),
    );

    final sorted = controller.sortedItems([far, due], now: now);
    expect(sorted.first.reminder.id, 1);
    controller.dispose();
  });
}

extension on ReminderListItem {
  ReminderListItem copyWithOdometer(double km) {
    return ReminderListItem(
      reminder: ReminderRecord(
        id: reminder.id,
        carId: reminder.carId,
        title: reminder.title,
        isCompleted: reminder.isCompleted,
        isDeleted: reminder.isDeleted,
        dueAt: reminder.dueAt,
        dueOdometerKm: km,
        remindBeforeDays: reminder.remindBeforeDays,
        remindBeforeKm: reminder.remindBeforeKm,
      ),
      carLabel: carLabel,
    );
  }
}
