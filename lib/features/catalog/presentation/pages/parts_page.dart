import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import 'named_catalog_car_scoped_page.dart';

class PartsPage extends ConsumerWidget {
  const PartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(partRepositoryProvider);

    return NamedCatalogCarScopedPage(
      title: l10n.partsTitle,
      stream: repository.watchAll(),
      dismissibleKeyPrefix: 'part',
      deleteConfirmMessage: l10n.partDeleteConfirm,
      labels: namedCatalogCarBindLabels(
        l10n: l10n,
        addTitle: l10n.partAddTitle,
        editTitle: l10n.partEditTitle,
        nameLabel: l10n.partNameLabel,
        nameRequired: l10n.partNameRequired,
        alreadyExists: l10n.partAlreadyExists,
        restoreConfirm: l10n.partRestoreConfirm,
      ),
      loadLinkedCarIds: repository.carIdsForPart,
      onSubmit: ({
        required existing,
        required name,
        required carIds,
        required appliesToAll,
      }) {
        final save = ref.read(savePartUseCaseProvider);
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
        return ref.read(restorePartUseCaseProvider)(
          item,
          carIds: carIds,
          appliesToAll: appliesToAll,
        );
      },
      onDelete: (item) => ref.read(deletePartUseCaseProvider)(item),
      onRestore: (item) => ref.read(restorePartUseCaseProvider)(item),
    );
  }
}
