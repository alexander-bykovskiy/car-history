import 'dart:async';

import 'package:car_history/features/fueling/domain/repositories/fueling_repository.dart';
import 'package:car_history/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:car_history/features/statistics/data/merged_expenses_change_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFuelings implements FuelingRepository {
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> watchFuelingsChanges() => _controller.stream;

  void tick() => _controller.add(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMaintenances implements MaintenanceRepository {
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> watchMaintenancesChanges() => _controller.stream;

  void tick() => _controller.add(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('MergedExpensesChangeSource merges both change streams', () async {
    final fuelings = _FakeFuelings();
    final maintenances = _FakeMaintenances();
    final source = MergedExpensesChangeSource(
      fuelings: fuelings,
      maintenances: maintenances,
    );

    final events = <void>[];
    final sub = source.watchExpensesChanged().listen(events.add);

    fuelings.tick();
    maintenances.tick();
    await Future<void>.delayed(Duration.zero);

    expect(events, hasLength(2));
    await sub.cancel();
    await fuelings._controller.close();
    await maintenances._controller.close();
  });
}
