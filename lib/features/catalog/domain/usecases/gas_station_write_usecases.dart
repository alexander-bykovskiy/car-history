import '../../../../shared/domain/transaction_runner.dart';
import '../entities/gas_station.dart';
import '../repositories/gas_station_repository.dart';

class SaveGasStationChainUseCase {
  SaveGasStationChainUseCase(this._repository);

  final GasStationRepository _repository;

  Future<GasStationChainSaveOutcome> create(String rawName) =>
      _repository.createChain(rawName);

  Future<GasStationChainSaveOutcome> update(
    GasStationChainItem current,
    String rawName,
  ) =>
      _repository.updateChain(current, rawName);
}

class RestoreGasStationChainUseCase {
  RestoreGasStationChainUseCase(this._repository, this._tx);

  final GasStationRepository _repository;
  final TransactionRunner _tx;

  /// Restores chain + cascade-soft-deleted locations in one transaction.
  Future<void> call(GasStationChainItem item, {String? name}) =>
      _tx.runInTransaction(
        () => _repository.restoreChain(item, name: name),
      );
}

class DeleteGasStationChainUseCase {
  DeleteGasStationChainUseCase(this._repository, this._tx);

  final GasStationRepository _repository;
  final TransactionRunner _tx;

  Future<void> call(GasStationChainItem item) =>
      _tx.runInTransaction(() => _repository.deleteChain(item));
}

class SaveGasStationLocationUseCase {
  SaveGasStationLocationUseCase(this._repository);

  final GasStationRepository _repository;

  Future<GasStationLocationSaveOutcome> create({
    required int chainId,
    String? address,
  }) =>
      _repository.createLocation(chainId: chainId, address: address);

  Future<GasStationLocationSaveOutcome> update(
    GasStationLocationItem current, {
    String? address,
  }) =>
      _repository.updateLocation(current, address: address);
}

class RestoreGasStationLocationUseCase {
  RestoreGasStationLocationUseCase(this._repository);

  final GasStationRepository _repository;

  Future<void> call(GasStationLocationItem item, {String? address}) =>
      _repository.restoreLocation(item, address: address);
}

class DeleteGasStationLocationUseCase {
  DeleteGasStationLocationUseCase(this._repository);

  final GasStationRepository _repository;

  Future<void> call(GasStationLocationItem item) =>
      _repository.deleteLocation(item);
}
