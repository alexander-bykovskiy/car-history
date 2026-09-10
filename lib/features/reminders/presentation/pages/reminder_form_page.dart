import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/event_date_limits.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/form_actions_bar.dart';
import '../../../../shared/presentation/form_session.dart';
import '../../../../shared/presentation/reminder_odometer_prefill.dart';
import '../../../../shared/presentation/reminder_trigger_fields.dart';
import '../../../../shared/presentation/reminder_trigger_form.dart';
import '../../../../app/di/app_providers.dart';
import '../../../cars/domain/entities/car.dart';
import '../../domain/entities/reminder.dart';
import '../../di/reminder_providers.dart';
import '../../../settings/di/preferences_providers.dart';
import '../controllers/reminder_form_notifier.dart';

class ReminderFormPage extends ConsumerStatefulWidget {
  const ReminderFormPage({this.existing, super.key});

  final ReminderRecord? existing;

  @override
  ConsumerState<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends ConsumerState<ReminderFormPage> {
  static const _sectionGap = 24.0;

  final _titleController = TextEditingController();
  final _odometerController = TextEditingController();
  final _remindBeforeDaysController = TextEditingController();
  final _remindBeforeKmController = TextEditingController();

  late final ReminderFormNotifier _form;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    final selectedCarId = existing?.carId;
    _form = ReminderFormNotifier(
      existing: existing,
      distanceUnit: DistanceUnit.kilometers,
      initialCarId: selectedCarId,
    );

    if (existing != null) {
      _titleController.text = existing.title;
      if (existing.remindBeforeDays != null) {
        _remindBeforeDaysController.text = '${existing.remindBeforeDays}';
      }
    }

    _loadUnitsAndPrefill();
  }

  Future<void> _loadUnitsAndPrefill() async {
    final unit = ref.read(distanceUnitProvider).value ??
        await ref.read(unitPreferencesStoreProvider).distanceUnit();
    if (!mounted) return;
    _form.setDistanceUnit(unit);

    final existing = widget.existing;
    if (existing?.dueOdometerKm != null) {
      _odometerController.text =
          _form.formatNumber(unit.fromKilometers(existing!.dueOdometerKm!));
    }
    if (existing?.remindBeforeKm != null) {
      _remindBeforeKmController.text =
          _form.formatNumber(unit.fromKilometers(existing!.remindBeforeKm!));
    }

    if (_form.carId == null) {
      final selected = ref.read(selectedCarProvider).value;
      if (selected != null) {
        _form.setCarId(selected.id);
      }
    }

    await _loadBaseline();
  }

  Future<void> _loadBaseline({bool fillAbsoluteField = false}) async {
    final carId = _form.carId;
    if (carId == null) return;
    final baselineKm = await ReminderOdometerPrefill.resolveBaselineKm(
      odometer: ref.read(odometerRepositoryProvider),
      carId: carId,
      distanceUnit: _form.distanceUnit,
    );
    if (!mounted) return;
    _form.setBaselineOdometerKm(baselineKm);
    if (!fillAbsoluteField) return;
    final text = ReminderOdometerPrefill.absoluteFieldText(
      baselineKm: baselineKm,
      mode: _form.odometerInputMode,
      distanceUnit: _form.distanceUnit,
      currentText: _odometerController.text,
    );
    if (text != null) {
      _odometerController.text = text;
    }
  }

  void _onCarIdChanged(int? id) {
    _form.setCarId(id);
    if (widget.existing != null) return;
    _odometerController.clear();
    _remindBeforeKmController.clear();
    _form.setBaselineOdometerKm(null);
    _form.setOdometerInputMode(ReminderOdometerInputMode.after);
    _form.setUseOdometer(false);
    _loadBaseline();
  }

  void _onUseOdometerChanged(bool value) {
    _form.setUseOdometer(value);
    if (value) {
      _loadBaseline(fillAbsoluteField: true);
    }
  }

  void _onOdometerInputModeChanged(ReminderOdometerInputMode mode) {
    _form.setOdometerInputMode(mode);
    final text = ReminderOdometerPrefill.absoluteFieldText(
      baselineKm: _form.baselineOdometerKm,
      mode: mode,
      distanceUnit: _form.distanceUnit,
      currentText: _odometerController.text,
    );
    if (text != null) {
      _odometerController.text = text;
    }
  }

  @override
  void dispose() {
    _form.dispose();
    _titleController.dispose();
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

  Future<void> _save() async {
    final outcome = await _form.save(
      titleText: _titleController.text,
      remindBeforeDaysText: _remindBeforeDaysController.text,
      odometerText: _odometerController.text,
      remindBeforeKmText: _remindBeforeKmController.text,
      saveUseCase: ref.read(saveReminderUseCaseProvider),
    );
    if (!mounted) return;
    if (outcome is ReminderFormSubmitSuccess) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _delete() async {
    if (widget.existing == null || _form.saving) return;

    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmFormDelete(
      context: context,
      message: l10n.reminderDeleteConfirm,
    );
    if (!confirmed || !mounted) return;

    final outcome =
        await _form.delete(ref.read(deleteReminderUseCaseProvider));
    if (!mounted) return;
    if (outcome is ReminderFormSubmitSuccess) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final carRepository = ref.watch(carRepositoryProvider);

    return FormSessionScaffold(
      title: widget.existing == null
          ? l10n.reminderAddTitle
          : l10n.reminderEditTitle,
      listenable: _form,
      body: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.reminderTitleLabel,
                errorText: _form.titleError == ReminderFormTitleError.required
                    ? l10n.reminderTitleRequired
                    : null,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: _sectionGap),
            StreamBuilder<List<CarListItem>>(
              stream: carRepository.watchAll(),
              builder: (context, snapshot) {
                final cars = snapshot.data ?? const <CarListItem>[];
                final selectedId = cars.any((c) => c.id == _form.carId)
                    ? _form.carId
                    : null;
                return DropdownMenu<int>(
                  key: ValueKey('car-$selectedId-${cars.length}'),
                  initialSelection: selectedId,
                  label: Text(l10n.reminderCarLabel),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: [
                    for (final item in cars)
                      DropdownMenuEntry(
                        value: item.id,
                        label: item.displayTitle,
                      ),
                  ],
                  onSelected: _onCarIdChanged,
                );
              },
            ),
            const SizedBox(height: _sectionGap),
            ReminderTriggerFields(
              useDate: _form.useDate,
              useOdometer: _form.useOdometer,
              dueAt: _form.dueAt,
              distanceUnit: _form.distanceUnit,
              odometerController: _odometerController,
              remindBeforeDaysController: _remindBeforeDaysController,
              remindBeforeKmController: _remindBeforeKmController,
              triggerError: _form.triggerError,
              odometerError: _form.odometerError,
              remindBeforeDaysError: _form.remindBeforeDaysError,
              remindBeforeKmError: _form.remindBeforeKmError,
              onUseDateChanged: _form.setUseDate,
              onUseOdometerChanged: _onUseOdometerChanged,
              onPickDate: _pickDate,
              odometerInputMode: _form.odometerInputMode,
              onOdometerInputModeChanged: _onOdometerInputModeChanged,
              baselineOdometerKm: _form.baselineOdometerKm,
              sectionGap: _sectionGap,
            ),
            const SizedBox(height: _sectionGap),
            if (widget.existing != null)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.reminderCompleted),
                value: _form.isCompleted,
                onChanged: _form.setCompleted,
              ),
            if (widget.existing != null) const SizedBox(height: _sectionGap),
            FormActionsBar(
              isSaving: _form.saving,
              onSave: _save,
              onDelete: widget.existing != null ? _delete : null,
            ),
          ],
        );
      },
    );
  }
}

