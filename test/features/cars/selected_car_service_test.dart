import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/cars/data/car_selection_preferences.dart';
import 'package:car_history/features/cars/domain/entities/car.dart';
import 'package:car_history/features/cars/domain/selected_car_service.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/db/database_seed_texts.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late CarRepositoryImpl cars;
  late PrefsCarSelectionStore store;
  late SelectedCarService selected;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(
      executor: NativeDatabase.memory(),
      seeds: DatabaseSeedTexts.english,
    );
    await db.select(db.cars).get();
    cars = CarRepositoryImpl(db);
    store = PrefsCarSelectionStore();
    selected = SelectedCarService(
      carRepository: cars,
      selectionStore: store,
    );
  });

  tearDown(() async {
    store.dispose();
    await db.close();
  });

  test('resolves seeded car as selected', () async {
    final stream = selected.watchSelected();
    final item = await stream.first;
    expect(item, isNotNull);
    expect(await store.getSelectedCarId(), item!.id);
  });

  test('selectNext cycles when multiple cars exist', () async {
    final brand = await (db.select(db.carBrands)..limit(1)).getSingle();
    final first = (await cars.listAll()).first;
    final created = await cars.create(
      brandId: brand.id,
      model: 'Second',
    );
    expect(created.result, CarCreateResult.created);
    await selected.onCarCreated(created.id!, previousCount: 1);

    await selected.selectCar(first.id);
    await selected.selectNextCar();
    expect(await store.getSelectedCarId(), created.id);

    await selected.selectNextCar();
    expect(await store.getSelectedCarId(), first.id);
  });

  test('onCarDeleted moves selection to remaining car', () async {
    final brand = await (db.select(db.carBrands)..limit(1)).getSingle();
    final first = (await cars.listAll()).first;
    final created = await cars.create(
      brandId: brand.id,
      model: 'Spare',
    );
    await selected.selectCar(created.id!);
    expect(await cars.delete(created.id!), CarDeleteResult.deleted);
    await selected.onCarDeleted(created.id!);
    expect(await store.getSelectedCarId(), first.id);
  });
}
