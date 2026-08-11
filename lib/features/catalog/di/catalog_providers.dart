import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../shared/domain/transaction_runner.dart';
import '../domain/usecases/catalog_write_usecases.dart';

/// Catalog write use-case wiring. Repository ports: see re-exports below.
export '../../../app/di/app_providers.dart'
    show
        fuelTypeRepositoryProvider,
        partRepositoryProvider,
        partUnitRepositoryProvider,
        serviceRepositoryProvider,
        serviceCenterRepositoryProvider,
        gasStationRepositoryProvider;

Provider<U> _fromRepo<R, U>(
  Provider<R> repoProvider,
  U Function(R repo) create,
) {
  return Provider((ref) => create(ref.watch(repoProvider)));
}

Provider<U> _fromRepoAndTx<R, U>(
  Provider<R> repoProvider,
  U Function(R repo, TransactionRunner tx) create,
) {
  return Provider(
    (ref) => create(
      ref.watch(repoProvider),
      ref.watch(transactionRunnerProvider),
    ),
  );
}

final saveFuelTypeUseCaseProvider =
    _fromRepoAndTx(fuelTypeRepositoryProvider, SaveFuelTypeUseCase.new);

final restoreFuelTypeUseCaseProvider =
    _fromRepoAndTx(fuelTypeRepositoryProvider, RestoreFuelTypeUseCase.new);

final deleteFuelTypeUseCaseProvider =
    _fromRepo(fuelTypeRepositoryProvider, DeleteFuelTypeUseCase.new);

final savePartUseCaseProvider =
    _fromRepoAndTx(partRepositoryProvider, SavePartUseCase.new);

final restorePartUseCaseProvider =
    _fromRepoAndTx(partRepositoryProvider, RestorePartUseCase.new);

final deletePartUseCaseProvider =
    _fromRepo(partRepositoryProvider, DeletePartUseCase.new);

final savePartUnitUseCaseProvider =
    _fromRepo(partUnitRepositoryProvider, SavePartUnitUseCase.new);

final restorePartUnitUseCaseProvider =
    _fromRepo(partUnitRepositoryProvider, RestorePartUnitUseCase.new);

final deletePartUnitUseCaseProvider =
    _fromRepo(partUnitRepositoryProvider, DeletePartUnitUseCase.new);

final saveServiceUseCaseProvider =
    _fromRepo(serviceRepositoryProvider, SaveServiceUseCase.new);

final restoreServiceUseCaseProvider =
    _fromRepo(serviceRepositoryProvider, RestoreServiceUseCase.new);

final deleteServiceUseCaseProvider =
    _fromRepo(serviceRepositoryProvider, DeleteServiceUseCase.new);

final saveServiceCenterUseCaseProvider =
    _fromRepo(serviceCenterRepositoryProvider, SaveServiceCenterUseCase.new);

final restoreServiceCenterUseCaseProvider =
    _fromRepo(serviceCenterRepositoryProvider, RestoreServiceCenterUseCase.new);

final deleteServiceCenterUseCaseProvider =
    _fromRepo(serviceCenterRepositoryProvider, DeleteServiceCenterUseCase.new);

final saveGasStationChainUseCaseProvider =
    _fromRepo(gasStationRepositoryProvider, SaveGasStationChainUseCase.new);

final restoreGasStationChainUseCaseProvider =
    _fromRepoAndTx(
      gasStationRepositoryProvider,
      RestoreGasStationChainUseCase.new,
    );

final deleteGasStationChainUseCaseProvider =
    _fromRepoAndTx(gasStationRepositoryProvider, DeleteGasStationChainUseCase.new);

final saveGasStationLocationUseCaseProvider =
    _fromRepo(gasStationRepositoryProvider, SaveGasStationLocationUseCase.new);

final restoreGasStationLocationUseCaseProvider =
    _fromRepo(gasStationRepositoryProvider, RestoreGasStationLocationUseCase.new);

final deleteGasStationLocationUseCaseProvider =
    _fromRepo(gasStationRepositoryProvider, DeleteGasStationLocationUseCase.new);
