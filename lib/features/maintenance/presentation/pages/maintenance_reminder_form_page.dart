import 'package:flutter/material.dart';

import '../../../../core/event_date_limits.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/form_actions_bar.dart';
import '../../../../shared/presentation/reminder_trigger_fields.dart';
import '../../domain/entities/reminder_draft.dart';
import '../controllers/maintenance_reminder_form_notifier.dart';

/// Result from [MaintenanceReminderFormPage].
class MaintenanceReminderFormResult {
  const MaintenanceReminderFormResult._({this.draft, this.removed = false});

  const MaintenanceReminderFormResult.saved(ReminderDraft draft)
      : this._(draft: draft);

  const MaintenanceReminderFormResult.removed() : this._(removed: true);

  final ReminderDraft? draft;
  final bool removed;
}

/// Reminder fields for a maintenance record (no title / car / completed).
class MaintenanceReminderFormPage extends StatefulWidget {
  const MaintenanceReminderFormPage({
    required this.distanceUnit,
    this.initial,
    super.key,
  });

  final DistanceUnit distanceUnit;
  final ReminderDraft? initial;

  @override
  State<MaintenanceReminderFormPage> createState() =>
      _MaintenanceReminderFormPageState();
}

class _MaintenanceReminderFormPageState
    extends State<MaintenanceReminderFormPage> {
  static const _sectionGap = 24.0;

  final _odometerController = TextEditingController();
  final _remindBeforeDaysController = TextEditingController();
  final _remindBeforeKmController = TextEditingController();

  late final MaintenanceReminderFormNotifier _form;

  @override
  void initState() {
    super.initState();
    _form = MaintenanceReminderFormNotifier(
      distanceUnit: widget.distanceUnit,
      initial: widget.initial,
    );
    final initial = widget.initial;
    if (initial != null) {
      if (initial.remindBeforeDays != null) {
        _remindBeforeDaysController.text = '${initial.remindBeforeDays}';
      }
      if (initial.dueOdometerKm != null) {
        _odometerController.text = _form.formatNumber(
          widget.distanceUnit.fromKilometers(initial.dueOdometerKm!),
        );
      }
      if (initial.remindBeforeKm != null) {
        _remindBeforeKmController.text = _form.formatNumber(
          widget.distanceUnit.fromKilometers(initial.remindBeforeKm!),
        );
      }
    }
  }

  @override
  void dispose() {
    _form.dispose();
    _odometerController.dispose();
    _remindBeforeDaysController.dispose();
    _remindBeforeKmController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final initial = _form.dueAt ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: kMinEventDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
    );
    if (picked == null || !mounted) return;
    _form.setDueAt(picked);
  }

  void _submit() {
    final outcome = _form.submit(
      remindBeforeDaysText: _remindBeforeDaysController.text,
      odometerText: _odometerController.text,
      remindBeforeKmText: _remindBeforeKmController.text,
    );
    switch (outcome) {
      case MaintenanceReminderFormSaved(:final draft):
        Navigator.of(context).pop(MaintenanceReminderFormResult.saved(draft));
      case MaintenanceReminderFormFieldError():
        break;
      case MaintenanceReminderFormRemoved():
        break;
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.reminderDeleteConfirm,
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop(const MaintenanceReminderFormResult.removed());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _form.isEditing
              ? l10n.maintenanceEditReminder
              : l10n.maintenanceAddReminder,
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _form,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ReminderTriggerFields(
                  useDate: _form.useDate,
                  useOdometer: _form.useOdometer,
                  dueAt: _form.dueAt,
                  distanceUnit: widget.distanceUnit,
                  odometerController: _odometerController,
                  remindBeforeDaysController: _remindBeforeDaysController,
                  remindBeforeKmController: _remindBeforeKmController,
                  triggerError: _form.triggerError,
                  odometerError: _form.odometerError,
                  remindBeforeDaysError: _form.remindBeforeDaysError,
                  remindBeforeKmError: _form.remindBeforeKmError,
                  onUseDateChanged: _form.setUseDate,
                  onUseOdometerChanged: _form.setUseOdometer,
                  onPickDate: _pickDate,
                  sectionGap: _sectionGap,
                ),
                const SizedBox(height: _sectionGap),
                FormActionsBar(
                  isSaving: false,
                  onSave: _submit,
                  onDelete: _form.isEditing ? _delete : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
