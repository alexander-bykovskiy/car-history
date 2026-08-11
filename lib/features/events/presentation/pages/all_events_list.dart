import 'package:flutter/material.dart';

import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/event_timeline/event_timeline_paged_shell.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../fueling/domain/entities/fueling.dart';
import '../../../fueling/domain/repositories/fueling_repository.dart';
import '../../../fueling/presentation/widgets/fueling_timeline_tile.dart';
import '../../../maintenance/domain/entities/maintenance.dart';
import '../../../maintenance/domain/repositories/maintenance_repository.dart';
import '../../../maintenance/presentation/widgets/maintenance_timeline_tile.dart';
import '../dual_source_paged_controller.dart';

typedef _DualEvent = DualSourceEvent<FuelingListItem, MaintenanceListItem>;

class AllEventsPagedList extends StatefulWidget {
  const AllEventsPagedList({
    super.key,
    required this.carId,
    required this.fuelingRepository,
    required this.maintenanceRepository,
    required this.volumeUnit,
    required this.distanceUnit,
    required this.currencyCode,
    required this.onOpenFueling,
    required this.onOpenMaintenance,
  });

  final int carId;
  final FuelingRepository fuelingRepository;
  final MaintenanceRepository maintenanceRepository;
  final FuelVolumeUnit volumeUnit;
  final DistanceUnit distanceUnit;
  final String currencyCode;
  final ValueChanged<FuelingListItem> onOpenFueling;
  final ValueChanged<MaintenanceListItem> onOpenMaintenance;

  @override
  State<AllEventsPagedList> createState() => AllEventsPagedListState();
}

class AllEventsPagedListState extends State<AllEventsPagedList> {
  late DualSourcePagedController<FuelingListItem, MaintenanceListItem> _paging;
  late EventTimelinePager _pager;

  @override
  void initState() {
    super.initState();
    _paging = _createController()..start();
    _pager = _createPager(_paging);
  }

  DualSourcePagedController<FuelingListItem, MaintenanceListItem>
      _createController() {
    return DualSourcePagedController<FuelingListItem, MaintenanceListItem>(
      pageSizeA: FuelingRepository.pageSize,
      pageSizeB: MaintenanceRepository.pageSize,
      loadPageA: ({beforeAt, beforeId}) => widget.fuelingRepository.pageForCar(
        widget.carId,
        beforeFueledAt: beforeAt,
        beforeId: beforeId,
      ),
      loadPageB: ({beforeAt, beforeId}) =>
          widget.maintenanceRepository.pageForCar(
        widget.carId,
        beforeServicedAt: beforeAt,
        beforeId: beforeId,
      ),
      loadMonthTotalsA: () =>
          widget.fuelingRepository.monthTotalsForCar(widget.carId),
      loadMonthTotalsB: () =>
          widget.maintenanceRepository.monthTotalsForCar(widget.carId),
      watchChangesA: widget.fuelingRepository.watchFuelingsChanges,
      watchChangesB: widget.maintenanceRepository.watchMaintenancesChanges,
      dateOfA: (item) => item.fueledAt,
      dateOfB: (item) => item.servicedAt,
      idOfA: (item) => item.id,
      idOfB: (item) => item.id,
    );
  }

  EventTimelinePager _createPager(
    DualSourcePagedController<FuelingListItem, MaintenanceListItem> paging,
  ) {
    return EventTimelinePager(
      listenable: paging,
      initialLoading: () => paging.initialLoading,
      loadingMore: () => paging.loadingMore,
      hasMore: () => paging.hasMore,
      shouldLoadMoreOnScroll: () => paging.shouldLoadMoreOnScroll,
      error: () => paging.error,
      loadMore: paging.loadMore,
      setOnReloaded: (callback) => paging.onReloaded = callback,
      setOnLoadedMore: (callback) => paging.onLoadedMore = callback,
    );
  }

  @override
  void didUpdateWidget(covariant AllEventsPagedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.carId != widget.carId ||
        oldWidget.fuelingRepository != widget.fuelingRepository ||
        oldWidget.maintenanceRepository != widget.maintenanceRepository) {
      _paging.dispose();
      _paging = _createController()..start();
      _pager = _createPager(_paging);
    }
  }

  @override
  void dispose() {
    _paging.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final volumeShort = volumeUnitShort(l10n, widget.volumeUnit);
    final distanceShort = distanceUnitShort(l10n, widget.distanceUnit);

    return EventTimelinePagedShell<_DualEvent>(
      pager: _pager,
      items: () => _paging.visibleEvents,
      dateOf: (event) => event.map(a: (e) => e.fueledAt, b: (e) => e.servicedAt),
      monthTotals: () => _paging.monthTotals,
      emptyMessage: l10n.listEmpty,
      entryBuilder: (context, row, styles, numberFormat, locale) {
        return row.entry.map(
          a: (entry) => buildFuelingTimelineTile(
            entry: entry,
            isFirst: row.isFirst,
            isLast: row.isLast,
            styles: styles,
            numberFormat: numberFormat,
            locale: locale,
            volumeUnit: widget.volumeUnit,
            distanceUnit: widget.distanceUnit,
            volumeShort: volumeShort,
            distanceShort: distanceShort,
            onOpen: () => widget.onOpenFueling(entry),
          ),
          b: (entry) => buildMaintenanceTimelineTile(
            entry: entry,
            isFirst: row.isFirst,
            isLast: row.isLast,
            styles: styles,
            numberFormat: numberFormat,
            locale: locale,
            distanceUnit: widget.distanceUnit,
            distanceShort: distanceShort,
            onOpen: () => widget.onOpenMaintenance(entry),
          ),
        );
      },
    );
  }
}
