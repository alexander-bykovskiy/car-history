import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import 'named_catalog_car_scoped_page.dart';

class FuelTypesPage extends ConsumerWidget {
  const FuelTypesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(fuelTypeRepositoryProvider);

    return NamedCatalogCarScopedPage(
      title: l10n.fuelTypesTitle,
      stream: repository.watchAll(),
      dismissibleKeyPrefix: 'fuel',
      deleteConfirmMessage: l10n.fuelTypeDeleteConfirm,
      labels: namedCatalogCarBindLabels(
        l10n: l10n,
        addTitle: l10n.fuelTypeAddTitle,
        editTitle: l10n.fuelTypeEditTitle,
        nameLabel: l10n.fuelTypeNameLabel,
        nameRequired: l10n.fuelTypeNameRequired,
        alreadyExists: l10n.fuelTypeAlreadyExists,
        restoreConfirm: l10n.fuelTypeRestoreConfirm,
      ),
      loadLinkedCarIds: repository.carIdsForFuelType,
      onSubmit: ({
        required existing,
        required name,
        required carIds,
        required appliesToAll,
      }) {
        final save = ref.read(saveFuelTypeUseCaseProvider);
        return existing == null
            ? save.create(
                name,
                carIds: carIds,
                appliesToAll: appliesToAll,
              )
            : save.update(
                existing,
                name,
                carIds: carIds,
                appliesToAll: appliesToAll,
              );
      },
      onRestoreWithCars: (item, {required carIds, required appliesToAll}) {
        return ref.read(restoreFuelTypeUseCaseProvider)(
          item,
          carIds: carIds,
          appliesToAll: appliesToAll,
        );
      },
      onDelete: (item) => ref.read(deleteFuelTypeUseCaseProvider)(item),
      onRestore: (item) => ref.read(restoreFuelTypeUseCaseProvider)(item),
    );
  }
}
