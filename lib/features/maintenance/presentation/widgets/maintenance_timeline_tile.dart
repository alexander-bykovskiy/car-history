import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/units.dart';
import '../../../../shared/presentation/event_timeline/event_list_formatting.dart';
import '../../../../shared/presentation/event_timeline/event_timeline_tile.dart';
import '../../../../shared/presentation/event_timeline/paged_event_timeline_list.dart';
import '../../../../shared/presentation/service_icons.dart';
import '../../domain/entities/maintenance.dart';

/// Timeline row for a maintenance entry (Maintenance tab and All Events).
Widget buildMaintenanceTimelineTile({
  required MaintenanceListItem entry,
  required bool isFirst,
  required bool isLast,
  required EventTimelineStyles styles,
  required NumberFormat numberFormat,
  required String locale,
  required DistanceUnit distanceUnit,
  required String distanceShort,
  required VoidCallback onOpen,
}) {
  final odometerKm = entry.odometerKm;
  final currencyCode = entry.currencyCode;

  final detailSpans = <InlineSpan>[
    if (entry.serviceName != null)
      styles.numberSpan(entry.serviceName!, styles.subtitleStyle),
  ];
  if (odometerKm != null) {
    final odometer = distanceUnit.fromKilometers(odometerKm);
    if (detailSpans.isNotEmpty) {
      detailSpans.add(styles.numberSpan(' · ', styles.subtitleStyle));
    }
    detailSpans.addAll([
      styles.numberSpan(numberFormat.format(odometer), styles.subtitleStyle),
      const TextSpan(text: ' '),
      styles.unitSpan(distanceShort, styles.unitStyle),
    ]);
  }

  return EventTimelineTile(
    isFirst: isFirst,
    isLast: isLast,
    icon: ServiceIcons.iconForKey(entry.serviceIconKey),
    date: formatEventListDate(entry.servicedAt, locale),
    details: TextSpan(children: detailSpans),
    total: entry.displayTotal == null
        ? null
        : TextSpan(
            children: [
              styles.numberSpan(
                numberFormat.format(entry.displayTotal!),
                styles.titleStyle,
              ),
              const TextSpan(text: ' '),
              styles.unitSpan(currencyCode, styles.trailingUnitStyle),
            ],
          ),
    onDoubleTap: onOpen,
  );
}
