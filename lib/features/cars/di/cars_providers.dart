import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../domain/entities/car.dart';
import '../domain/usecases/car_write_usecases.dart';

export '../../../app/di/app_providers.dart'
    show
        carRepositoryProvider,
        carBrandRepositoryProvider,
        selectedCarProvider,
        selectedCarServiceProvider;

final carsListProvider = StreamProvider<List<CarListItem>>((ref) {
  return ref.watch(carRepositoryProvider).watchAll();
});

final saveCarUseCaseProvider = Provider<SaveCarUseCase>((ref) {
  return SaveCarUseCase(
    carRepository: ref.watch(carRepositoryProvider),
    brandRepository: ref.watch(carBrandRepositoryProvider),
    transactionRunner: ref.watch(transactionRunnerProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
  );
});

final deleteCarUseCaseProvider = Provider<DeleteCarUseCase>((ref) {
  return DeleteCarUseCase(
    ref.watch(carRepositoryProvider),
    ref.watch(selectedCarServiceProvider),
  );
});
