import '../repositories/fueling_repository.dart';

class DeleteFuelingUseCase {
  DeleteFuelingUseCase(this._fuelings);

  final FuelingRepository _fuelings;

  Future<void> call(int id) => _fuelings.delete(id);
}
