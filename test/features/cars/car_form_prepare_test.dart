import 'package:car_history/features/cars/domain/usecases/car_write_usecases.dart';
import 'package:car_history/features/cars/presentation/controllers/car_form_prepare.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prepareCarSave', () {
    test('rejects empty brand', () {
      final result = prepareCarSave(
        brandName: '  ',
        modelText: 'X',
        yearText: '2020',
      );
      expect(result.failure, SaveCarFailure.emptyBrand);
      expect(result.isReady, isFalse);
    });

    test('rejects non-numeric year', () {
      final result = prepareCarSave(
        brandName: 'Toyota',
        modelText: 'Camry',
        yearText: 'abc',
      );
      expect(result.yearInvalid, isTrue);
      expect(result.isReady, isFalse);
    });

    test('allows empty year and model', () {
      final result = prepareCarSave(
        brandName: ' Toyota ',
        modelText: '  ',
        yearText: '',
      );
      expect(result.isReady, isTrue);
      expect(result.input!.brandName, 'Toyota');
      expect(result.input!.model, isNull);
      expect(result.input!.year, isNull);
    });

    test('parses year and model', () {
      final result = prepareCarSave(
        brandName: 'BMW',
        modelText: ' X5 ',
        yearText: '2018',
      );
      expect(result.isReady, isTrue);
      expect(result.input!.brandName, 'BMW');
      expect(result.input!.model, 'X5');
      expect(result.input!.year, 2018);
    });
  });
}
