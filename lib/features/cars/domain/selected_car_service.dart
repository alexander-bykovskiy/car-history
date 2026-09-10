import 'dart:async';

import 'entities/car.dart';
import 'repositories/car_repository.dart';
import 'repositories/car_selection_store.dart';

/// Resolves the selected [CarListItem] from the car list + [CarSelectionStore].
class SelectedCarService {
  SelectedCarService({
    required CarRepository carRepository,
    required CarSelectionStore selectionStore,
  })  : _cars = carRepository,
        _store = selectionStore;

  final CarRepository _cars;
  final CarSelectionStore _store;

  Stream<CarListItem?> watchSelected() {
    return Stream.multi((controller) {
      Future<void> emit(List<CarListItem> items) async {
        final resolved = await _resolveSelected(items);
        if (!controller.isClosed) controller.add(resolved);
      }

      final carsSub = _cars.watchAll().listen(emit);
      final tickSub = _store.changes.listen((_) async {
        await emit(await _cars.listAll());
      });

      controller.onCancel = () async {
        await carsSub.cancel();
        await tickSub.cancel();
      };
    });
  }

  Future<CarListItem?> _resolveSelected(List<CarListItem> items) async {
    if (items.isEmpty) return null;
    final selectedId = await _store.getSelectedCarId();
    if (selectedId != null) {
      for (final item in items) {
        if (item.id == selectedId) return item;
      }
    }
    final first = items.first;
    await _store.setSelectedCarId(first.id);
    return first;
  }

  Future<void> selectCar(int id) => _store.setSelectedCarId(id);

  Future<void> selectNextCar() async {
    final items = await _cars.listAll();
    if (items.length <= 1) return;

    final selectedId = await _store.getSelectedCarId();
    final index = items.indexWhere((item) => item.id == selectedId);
    final nextIndex = index < 0 ? 0 : (index + 1) % items.length;
    await selectCar(items[nextIndex].id);
  }

  Future<void> onCarCreated(int id, {required int previousCount}) async {
    if (previousCount == 0) {
      await _store.setSelectedCarId(id);
    }
  }

  Future<void> onCarDeleted(int deletedId) async {
    final selectedId = await _store.getSelectedCarId();
    if (selectedId != deletedId) return;

    final remaining = await _cars.listAll();
    if (remaining.isEmpty) {
      await _store.clearSelectedCarId();
    } else {
      await _store.setSelectedCarId(remaining.first.id);
    }
  }
}
