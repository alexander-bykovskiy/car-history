import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/units.dart';
import '../../features/fueling/domain/entities/fueling.dart';
import '../../features/fueling/presentation/controllers/fueling_form_prepare.dart';
import '../../features/fueling/presentation/models/fueling_form_data.dart';
import '../../features/fueling/presentation/pages/fueling_form_page.dart';
import '../../features/maintenance/domain/entities/maintenance.dart';
import '../../features/maintenance/presentation/controllers/maintenance_form_prepare.dart';
import '../../features/maintenance/presentation/models/maintenance_form_data.dart';
import '../../features/maintenance/presentation/pages/maintenance_form_page.dart';
import '../../features/settings/di/preferences_providers.dart';

/// Composition-root navigation into fueling / maintenance editors.
///
/// Feature tabs call these helpers so events does not import sibling
/// presentation pages or form DTOs.

Future<void> openFuelingForm(
  BuildContext context, {
  required int carId,
  required FuelVolumeUnit volumeUnit,
  required DistanceUnit distanceUnit,
  required String currencyCode,
  FuelingFormData? existing,
  int? deleteId,
  String? initialFuelTypeName,
  String? initialGasStationName,
}) async {
  await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (context) => FuelingFormPage(
        carId: carId,
        volumeUnit: volumeUnit,
        distanceUnit: distanceUnit,
        currencyCode: currencyCode,
        existing: existing,
        deleteId: deleteId,
        initialFuelTypeName: initialFuelTypeName,
        initialGasStationName: initialGasStationName,
      ),
    ),
  );
}

Future<void> openFuelingFormForEntry(
  BuildContext context, {
  required int carId,
  required FuelVolumeUnit volumeUnit,
  required DistanceUnit distanceUnit,
  required String currencyCode,
  required FuelingListItem entry,
}) {
  return openFuelingForm(
    context,
    carId: carId,
    volumeUnit: volumeUnit,
    distanceUnit: distanceUnit,
    currencyCode: currencyCode,
    existing: fuelingFormDataFromView(entry),
    deleteId: entry.id,
    initialFuelTypeName: entry.fuelTypeName,
    initialGasStationName: entry.gasStationName,
  );
}

/// Reads units/currency from prefs; no-op if providers are not ready.
Future<void> openFuelingFormUsingPrefs(
  BuildContext context,
  WidgetRef ref, {
  required int carId,
  FuelingListItem? entry,
}) async {
  final volume = ref.read(fuelVolumeUnitProvider).value;
  final distance = ref.read(distanceUnitProvider).value;
  final currency = ref.read(currencyCodeProvider).value;
  if (volume == null || distance == null || currency == null) return;

  if (entry != null) {
    await openFuelingFormForEntry(
      context,
      carId: carId,
      volumeUnit: volume,
      distanceUnit: distance,
      currencyCode: currency,
      entry: entry,
    );
    return;
  }

  await openFuelingForm(
    context,
    carId: carId,
    volumeUnit: volume,
    distanceUnit: distance,
    currencyCode: currency,
  );
}

Future<void> openMaintenanceForm(
  BuildContext context, {
  required int carId,
  required DistanceUnit distanceUnit,
  required String currencyCode,
  MaintenanceFormData? existing,
  int? deleteId,
  String? initialServiceName,
}) async {
  await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (context) => MaintenanceFormPage(
        carId: carId,
        distanceUnit: distanceUnit,
        currencyCode: currencyCode,
        existing: existing,
        deleteId: deleteId,
        initialServiceName: initialServiceName,
      ),
    ),
  );
}

Future<void> openMaintenanceFormForEntry(
  BuildContext context, {
  required int carId,
  required DistanceUnit distanceUnit,
  required String currencyCode,
  required MaintenanceListItem entry,
}) {
  return openMaintenanceForm(
    context,
    carId: carId,
    distanceUnit: distanceUnit,
    currencyCode: currencyCode,
    existing: maintenanceFormDataFromView(entry),
    deleteId: entry.id,
    initialServiceName: entry.serviceName,
  );
}

/// Reads units/currency from prefs; no-op if providers are not ready.
Future<void> openMaintenanceFormUsingPrefs(
  BuildContext context,
  WidgetRef ref, {
  required int carId,
  MaintenanceListItem? entry,
}) async {
  final distance = ref.read(distanceUnitProvider).value;
  final currency = ref.read(currencyCodeProvider).value;
  if (distance == null || currency == null) return;

  if (entry != null) {
    await openMaintenanceFormForEntry(
      context,
      carId: carId,
      distanceUnit: distance,
      currencyCode: currency,
      entry: entry,
    );
    return;
  }

  await openMaintenanceForm(
    context,
    carId: carId,
    distanceUnit: distance,
    currencyCode: currency,
  );
}
