import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../data/catalog_ensurer_adapters.dart';
import '../domain/repositories/catalog_ports.dart';
import '../domain/usecases/delete_fueling.dart';
import '../domain/usecases/save_fueling.dart';

export '../../../app/di/app_providers.dart'
    show
        fuelingRepositoryProvider,
        fuelTypeRepositoryProvider,
        gasStationRepositoryProvider,
        odometerRepositoryProvider;

final fuelTypeEnsurerProvider = Provider<FuelTypeEnsurer>((ref) {
  return FuelTypeEnsurerAdapter(ref.watch(fuelTypeRepositoryProvider));
});

final gasStationEnsurerProvider = Provider<GasStationEnsurer>((ref) {
  return GasStationEnsurerAdapter(ref.watch(gasStationRepositoryProvider));
});

final saveFuelingUseCaseProvider = Provider<SaveFuelingUseCase>((ref) {
  return SaveFuelingUseCase(
    fuelingRepository: ref.watch(fuelingRepositoryProvider),
    fuelTypeEnsurer: ref.watch(fuelTypeEnsurerProvider),
    gasStationEnsurer: ref.watch(gasStationEnsurerProvider),
    transactionRunner: ref.watch(transactionRunnerProvider),
  );
});

final deleteFuelingUseCaseProvider = Provider<DeleteFuelingUseCase>((ref) {
  return DeleteFuelingUseCase(ref.watch(fuelingRepositoryProvider));
});
