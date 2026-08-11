import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/presentation/service_icons.dart';
import '../../domain/entities/service_catalog_item.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_list_page.dart';
import '../catalog_swipe_delete_tip.dart';
import '../widgets/service_dialogs.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(serviceRepositoryProvider);
    final tip = watchCatalogSwipeDeleteTip(ref);

    return CatalogListPage<ServiceCatalogItem>(
      title: l10n.servicesTitle,
      stream: repository.watchAll(),
      nameOf: (item) => item.name,
      idOf: (item) => item.id,
      isDeletedOf: (item) => item.isDeleted,
      deleteConfirmMessage: l10n.serviceDeleteConfirm,
      dismissibleKeyPrefix: 'service',
      showSwipeTip: tip.show,
      onDismissSwipeTip: tip.onDismiss,
      leadingBuilder: (context, item) =>
          Icon(ServiceIcons.iconForKey(item.iconKey)),
      onDelete: (item) => ref.read(deleteServiceUseCaseProvider)(item),
      onRestore: (item) => ref.read(restoreServiceUseCaseProvider)(item),
      onAdd: () => showServiceNameDialog(context),
      onEdit: (item) => showServiceNameDialog(context, existing: item),
    );
  }
}
