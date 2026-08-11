import 'dart:typed_data';

import '../../../../shared/domain/transaction_abort.dart';
import '../../../../shared/domain/transaction_runner.dart';
import '../entities/car.dart';
import '../repositories/car_brand_repository.dart';
import '../repositories/car_repository.dart';
import '../selected_car_service.dart';

enum SaveCarFailure { emptyBrand, limitReached, photoTooLarge }

class SaveCarResult {
  const SaveCarResult._({this.failure, this.createdId});

  const SaveCarResult.created(int id) : this._(createdId: id);

  const SaveCarResult.updated() : this._();

  const SaveCarResult.fail(SaveCarFailure failure) : this._(failure: failure);

  final SaveCarFailure? failure;
  final int? createdId;

  bool get isSuccess => failure == null;
}

class SaveCarUseCase {
  SaveCarUseCase({
    required CarRepository carRepository,
    required CarBrandRepository brandRepository,
    required TransactionRunner transactionRunner,
    required SelectedCarService selectedCarService,
  })  : _cars = carRepository,
        _brands = brandRepository,
        _tx = transactionRunner,
        _selected = selectedCarService;

  final CarRepository _cars;
  final CarBrandRepository _brands;
  final TransactionRunner _tx;
  final SelectedCarService _selected;

  Future<SaveCarResult> create({
    required String rawBrandName,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) async {
    final brandName = rawBrandName.trim();
    if (brandName.isEmpty) {
      return const SaveCarResult.fail(SaveCarFailure.emptyBrand);
    }

    final previousCount = await _cars.count();

    late final SaveCarResult result;
    try {
      result = await _tx.runInTransaction(() async {
        final brand = await _brands.findOrCreate(brandName);
        final outcome = await _cars.create(
          brandId: brand.id,
          model: model,
          year: year,
          photo: photo,
          colorArgb: colorArgb,
        );
        switch (outcome.result) {
          case CarCreateResult.created:
            return SaveCarResult.created(outcome.id!);
          case CarCreateResult.limitReached:
            throw TransactionAbort<SaveCarResult>(
              const SaveCarResult.fail(SaveCarFailure.limitReached),
            );
          case CarCreateResult.photoTooLarge:
            throw TransactionAbort<SaveCarResult>(
              const SaveCarResult.fail(SaveCarFailure.photoTooLarge),
            );
        }
      });
    } on TransactionAbort<SaveCarResult> catch (abort) {
      return abort.result;
    }

    final createdId = result.createdId;
    if (createdId != null) {
      await _selected.onCarCreated(createdId, previousCount: previousCount);
    }
    return result;
  }

  Future<SaveCarResult> update({
    required int id,
    required String rawBrandName,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) async {
    final brandName = rawBrandName.trim();
    if (brandName.isEmpty) {
      return const SaveCarResult.fail(SaveCarFailure.emptyBrand);
    }

    try {
      return await _tx.runInTransaction(() async {
        final brand = await _brands.findOrCreate(brandName);
        final outcome = await _cars.update(
          id: id,
          brandId: brand.id,
          model: model,
          year: year,
          photo: photo,
          colorArgb: colorArgb,
        );
        switch (outcome) {
          case CarUpdateResult.updated:
            return const SaveCarResult.updated();
          case CarUpdateResult.photoTooLarge:
            throw TransactionAbort<SaveCarResult>(
              const SaveCarResult.fail(SaveCarFailure.photoTooLarge),
            );
        }
      });
    } on TransactionAbort<SaveCarResult> catch (abort) {
      return abort.result;
    }
  }
}

class DeleteCarUseCase {
  DeleteCarUseCase(this._repository, this._selected);

  final CarRepository _repository;
  final SelectedCarService _selected;

  Future<CarDeleteResult> call(int id) async {
    final result = await _repository.delete(id);
    if (result == CarDeleteResult.deleted) {
      await _selected.onCarDeleted(id);
    }
    return result;
  }
}
