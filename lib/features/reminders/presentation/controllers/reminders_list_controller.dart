import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../../core/reminder_alert_policy.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/odometer_repository.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/reminder_list_sort.dart';

/// List orchestration for [RemindersPage]: odometer batch load, sort, markers.
///
/// Dependencies are passed from the page (no [WidgetRef]).
class RemindersListController extends ChangeNotifier {
  Map<int, double?> _odometersByCar = {};
  int? _odometersForListHash;

  Map<int, double?> get odometersByCar => _odometersByCar;

  /// Reloads odometers when the set of car ids on [items] changes.
  ///
  /// Call from a stream subscription (not from [State.build]).
  void onItemsChanged(
    OdometerRepository odometer,
    List<ReminderListItem> items,
  ) {
    final carIds = items.map((item) => item.reminder.carId).toSet().toList()
      ..sort();
    final odometerHash = Object.hashAll(carIds);
    if (odometerHash == _odometersForListHash) return;
    _odometersForListHash = odometerHash;
    loadOdometers(odometer, carIds);
  }

  /// Forces the next [onItemsChanged] / [refreshOdometers] to reload.
  void invalidateOdometers() {
    _odometersForListHash = null;
  }

  /// Reloads odometers for [items] even if the car-id set is unchanged.
  void refreshOdometers(
    OdometerRepository odometer,
    List<ReminderListItem> items,
  ) {
    invalidateOdometers();
    onItemsChanged(odometer, items);
  }

  Future<void> loadOdometers(
    OdometerRepository odometer,
    List<int> carIds,
  ) async {
    final map = <int, double?>{};
    for (final carId in carIds) {
      map[carId] = await odometer.maxOdometerKm(carId);
    }
    _odometersByCar = map;
    notifyListeners();
  }

  List<ReminderListItem> sortedItems(
    List<ReminderListItem> items, {
    required DateTime now,
  }) {
    return [...items]
      ..sort(
        (a, b) => compareRemindersByAlertPriority(
          a,
          b,
          now: now,
          odometersByCar: _odometersByCar,
        ),
      );
  }

  ReminderAlertLevel? markerLevel(
    ReminderRecord reminder, {
    required DateTime now,
  }) {
    if (reminder.isCompleted || reminder.isDeleted) {
      return null;
    }
    return reminderAlertLevelFor(
      reminder: reminder.toAlertInput(),
      now: now,
      currentOdometerKm: _odometersByCar[reminder.carId],
    );
  }

  String detailsLine(
    ReminderListItem item, {
    required AppLocalizations l10n,
    required String locale,
    required DistanceUnit unit,
  }) {
    final reminder = item.reminder;
    final parts = <String>[item.carLabel];
    if (reminder.dueAt != null) {
      parts.add(DateFormat.yMMMd(locale).format(reminder.dueAt!));
    }
    if (reminder.dueOdometerKm != null) {
      parts.add(_formatOdometer(reminder.dueOdometerKm!, l10n, unit));
    }
    return parts.where((s) => s.isNotEmpty).join(' · ');
  }

  String _formatOdometer(
    double km,
    AppLocalizations l10n,
    DistanceUnit unit,
  ) {
    final value = unit.fromKilometers(km);
    final rounded = (value * 10).roundToDouble() / 10;
    final text = rounded == rounded.roundToDouble()
        ? rounded.toStringAsFixed(0)
        : rounded.toStringAsFixed(1);
    return '$text ${distanceUnitShort(l10n, unit)}';
  }
}
