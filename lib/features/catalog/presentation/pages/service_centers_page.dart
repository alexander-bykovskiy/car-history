import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/named_place.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_list_page.dart';
import '../catalog_swipe_delete_tip.dart';
import '../widgets/service_center_dialogs.dart';

/// Catalog list for service centers.
///
/// Runtime delete is always hard-delete (no event FKs). Soft-deleted rows
/// appear only after backup import; [onRestore] exists for that path.
class ServiceCentersPage extends ConsumerWidget {
  const ServiceCentersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(serviceCenterRepositoryProvider);
    final tip = watchCatalogSwipeDeleteTip(ref);

    return CatalogListPage<PlaceCatalogItem>(
      title: l10n.serviceCentersTitle,
      stream: repository.watchAll(),
      nameOf: (item) => item.name,
      idOf: (item) => item.id,
      isDeletedOf: (item) => item.isDeleted,
      subtitleOf: (item) => item.address,
      deleteConfirmMessage: l10n.serviceCenterDeleteConfirm,
      dismissibleKeyPrefix: 'service-center',
      showSwipeTip: tip.show,
      onDismissSwipeTip: tip.onDismiss,
      onDelete: (item) => ref.read(deleteServiceCenterUseCaseProvider)(item),
      onRestore: (item) => ref.read(restoreServiceCenterUseCaseProvider)(item),
      onAdd: () => showServiceCenterDialog(context),
      onEdit: (item) => showServiceCenterDialog(context, existing: item),
    );
  }
}
