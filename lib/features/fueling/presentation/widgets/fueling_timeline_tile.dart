import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/units.dart';
import '../../../../shared/presentation/event_timeline/event_list_formatting.dart';
import '../../../../shared/presentation/event_timeline/event_timeline_tile.dart';
import '../../../../shared/presentation/event_timeline/paged_event_timeline_list.dart';
import '../../domain/entities/fueling.dart';

/// Timeline row for a fueling entry (Fuelings tab and All Events).
Widget buildFuelingTimelineTile({
  required FuelingListItem entry,
  required bool isFirst,
  required bool isLast,
  required EventTimelineStyles styles,
  required NumberFormat numberFormat,
  required String locale,
  required FuelVolumeUnit volumeUnit,
  required DistanceUnit distanceUnit,
  required String volumeShort,
  required String distanceShort,
  required VoidCallback onOpen,
}) {
  final quantity = volumeUnit.fromLiters(entry.liters);
  final pricePerUnit = volumeUnit.priceFromPerLiter(entry.pricePerLiter);
  final odometerKm = entry.odometerKm;
  final currencyCode = entry.currencyCode;

  final detailSpans = <InlineSpan>[
    if (entry.fuelTypeName != null) ...[
      styles.numberSpan(entry.fuelTypeName!, styles.subtitleStyle),
      styles.numberSpan(' · ', styles.subtitleStyle),
    ],
    styles.numberSpan(numberFormat.format(quantity), styles.subtitleStyle),
    const TextSpan(text: ' '),
    styles.unitSpan(volumeShort, styles.unitStyle),
    styles.numberSpan(' · ', styles.subtitleStyle),
    styles.numberSpan(numberFormat.format(pricePerUnit), styles.subtitleStyle),
    const TextSpan(text: ' '),
    styles.unitSpan(currencyCode, styles.unitStyle),
    styles.numberSpan('/', styles.subtitleStyle),
    styles.unitSpan(volumeShort, styles.unitStyle),
  ];
  if (odometerKm != null) {
    final odometer = distanceUnit.fromKilometers(odometerKm);
    detailSpans.addAll([
      styles.numberSpan(' · ', styles.subtitleStyle),
      styles.numberSpan(numberFormat.format(odometer), styles.subtitleStyle),
      const TextSpan(text: ' '),
      styles.unitSpan(distanceShort, styles.unitStyle),
    ]);
  }

  return EventTimelineTile(
    isFirst: isFirst,
    isLast: isLast,
    icon: Icons.local_gas_station,
    date: formatEventListDate(entry.fueledAt, locale),
    dateSuffix: entry.gasStationName,
    details: TextSpan(children: detailSpans),
    total: TextSpan(
      children: [
        styles.numberSpan(
          numberFormat.format(entry.totalAmount),
          styles.titleStyle,
        ),
        const TextSpan(text: ' '),
        styles.unitSpan(currencyCode, styles.trailingUnitStyle),
      ],
    ),
    onDoubleTap: onOpen,
  );
}
