import 'package:flutter/foundation.dart';

import '../../domain/car_write_validation.dart';
import '../../domain/entities/car.dart';
import '../../domain/usecases/car_write_usecases.dart';
import '../../../../theme/car_theme_config.dart';
import 'car_form_prepare.dart';
import 'car_form_submit_outcome.dart';

export 'car_form_submit_outcome.dart';

/// Page-scoped car form session. No [WidgetRef] — page passes use cases.
class CarFormNotifier extends ChangeNotifier {
  CarFormNotifier({this.existing})
      : _photoBytes = existing?.photo,
        _colorArgb = existing?.colorArgb ??
            (existing == null ? kCarColorOptions.first.toARGB32() : null);

  final CarListItem? existing;

  Uint8List? _photoBytes;
  int? _colorArgb;
  bool brandError = false;
  bool _saving = false;

  Uint8List? get photoBytes => _photoBytes;
  int? get colorArgb => _colorArgb;
  bool get saving => _saving;
  bool get isEditing => existing != null;

  void setColorArgb(int? value) {
    _colorArgb = value;
    notifyListeners();
  }

  void clearPhoto() {
    _photoBytes = null;
    notifyListeners();
  }

  void clearBrandError() {
    if (!brandError) return;
    brandError = false;
    notifyListeners();
  }

  /// Applies picked gallery bytes after size check. Does not call ImagePicker.
  CarPhotoPickOutcome applyPickedPhoto(Uint8List? bytes) {
    if (bytes == null) {
      return const CarPhotoPickOutcome.cancelled();
    }
    if (isCarPhotoTooLarge(bytes)) {
      return const CarPhotoPickOutcome.tooLarge();
    }
    _photoBytes = bytes;
    notifyListeners();
    return const CarPhotoPickOutcome.success();
  }

  Future<CarFormSubmitOutcome> save({
    required String brandName,
    required String modelText,
    required String yearText,
    required SaveCarUseCase saveCar,
  }) async {
    if (_saving) return const CarFormSubmitOutcome.busy();

    final prepared = prepareCarSave(
      brandName: brandName,
      modelText: modelText,
      yearText: yearText,
    );
    if (prepared.yearInvalid) {
      return const CarFormSubmitOutcome.snack(CarFormSnack.yearInvalid());
    }
    final prepareFailure = prepared.failure;
    if (prepareFailure != null) {
      if (prepareFailure == SaveCarFailure.emptyBrand) {
        brandError = true;
        notifyListeners();
        return const CarFormSubmitOutcome.fieldError();
      }
      return CarFormSubmitOutcome.snack(CarFormSnack.save(prepareFailure));
    }

    final input = prepared.input!;
    brandError = false;
    _saving = true;
    notifyListeners();

    try {
      final result = existing == null
          ? await saveCar.create(
              rawBrandName: input.brandName,
              model: input.model,
              year: input.year,
              photo: _photoBytes,
              colorArgb: _colorArgb,
            )
          : await saveCar.update(
              id: existing!.id,
              rawBrandName: input.brandName,
              model: input.model,
              year: input.year,
              photo: _photoBytes,
              colorArgb: _colorArgb,
            );

      switch (result.failure) {
        case SaveCarFailure.emptyBrand:
          brandError = true;
          notifyListeners();
          return const CarFormSubmitOutcome.fieldError();
        case SaveCarFailure.limitReached:
          return const CarFormSubmitOutcome.snack(
            CarFormSnack.save(SaveCarFailure.limitReached),
          );
        case SaveCarFailure.photoTooLarge:
          return const CarFormSubmitOutcome.snack(
            CarFormSnack.save(SaveCarFailure.photoTooLarge),
          );
        case null:
          return const CarFormSubmitOutcome.success();
      }
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<CarFormSubmitOutcome> delete({
    required DeleteCarUseCase deleteCar,
  }) async {
    final item = existing;
    if (item == null || _saving) {
      return const CarFormSubmitOutcome.busy();
    }

    _saving = true;
    notifyListeners();
    try {
      final result = await deleteCar(item.id);
      if (result == CarDeleteResult.lastCar) {
        return const CarFormSubmitOutcome.snack(
          CarFormSnack.deleteLastBlocked(),
        );
      }
      return const CarFormSubmitOutcome.deleted();
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
