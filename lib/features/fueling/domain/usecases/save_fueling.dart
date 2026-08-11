import '../../../../shared/domain/transaction_abort.dart';
import '../../../../shared/domain/transaction_runner.dart';
import '../entities/fueling_save.dart';
import '../repositories/catalog_ports.dart';
import '../repositories/fueling_repository.dart';

/// Input for creating/updating a fueling after UI-side unit conversion.
class SaveFuelingInput {
  const SaveFuelingInput({
    required this.carId,
    required this.fuelTypeName,
    required this.fueledAt,
    required this.pricePerLiter,
    required this.liters,
    required this.totalAmount,
    required this.currencyCode,
    this.gasStationName,
    this.odometerKm,
    this.existingId,
  });

  final int carId;
  final String fuelTypeName;
  final String? gasStationName;
  final DateTime fueledAt;
  final double pricePerLiter;
  final double liters;
  final double totalAmount;
  final String currencyCode;
  final double? odometerKm;
  final int? existingId;

  bool get isEditing => existingId != null;
}

enum SaveFuelingFailure {
  emptyFuelType,
  gasStationEnsureFailed,
  invalidPrice,
  invalidQuantityOrTotal,
  invalidOdometer,
}

/// Maps repository validation codes to use-case failures (null = success).
SaveFuelingFailure? mapFuelingSaveResultToFailure(FuelingSaveResult result) {
  return switch (result) {
    FuelingSaveResult.created || FuelingSaveResult.updated => null,
    FuelingSaveResult.invalidPrice => SaveFuelingFailure.invalidPrice,
    FuelingSaveResult.invalidQuantityOrTotal =>
      SaveFuelingFailure.invalidQuantityOrTotal,
    FuelingSaveResult.invalidOdometer => SaveFuelingFailure.invalidOdometer,
  };
}

class SaveFuelingResult {
  const SaveFuelingResult._({this.failure, this.outcome});

  const SaveFuelingResult.ok(FuelingSaveOutcome outcome)
      : this._(outcome: outcome);

  const SaveFuelingResult.fail(SaveFuelingFailure failure)
      : this._(failure: failure);

  final SaveFuelingFailure? failure;
  final FuelingSaveOutcome? outcome;

  bool get isSuccess =>
      outcome != null &&
      (outcome!.result == FuelingSaveResult.created ||
          outcome!.result == FuelingSaveResult.updated);
}

/// Ensures catalog rows and persists a fueling.
class SaveFuelingUseCase {
  SaveFuelingUseCase({
    required FuelingRepository fuelingRepository,
    required FuelTypeEnsurer fuelTypeEnsurer,
    required GasStationEnsurer gasStationEnsurer,
    required TransactionRunner transactionRunner,
  })  : _fuelings = fuelingRepository,
        _fuelTypes = fuelTypeEnsurer,
        _gasStations = gasStationEnsurer,
        _tx = transactionRunner;

  final FuelingRepository _fuelings;
  final FuelTypeEnsurer _fuelTypes;
  final GasStationEnsurer _gasStations;
  final TransactionRunner _tx;

  Future<SaveFuelingResult> call(SaveFuelingInput input) async {
    final name = input.fuelTypeName.trim();
    if (name.isEmpty) {
      return const SaveFuelingResult.fail(SaveFuelingFailure.emptyFuelType);
    }

    try {
      return await _tx.runInTransaction(() async {
        final fuelType = await _fuelTypes.ensureForCar(name, input.carId);
        if (fuelType == null) {
          throw TransactionAbort<SaveFuelingResult>(
            const SaveFuelingResult.fail(SaveFuelingFailure.emptyFuelType),
          );
        }

        int? gasStationId;
        final stationName = input.gasStationName?.trim() ?? '';
        if (stationName.isNotEmpty) {
          gasStationId = await _gasStations.ensureFromInput(stationName);
          if (gasStationId == null) {
            throw TransactionAbort<SaveFuelingResult>(
              const SaveFuelingResult.fail(
                SaveFuelingFailure.gasStationEnsureFailed,
              ),
            );
          }
        }

        final outcome = input.isEditing
            ? await _fuelings.update(
                id: input.existingId!,
                fuelTypeId: fuelType.id,
                gasStationId: gasStationId,
                fueledAt: input.fueledAt,
                pricePerLiter: input.pricePerLiter,
                liters: input.liters,
                totalAmount: input.totalAmount,
                currencyCode: input.currencyCode,
                odometerKm: input.odometerKm,
              )
            : await _fuelings.create(
                carId: input.carId,
                fuelTypeId: fuelType.id,
                gasStationId: gasStationId,
                fueledAt: input.fueledAt,
                pricePerLiter: input.pricePerLiter,
                liters: input.liters,
                totalAmount: input.totalAmount,
                currencyCode: input.currencyCode,
                odometerKm: input.odometerKm,
              );

        final failure = mapFuelingSaveResultToFailure(outcome.result);
        if (failure == null) {
          return SaveFuelingResult.ok(outcome);
        }
        throw TransactionAbort<SaveFuelingResult>(
          SaveFuelingResult.fail(failure),
        );
      });
    } on TransactionAbort<SaveFuelingResult> catch (abort) {
      return abort.result;
    }
  }
}
