import 'dart:typed_data';

import 'package:car_history/core/car_photo_limits.dart';
import 'package:car_history/features/cars/data/car_brand_repository_impl.dart';
import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/cars/data/car_selection_preferences.dart';
import 'package:car_history/features/cars/domain/entities/car.dart';
import 'package:car_history/features/cars/domain/entities/car_brand.dart';
import 'package:car_history/features/cars/domain/repositories/car_brand_repository.dart';
import 'package:car_history/features/cars/domain/repositories/car_repository.dart';
import 'package:car_history/features/cars/domain/selected_car_service.dart';
import 'package:car_history/features/cars/domain/usecases/car_write_usecases.dart';
import 'package:car_history/features/cars/presentation/controllers/car_form_notifier.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
import 'package:car_history/shared/domain/transaction_runner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CarFormNotifier', () {
    test('applyPickedPhoto rejects oversized bytes', () {
      final form = CarFormNotifier();
      final bytes = Uint8List(kMaxCarPhotoBytes + 1);
      expect(form.applyPickedPhoto(bytes), isA<CarPhotoPickTooLarge>());
      expect(form.photoBytes, isNull);
    });

    test('applyPickedPhoto accepts bytes within limit', () {
      final form = CarFormNotifier();
      final bytes = Uint8List.fromList([1, 2, 3]);
      expect(form.applyPickedPhoto(bytes), isA<CarPhotoPickSuccess>());
      expect(form.photoBytes, bytes);
    });

    test('save rejects empty brand', () async {
      SharedPreferences.setMockInitialValues({});
      final db = await openInMemoryDatabase();
      addTearDown(db.close);
      final cars = CarRepositoryImpl(db);
      final save = SaveCarUseCase(
        brandRepository: CarBrandRepositoryImpl(db),
        carRepository: cars,
        transactionRunner: DriftTransactionRunner(db),
        selectedCarService: SelectedCarService(
          carRepository: cars,
          selectionStore: PrefsCarSelectionStore(),
        ),
      );
      final form = CarFormNotifier();

      final outcome = await form.save(
        brandName: '  ',
        modelText: '',
        yearText: '',
        saveCar: save,
      );

      expect(outcome, isA<CarFormSubmitFieldError>());
      expect(form.brandError, isTrue);
    });

    test('save returns unexpected when use case throws', () async {
      SharedPreferences.setMockInitialValues({});
      final cars = _ThrowingCarRepository();
      final form = CarFormNotifier();
      final outcome = await form.save(
        brandName: 'Toyota',
        modelText: '',
        yearText: '',
        saveCar: SaveCarUseCase(
          brandRepository: _ThrowingBrandRepository(),
          carRepository: cars,
          transactionRunner: _PassthroughTx(),
          selectedCarService: SelectedCarService(
            carRepository: cars,
            selectionStore: PrefsCarSelectionStore(),
          ),
        ),
      );

      expect(outcome, isA<CarFormSubmitUnexpected>());
      expect(form.saving, isFalse);
    });

    test('delete returns unexpected when repository throws', () async {
      SharedPreferences.setMockInitialValues({});
      final cars = _ThrowingCarRepository();
      final form = CarFormNotifier(
        existing: const CarListItem(
          id: 1,
          brandId: 1,
          brandName: 'Toyota',
        ),
      );
      final outcome = await form.delete(
        deleteCar: DeleteCarUseCase(
          cars,
          SelectedCarService(
            carRepository: cars,
            selectionStore: PrefsCarSelectionStore(),
          ),
        ),
      );

      expect(outcome, isA<CarFormSubmitUnexpected>());
      expect(form.saving, isFalse);
    });
  });
}

class _PassthroughTx implements TransactionRunner {
  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) => action();
}

class _ThrowingBrandRepository implements CarBrandRepository {
  @override
  Future<CarBrandItem> findOrCreate(String rawName) {
    throw StateError('brand failed');
  }

  @override
  Future<CarBrandItem?> findByName(String rawName) => throw UnimplementedError();

  @override
  Future<List<CarBrandItem>> search(String query) => throw UnimplementedError();

  @override
  Stream<List<CarBrandItem>> watchAll() => throw UnimplementedError();
}

class _ThrowingCarRepository implements CarRepository {
  @override
  Future<int> count() async => 0;

  @override
  Future<CarCreateOutcome> create({
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) {
    throw StateError('create failed');
  }

  @override
  Future<CarUpdateResult> update({
    required int id,
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) {
    throw StateError('update failed');
  }

  @override
  Future<CarDeleteResult> delete(int id) {
    throw StateError('delete failed');
  }

  @override
  Future<List<CarListItem>> listAll() => throw UnimplementedError();

  @override
  Stream<List<CarListItem>> watchAll() => throw UnimplementedError();
}
