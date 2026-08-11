import '../../domain/usecases/car_write_usecases.dart';

/// Prepared fields for [SaveCarUseCase] create/update.
class CarFormPreparedInput {
  const CarFormPreparedInput({
    required this.brandName,
    this.model,
    this.year,
  });

  final String brandName;
  final String? model;
  final int? year;
}

class CarFormPrepareResult {
  const CarFormPrepareResult._({
    this.failure,
    this.yearInvalid = false,
    this.input,
  });

  const CarFormPrepareResult.fail(SaveCarFailure failure)
      : this._(failure: failure);

  const CarFormPrepareResult.yearInvalid() : this._(yearInvalid: true);

  const CarFormPrepareResult.ready(CarFormPreparedInput input)
      : this._(input: input);

  /// Use-case failure mirrored from prepare (e.g. [SaveCarFailure.emptyBrand]).
  final SaveCarFailure? failure;

  /// Presentation-only year parse error (not a [SaveCarFailure]).
  final bool yearInvalid;

  final CarFormPreparedInput? input;

  bool get isReady => input != null;
}

/// Parses and validates car form text fields into a [CarFormPreparedInput].
CarFormPrepareResult prepareCarSave({
  required String brandName,
  required String modelText,
  required String yearText,
}) {
  final brand = brandName.trim();
  if (brand.isEmpty) {
    return const CarFormPrepareResult.fail(SaveCarFailure.emptyBrand);
  }

  final model = modelText.trim();
  final yearTrimmed = yearText.trim();
  final year = yearTrimmed.isEmpty ? null : int.tryParse(yearTrimmed);
  if (yearTrimmed.isNotEmpty && year == null) {
    return const CarFormPrepareResult.yearInvalid();
  }

  return CarFormPrepareResult.ready(
    CarFormPreparedInput(
      brandName: brand,
      model: model.isEmpty ? null : model,
      year: year,
    ),
  );
}
