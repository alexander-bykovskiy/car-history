import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/named_catalog_item.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_list_page.dart';
import '../catalog_swipe_delete_tip.dart';
import '../widgets/named_catalog_name_dialog.dart';

class PartUnitsPage extends ConsumerWidget {
  const PartUnitsPage({super.key});

  Future<void> _openNameDialog(
    BuildContext context,
    WidgetRef ref, {
    NamedCatalogItem? existing,
  }) async {
    final l10n = AppLocalizations.of(context);
    await showPartUnitNameDialog(
      context: context,
      l10n: l10n,
      initialName: existing?.name ?? '',
      isEditing: existing != null,
      onSave: (name) async {
        final save = ref.read(savePartUnitUseCaseProvider);
        final outcome = existing == null
            ? await save.create(name)
            : await save.update(existing, name);
        return (result: outcome.result, restorable: outcome.item);
      },
      onRestore: (restorable) =>
          ref.read(restorePartUnitUseCaseProvider)(restorable),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(partUnitRepositoryProvider);
    final tip = watchCatalogSwipeDeleteTip(ref);

    return CatalogListPage<NamedCatalogItem>(
      title: l10n.partUnitsTitle,
      stream: repository.watchAll(),
      nameOf: (item) => item.name,
      idOf: (item) => item.id,
      isDeletedOf: (item) => item.isDeleted,
      deleteConfirmMessage: l10n.partUnitDeleteConfirm,
      dismissibleKeyPrefix: 'part-unit',
      showSwipeTip: tip.show,
      onDismissSwipeTip: tip.onDismiss,
      onDelete: (item) => ref.read(deletePartUnitUseCaseProvider)(item),
      onRestore: (item) => ref.read(restorePartUnitUseCaseProvider)(item),
      onAdd: () => _openNameDialog(context, ref),
      onEdit: (item) => _openNameDialog(context, ref, existing: item),
    );
  }
}
