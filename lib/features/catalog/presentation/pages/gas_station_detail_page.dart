import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gas_station.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../widgets/gas_station_dialogs.dart';

class GasStationDetailPage extends ConsumerWidget {
  const GasStationDetailPage({
    required this.chainId,
    super.key,
  });

  final int chainId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(gasStationRepositoryProvider);

    return StreamBuilder<GasStationChainWithLocations?>(
      stream: repository.watchChainWithLocations(chainId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.listLoadError)),
          );
        }

        final item = snapshot.data;
        if (item == null) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          // Chain was deleted while viewing.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final chain = item.chain;
        final locations = item.locations
            .where((l) => l.address?.trim().isNotEmpty ?? false)
            .toList();
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(title: Text(chain.name)),
          floatingActionButton: chain.isDeleted
              ? null
              : FloatingActionButton(
                  onPressed: () => showGasStationLocationDialog(
                    context,
                    chain: chain,
                  ),
                  tooltip: l10n.gasStationAddAddressTitle,
                  child: const Icon(Icons.add),
                ),
          body: ListView(
            children: [
              ListTile(
                title: Text(
                  chain.name,
                  style: theme.textTheme.titleLarge,
                ),
                trailing: chain.isDeleted
                    ? IconButton(
                        tooltip: l10n.actionRestore,
                        icon: const Icon(Icons.restore),
                        onPressed: () =>
                            ref.read(restoreGasStationChainUseCaseProvider)(
                          chain,
                        ),
                      )
                    : const Icon(Icons.edit_outlined),
                onTap: chain.isDeleted
                    ? null
                    : () => showGasStationChainDialog(
                          context,
                          existing: chain,
                        ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.gasStationAddressesSection,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (locations.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    l10n.listEmpty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                for (var i = 0; i < locations.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _LocationTile(
                    location: locations[i],
                    chain: chain,
                  ),
                ],
              const SizedBox(height: 88),
            ],
          ),
        );
      },
    );
  }
}

class _LocationTile extends ConsumerWidget {
  const _LocationTile({
    required this.location,
    required this.chain,
  });

  final GasStationLocationItem location;
  final GasStationChainItem chain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final address = location.address?.trim();
    final hasAddress = address != null && address.isNotEmpty;
    final opacity = location.isDeleted ? 0.45 : 1.0;

    final tile = ListTile(
      title: Text(
        hasAddress ? address : l10n.gasStationNoAddress,
        style: hasAddress
            ? null
            : theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
      onTap: location.isDeleted || chain.isDeleted
          ? null
          : () => showGasStationLocationDialog(
                context,
                chain: chain,
                existing: location,
              ),
      trailing: location.isDeleted
          ? IconButton(
              tooltip: l10n.actionRestore,
              icon: const Icon(Icons.restore),
              onPressed: () =>
                  ref.read(restoreGasStationLocationUseCaseProvider)(location),
            )
          : null,
    );

    if (location.isDeleted) {
      return Opacity(opacity: opacity, child: tile);
    }

    return Dismissible(
      key: ValueKey('gas-location-${location.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDeleteConfirmDialog(
        context,
        message: l10n.gasStationDeleteConfirm,
      ),
      onDismissed: (_) =>
          ref.read(deleteGasStationLocationUseCaseProvider)(location),
      background: ColoredBox(
        color: theme.colorScheme.error,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onError,
            ),
          ),
        ),
      ),
      child: tile,
    );
  }
}
