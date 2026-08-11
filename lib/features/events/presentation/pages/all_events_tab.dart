import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../app/navigation/open_event_forms.dart';
import '../../../settings/di/preferences_providers.dart';
import 'all_events_list.dart';
import '../../../../l10n/app_localizations.dart';

enum AddEventKind { fueling, maintenance }

class AllEventsTab extends ConsumerStatefulWidget {
  const AllEventsTab({super.key});

  @override
  ConsumerState<AllEventsTab> createState() => _AllEventsTabState();
}

class _AllEventsTabState extends ConsumerState<AllEventsTab> {
  Future<void> _showAddChooser(int carId) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<AddEventKind>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.local_gas_station_outlined),
                title: Text(l10n.fuelingAddTitle),
                onTap: () =>
                    Navigator.of(sheetContext).pop(AddEventKind.fueling),
              ),
              ListTile(
                leading: const Icon(Icons.build_outlined),
                title: Text(l10n.maintenanceAddTitle),
                onTap: () =>
                    Navigator.of(sheetContext).pop(AddEventKind.maintenance),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || choice == null) return;
    switch (choice) {
      case AddEventKind.fueling:
        await openFuelingFormUsingPrefs(context, ref, carId: carId);
      case AddEventKind.maintenance:
        await openMaintenanceFormUsingPrefs(context, ref, carId: carId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedAsync = ref.watch(selectedCarProvider);
    if (selectedAsync.isLoading && !selectedAsync.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final carId = selectedAsync.value?.id;

    if (carId == null) {
      return Center(child: Text(l10n.listEmpty));
    }

    final volume = ref.watch(fuelVolumeUnitProvider).value;
    final distance = ref.watch(distanceUnitProvider).value;
    final currency = ref.watch(currencyCodeProvider).value;
    if (volume == null || distance == null || currency == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      primary: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChooser(carId),
        tooltip: l10n.actionAdd,
        child: const Icon(Icons.add),
      ),
      body: AllEventsPagedList(
        key: ValueKey(carId),
        carId: carId,
        fuelingRepository: ref.watch(fuelingRepositoryProvider),
        maintenanceRepository: ref.watch(maintenanceRepositoryProvider),
        volumeUnit: volume,
        distanceUnit: distance,
        currencyCode: currency,
        onOpenFueling: (entry) => openFuelingFormForEntry(
          context,
          carId: carId,
          volumeUnit: volume,
          distanceUnit: distance,
          currencyCode: currency,
          entry: entry,
        ),
        onOpenMaintenance: (entry) => openMaintenanceFormForEntry(
          context,
          carId: carId,
          distanceUnit: distance,
          currencyCode: currency,
          entry: entry,
        ),
      ),
    );
  }
}

