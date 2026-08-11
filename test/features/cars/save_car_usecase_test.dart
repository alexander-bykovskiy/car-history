import 'dart:typed_data';

import 'package:car_history/core/car_limits.dart';
import 'package:car_history/core/car_photo_limits.dart';
import 'package:car_history/features/cars/data/car_brand_repository_impl.dart';
import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/cars/data/car_selection_preferences.dart';
import 'package:car_history/features/cars/domain/entities/car.dart';
import 'package:car_history/features/cars/domain/selected_car_service.dart';
import 'package:car_history/features/cars/domain/usecases/car_write_usecases.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SaveCarUseCase', () {
    late AppDatabase db;
    late SaveCarUseCase saveCar;
    late CarBrandRepositoryImpl brands;
    late CarRepositoryImpl cars;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = await openInMemoryDatabase();
      brands = CarBrandRepositoryImpl(db);
      cars = CarRepositoryImpl(db);
      final selection = PrefsCarSelectionStore();
      saveCar = SaveCarUseCase(
        carRepository: cars,
        brandRepository: brands,
        transactionRunner: DriftTransactionRunner(db),
        selectedCarService: SelectedCarService(
          carRepository: cars,
          selectionStore: selection,
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('rolls back new brand when car limit is reached', () async {
      final seedBrand = await (db.select(db.carBrands)..limit(1)).getSingle();
      final existingCount = await db.select(db.cars).get();
      for (var i = existingCount.length; i < kMaxCars; i++) {
        final filled = await saveCar.create(
          rawBrandName: seedBrand.name,
          model: 'Fill-$i',
        );
        expect(filled.isSuccess, isTrue);
      }

      const orphanBrand = 'Orphan Brand XYZ';
      final limited = await saveCar.create(rawBrandName: orphanBrand);
      expect(limited.failure, SaveCarFailure.limitReached);
      expect(await brands.findByName(orphanBrand), isNull);

      final rows = await db.select(db.cars).get();
      expect(rows.length, kMaxCars);
    });

    test('rejects oversized photo on create and rolls back brand', () async {
      const orphanBrand = 'Photo Orphan Brand';
      final result = await saveCar.create(
        rawBrandName: orphanBrand,
        photo: Uint8List(kMaxCarPhotoBytes + 1),
      );
      expect(result.failure, SaveCarFailure.photoTooLarge);
      expect(await brands.findByName(orphanBrand), isNull);
    });

    test('rejects oversized photo on update', () async {
      final created = await saveCar.create(
        rawBrandName: 'Update Photo Brand',
        model: 'M',
      );
      expect(created.isSuccess, isTrue);
      final id = created.createdId!;

      final result = await saveCar.update(
        id: id,
        rawBrandName: 'Update Photo Brand',
        model: 'M',
        photo: Uint8List(kMaxCarPhotoBytes + 1),
      );
      expect(result.failure, SaveCarFailure.photoTooLarge);

      final stored = await cars.listAll();
      final row = stored.firstWhere((c) => c.id == id);
      expect(row.photo, isNull);
    });

    test('CarRepository create returns photoTooLarge without insert', () async {
      final brand = await brands.findOrCreate('Repo Photo Brand');
      final outcome = await cars.create(
        brandId: brand.id,
        photo: Uint8List(kMaxCarPhotoBytes + 1),
      );
      expect(outcome.result, CarCreateResult.photoTooLarge);
      expect(outcome.id, isNull);
    });
  });
}
