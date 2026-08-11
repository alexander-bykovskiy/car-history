import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gas_station.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_list_page.dart';
import '../catalog_swipe_delete_tip.dart';
import '../widgets/gas_station_dialogs.dart';
import 'gas_station_detail_page.dart';

class GasStationsPage extends ConsumerWidget {
  const GasStationsPage({super.key});

  Future<void> _openDetail(BuildContext context, {required int chainId}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GasStationDetailPage(chainId: chainId),
      ),
    );
  }

  Future<void> _createChain(BuildContext context) async {
    final chain = await showGasStationChainDialog(context);
    if (chain == null || !context.mounted) return;
    await _openDetail(context, chainId: chain.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(gasStationRepositoryProvider);
    final tip = watchCatalogSwipeDeleteTip(ref);

    return CatalogListPage<GasStationChainWithLocations>(
      title: l10n.gasStationsTitle,
      stream: repository.watchChainsWithLocations(),
      nameOf: (item) => item.chain.name,
      idOf: (item) => item.chain.id,
      isDeletedOf: (item) => item.chain.isDeleted,
      deleteConfirmMessage: l10n.gasStationDeleteConfirm,
      dismissibleKeyPrefix: 'gas-chain',
      showSwipeTip: tip.show,
      onDismissSwipeTip: tip.onDismiss,
      trailingBuilder: (context, item) {
        if (item.chain.isDeleted) return null;
        final addressCount = item.locations
            .where(
              (l) =>
                  !l.isDeleted && (l.address?.trim().isNotEmpty ?? false),
            )
            .length;
        if (addressCount == 0) return null;
        final theme = Theme.of(context);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.place_outlined,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '$addressCount',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
      onDelete: (item) =>
          ref.read(deleteGasStationChainUseCaseProvider)(item.chain),
      onRestore: (item) =>
          ref.read(restoreGasStationChainUseCaseProvider)(item.chain),
      onAdd: () => _createChain(context),
      onEdit: (item) => _openDetail(context, chainId: item.chain.id),
    );
  }
}
