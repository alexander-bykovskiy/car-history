import '../../../../shared/domain/transaction_runner.dart';
import '../entities/named_catalog_item.dart';
import '../repositories/named_catalog_car_scoped_writes.dart';

class SaveNamedCatalogCarScopedUseCase {
  SaveNamedCatalogCarScopedUseCase(this._repository, this._tx);

  final NamedCatalogCarScopedWrites _repository;
  final TransactionRunner _tx;

  Future<NamedCatalogSaveOutcome> create(
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return _tx.runInTransaction(
      () => _repository.create(
        rawName,
        carIds: carIds,
        appliesToAll: appliesToAll,
      ),
    );
  }

  Future<NamedCatalogSaveOutcome> update(
    NamedCatalogItem current,
    String rawName, {
    required List<int> carIds,
    required bool appliesToAll,
  }) {
    return _tx.runInTransaction(
      () => _repository.update(
        current,
        rawName,
        carIds: carIds,
        appliesToAll: appliesToAll,
      ),
    );
  }
}

class RestoreNamedCatalogCarScopedUseCase {
  RestoreNamedCatalogCarScopedUseCase(this._repository, this._tx);

  final NamedCatalogCarScopedWrites _repository;
  final TransactionRunner _tx;

  Future<void> call(
    NamedCatalogItem item, {
    List<int>? carIds,
    bool appliesToAll = true,
  }) {
    return _tx.runInTransaction(
      () => _repository.restore(
        item,
        carIds: carIds,
        appliesToAll: appliesToAll,
      ),
    );
  }
}

class DeleteNamedCatalogCarScopedUseCase {
  DeleteNamedCatalogCarScopedUseCase(this._repository);

  final NamedCatalogCarScopedWrites _repository;

  Future<void> call(NamedCatalogItem item) => _repository.delete(item);
}

typedef SaveFuelTypeUseCase = SaveNamedCatalogCarScopedUseCase;
typedef RestoreFuelTypeUseCase = RestoreNamedCatalogCarScopedUseCase;
typedef DeleteFuelTypeUseCase = DeleteNamedCatalogCarScopedUseCase;

typedef SavePartUseCase = SaveNamedCatalogCarScopedUseCase;
typedef RestorePartUseCase = RestoreNamedCatalogCarScopedUseCase;
typedef DeletePartUseCase = DeleteNamedCatalogCarScopedUseCase;
