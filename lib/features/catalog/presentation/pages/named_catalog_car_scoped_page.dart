import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/named_catalog_item.dart';
import '../catalog_swipe_delete_tip.dart';
import '../widgets/named_catalog_car_bind_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_list_page.dart';

typedef NamedCatalogCarIdsLoader = Future<List<int>> Function(int id);

typedef NamedCatalogCarSubmit = Future<NamedCatalogSaveOutcome> Function({
  required NamedCatalogItem? existing,
  required String name,
  required List<int> carIds,
  required bool appliesToAll,
});

typedef NamedCatalogCarRestore = Future<void> Function(
  NamedCatalogItem item, {
  required List<int> carIds,
  required bool appliesToAll,
});

/// Shared list + car-bind dialog for fuel types / parts.
class NamedCatalogCarScopedPage extends ConsumerWidget {
  const NamedCatalogCarScopedPage({
    required this.title,
    required this.stream,
    required this.dismissibleKeyPrefix,
    required this.deleteConfirmMessage,
    required this.labels,
    required this.loadLinkedCarIds,
    required this.onSubmit,
    required this.onRestoreWithCars,
    required this.onDelete,
    required this.onRestore,
    super.key,
  });

  final String title;
  final Stream<List<NamedCatalogItem>> stream;
  final String dismissibleKeyPrefix;
  final String deleteConfirmMessage;
  final NamedCatalogCarBindLabels labels;
  final NamedCatalogCarIdsLoader loadLinkedCarIds;
  final NamedCatalogCarSubmit onSubmit;
  final NamedCatalogCarRestore onRestoreWithCars;
  final Future<void> Function(NamedCatalogItem item) onDelete;
  final Future<void> Function(NamedCatalogItem item) onRestore;

  Future<void> _openNameDialog(
    BuildContext context, {
    NamedCatalogItem? existing,
  }) async {
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return NamedCatalogCarBindDialog(
          existing: existing,
          labels: labels,
          loadLinkedCarIds: loadLinkedCarIds,
          onSubmit: onSubmit,
          onRestore: onRestoreWithCars,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tip = watchCatalogSwipeDeleteTip(ref);

    return CatalogListPage<NamedCatalogItem>(
      title: title,
      stream: stream,
      nameOf: (item) => item.name,
      idOf: (item) => item.id,
      isDeletedOf: (item) => item.isDeleted,
      deleteConfirmMessage: deleteConfirmMessage,
      dismissibleKeyPrefix: dismissibleKeyPrefix,
      showSwipeTip: tip.show,
      onDismissSwipeTip: tip.onDismiss,
      onDelete: onDelete,
      onRestore: onRestore,
      onAdd: () => _openNameDialog(context),
      onEdit: (item) => _openNameDialog(context, existing: item),
    );
  }
}

/// Builds [NamedCatalogCarBindLabels] from [AppLocalizations] for a catalog kind.
NamedCatalogCarBindLabels namedCatalogCarBindLabels({
  required AppLocalizations l10n,
  required String addTitle,
  required String editTitle,
  required String nameLabel,
  required String nameRequired,
  required String alreadyExists,
  required String restoreConfirm,
}) {
  return NamedCatalogCarBindLabels(
    addTitle: addTitle,
    editTitle: editTitle,
    nameLabel: nameLabel,
    nameRequired: nameRequired,
    alreadyExists: alreadyExists,
    restoreConfirm: restoreConfirm,
    carsRequired: l10n.catalogCarsRequired,
  );
}
