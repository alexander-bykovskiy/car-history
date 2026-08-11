import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/open_event_forms.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/event_timeline/event_timeline_tab_shell.dart';
import '../../../../shared/presentation/event_timeline/paged_event_timeline_list.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../../app/di/app_providers.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../domain/repositories/fueling_repository.dart';
import '../widgets/fueling_timeline_tile.dart';

class FuelingsTab extends ConsumerWidget {
  const FuelingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAsync = ref.watch(selectedCarProvider);
    return EventTimelineTabShell(
      carId: selectedAsync.value?.id,
      carSelectionLoading: selectedAsync.isLoading && !selectedAsync.hasValue,
      prefsReady: (ref) {
        final volume = ref.watch(fuelVolumeUnitProvider).value;
        final distance = ref.watch(distanceUnitProvider).value;
        final currency = ref.watch(currencyCodeProvider).value;
        return volume != null && distance != null && currency != null;
      },
      onAdd: (context, ref, carId) async {
        final volume = ref.read(fuelVolumeUnitProvider).value!;
        final distance = ref.read(distanceUnitProvider).value!;
        final currency = ref.read(currencyCodeProvider).value!;
        await openFuelingForm(
          context,
          carId: carId,
          volumeUnit: volume,
          distanceUnit: distance,
          currencyCode: currency,
        );
      },
      body: (context, ref, carId) {
        final l10n = AppLocalizations.of(context);
        final volume = ref.watch(fuelVolumeUnitProvider).value!;
        final distance = ref.watch(distanceUnitProvider).value!;
        final currency = ref.watch(currencyCodeProvider).value!;
        final repository = ref.watch(fuelingRepositoryProvider);
        final volumeShort = volumeUnitShort(l10n, volume);
        final distanceShort = distanceUnitShort(l10n, distance);

        return PagedEventTimelineList(
          key: ValueKey(carId),
          pageSize: FuelingRepository.pageSize,
          loadPage: ({beforeAt, beforeId}) => repository.pageForCar(
            carId,
            beforeFueledAt: beforeAt,
            beforeId: beforeId,
          ),
          loadMonthTotals: () => repository.monthTotalsForCar(carId),
          watchChanges: repository.watchFuelingsChanges,
          dateOf: (item) => item.fueledAt,
          idOf: (item) => item.id,
          emptyMessage: l10n.listEmpty,
          errorMessage: (_) => l10n.listLoadError,
          entryBuilder: (context, row, styles, numberFormat, locale) {
            return buildFuelingTimelineTile(
              entry: row.entry,
              isFirst: row.isFirst,
              isLast: row.isLast,
              styles: styles,
              numberFormat: numberFormat,
              locale: locale,
              volumeUnit: volume,
              distanceUnit: distance,
              volumeShort: volumeShort,
              distanceShort: distanceShort,
              onOpen: () => openFuelingFormForEntry(
                context,
                carId: carId,
                volumeUnit: volume,
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
