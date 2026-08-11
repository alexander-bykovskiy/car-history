import 'dart:typed_data';

import 'package:car_history/core/car_photo_limits.dart';
import 'package:car_history/features/cars/data/car_brand_repository_impl.dart';
import 'package:car_history/features/cars/data/car_repository_impl.dart';
import 'package:car_history/features/cars/data/car_selection_preferences.dart';
import 'package:car_history/features/cars/domain/selected_car_service.dart';
import 'package:car_history/features/cars/domain/usecases/car_write_usecases.dart';
import 'package:car_history/features/cars/presentation/controllers/car_form_notifier.dart';
import 'package:car_history/shared/data/drift_transaction_runner.dart';
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
  });
}
