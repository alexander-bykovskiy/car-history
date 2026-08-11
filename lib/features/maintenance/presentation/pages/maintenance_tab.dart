import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/open_event_forms.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/event_timeline/event_timeline_tab_shell.dart';
import '../../../../shared/presentation/event_timeline/paged_event_timeline_list.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../../app/di/app_providers.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../widgets/maintenance_timeline_tile.dart';

class MaintenanceTab extends ConsumerWidget {
  const MaintenanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAsync = ref.watch(selectedCarProvider);
    return EventTimelineTabShell(
      carId: selectedAsync.value?.id,
      carSelectionLoading: selectedAsync.isLoading && !selectedAsync.hasValue,
      prefsReady: (ref) {
        final distance = ref.watch(distanceUnitProvider).value;
        final currency = ref.watch(currencyCodeProvider).value;
        return distance != null && currency != null;
      },
      onAdd: (context, ref, carId) async {
        final distance = ref.read(distanceUnitProvider).value!;
        final currency = ref.read(currencyCodeProvider).value!;
        await openMaintenanceForm(
          context,
          carId: carId,
          distanceUnit: distance,
          currencyCode: currency,
        );
      },
      body: (context, ref, carId) {
        final l10n = AppLocalizations.of(context);
        final distance = ref.watch(distanceUnitProvider).value!;
        final currency = ref.watch(currencyCodeProvider).value!;
        final repository = ref.watch(maintenanceRepositoryProvider);
        final distanceShort = distanceUnitShort(l10n, distance);

        return PagedEventTimelineList(
          key: ValueKey(carId),
          pageSize: MaintenanceRepository.pageSize,
          loadPage: ({beforeAt, beforeId}) => repository.pageForCar(
            carId,
            beforeServicedAt: beforeAt,
            beforeId: beforeId,
          ),
          loadMonthTotals: () => repository.monthTotalsForCar(carId),
          watchChanges: repository.watchMaintenancesChanges,
          dateOf: (item) => item.servicedAt,
          idOf: (item) => item.id,
          emptyMessage: l10n.listEmpty,
          errorMessage: (_) => l10n.listLoadError,
          entryBuilder: (context, row, styles, numberFormat, locale) {
            return buildMaintenanceTimelineTile(
              entry: row.entry,
              isFirst: row.isFirst,
              isLast: row.isLast,
              styles: styles,
              numberFormat: numberFormat,
              locale: locale,
              distanceUnit: distance,
              distanceShort: distanceShort,
              onOpen: () => openMaintenanceFormForEntry(
                context,
                carId: carId,
                distanceUnit: distance,
                currencyCode: currency,
                entry: row.entry,
              ),
            );
          },
        );
      },
    );
  }
}
