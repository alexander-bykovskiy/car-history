import 'dart:async';

import '../../fueling/domain/repositories/fueling_repository.dart';
import '../../maintenance/domain/repositories/maintenance_repository.dart';
import '../../../shared/domain/expenses_change_source.dart';

/// Merges fueling + maintenance change streams for expense invalidation.
///
/// Lives in the statistics feature (composition of two feature ports), not in
/// `shared/`, so `shared` does not depend on feature repositories.
class MergedExpensesChangeSource implements ExpensesChangeSource {
  MergedExpensesChangeSource({
    required this.fuelings,
    required this.maintenances,
  });

  final FuelingRepository fuelings;
  final MaintenanceRepository maintenances;

  @override
  Stream<void> watchExpensesChanged() {
    return Stream.multi((controller) {
      final fuelSub = fuelings.watchFuelingsChanges().listen((_) {
        if (!controller.isClosed) controller.add(null);
      });
      final maintenanceSub =
          maintenances.watchMaintenancesChanges().listen((_) {
        if (!controller.isClosed) controller.add(null);
      });

      controller.onCancel = () async {
        await fuelSub.cancel();
        await maintenanceSub.cancel();
      };
    });
  }
}
