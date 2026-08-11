import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/units.dart';
import '../../l10n/app_localizations.dart';
import 'date_form_field.dart';
import 'reminder_trigger_form.dart';
import 'unit_labels.dart';

/// Shared date / odometer / remind-before fields for reminder forms.
///
/// Used by standalone reminder editor and maintenance-embedded reminder form
/// so layout and clear-on-toggle behavior stay aligned.
class ReminderTriggerFields extends StatelessWidget {
  const ReminderTriggerFields({
    required this.useDate,
    required this.useOdometer,
    required this.dueAt,
    required this.distanceUnit,
    required this.odometerController,
    required this.remindBeforeDaysController,
    required this.remindBeforeKmController,
    required this.triggerError,
    required this.odometerError,
    required this.remindBeforeDaysError,
    required this.remindBeforeKmError,
    required this.onUseDateChanged,
    required this.onUseOdometerChanged,
    required this.onPickDate,
    this.sectionGap = 24,
    super.key,
  });

  final bool useDate;
  final bool useOdometer;
  final DateTime? dueAt;
  final DistanceUnit distanceUnit;
  final TextEditingController odometerController;
  final TextEditingController remindBeforeDaysController;
  final TextEditingController remindBeforeKmController;
  final ReminderTriggerErrorCode? triggerError;
  final ReminderTriggerErrorCode? odometerError;
  final ReminderTriggerErrorCode? remindBeforeDaysError;
  final ReminderTriggerErrorCode? remindBeforeKmError;
  final ValueChanged<bool> onUseDateChanged;
  final ValueChanged<bool> onUseOdometerChanged;
  final VoidCallback onPickDate;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateText = dueAt == null
        ? l10n.reminderDateHint
        : DateFormat.yMMMMd(locale).format(dueAt!);
    final unitShort = distanceUnitShort(l10n, distanceUnit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (triggerError != null) ...[
          Text(
            reminderTriggerErrorText(l10n, triggerError)!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          SizedBox(height: sectionGap / 3),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.reminderByDate),
          value: useDate,
          onChanged: (value) {
            onUseDateChanged(value);
            if (!value) {
              remindBeforeDaysController.clear();
            }
          },
        ),
        if (useDate) ...[
          const SizedBox(height: 8),
          DateFormField(
            label: l10n.reminderDueDateLabel,
            valueText: dateText,
            onPick: onPickDate,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: remindBeforeDaysController,
            decoration: InputDecoration(
              labelText: l10n.reminderRemindBeforeDaysLabel,
              errorText: reminderTriggerErrorText(l10n, remindBeforeDaysError),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
        SizedBox(height: sectionGap),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.reminderByOdometer),
          value: useOdometer,
          onChanged: (value) {
            onUseOdometerChanged(value);
            if (!value) {
              odometerController.clear();
              remindBeforeKmController.clear();
            }
          },
        ),
        if (useOdometer) ...[
          const SizedBox(height: 8),
          TextField(
            controller: odometerController,
            decoration: InputDecoration(
              labelText: l10n.fuelingOdometerLabel(unitShort),
              errorText: reminderTriggerErrorText(l10n, odometerError),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: remindBeforeKmController,
            decoration: InputDecoration(
              labelText: l10n.reminderRemindBeforeDistanceLabel(unitShort),
              errorText: reminderTriggerErrorText(l10n, remindBeforeKmError),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ],
    );
  }
}
