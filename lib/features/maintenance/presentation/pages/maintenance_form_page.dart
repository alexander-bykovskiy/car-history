import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/number_formatting.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/form_actions_bar.dart';
import '../../../../shared/presentation/form_session.dart';
import '../../../../shared/presentation/odometer_sequence_dialog.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../controllers/maintenance_form_loader.dart';
import '../controllers/maintenance_form_notifier.dart';
import '../maintenance_failure_messages.dart';
import '../models/maintenance_form_data.dart';
import '../../di/maintenance_providers.dart';
import '../widgets/maintenance_form_fields.dart';
import '../widgets/maintenance_parts_section.dart';
import '../widgets/maintenance_reminder_section.dart';

class MaintenanceFormPage extends ConsumerStatefulWidget {
  const MaintenanceFormPage({
    required this.carId,
    required this.distanceUnit,
    required this.currencyCode,
    this.existing,
    this.deleteId,
    this.initialServiceName,
    super.key,
  });

  final int carId;
  final DistanceUnit distanceUnit;
  final String currencyCode;
  final MaintenanceFormData? existing;
  final int? deleteId;
  final String? initialServiceName;

  bool get isEditing => existing != null;

  @override
  ConsumerState<MaintenanceFormPage> createState() =>
      _MaintenanceFormPageState();
}

class _MaintenanceFormPageState extends ConsumerState<MaintenanceFormPage> {
  late final MaintenanceFormNotifier _form;
  late final TextEditingController _serviceController;
  late final TextEditingController _totalController;
  late final TextEditingController _odometerController;
  late final FocusNode _serviceFocus;

  @override
  void initState() {
    super.initState();
    _form = MaintenanceFormNotifier(
      carId: widget.carId,
      distanceUnit: widget.distanceUnit,
      currencyCode: widget.currencyCode,
      existing: widget.existing,
      deleteId: widget.deleteId,
      initialServiceName: widget.initialServiceName,
    );

    final existing = widget.existing;
    _serviceController = TextEditingController(
      text: widget.initialServiceName ?? existing?.serviceName ?? '',
    );
    _totalController = TextEditingController();
    _odometerController = TextEditingController();
    _serviceFocus = FocusNode();

    if (existing != null) {
      if (existing.totalAmount != null) {
        _totalController.text = formatFlexibleDouble(existing.totalAmount!);
      }
      if (existing.odometerKm != null) {
        final odometer =
            widget.distanceUnit.fromKilometers(existing.odometerKm!);
        _odometerController.text = formatFlexibleDouble(odometer);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    const loader = MaintenanceFormLoader();
    final existing = widget.existing;
    if (existing != null) {
      final hydration = await loader.loadExisting(
        data: existing,
        services: ref.read(serviceRepositoryProvider),
        maintenances: ref.read(maintenanceRepositoryProvider),
        reminders: ref.read(reminderRepositoryProvider),
      );
      if (!mounted) return;
      _form.applyHydration(hydration);
      if (hydration.serviceName != null) {
        _serviceController.text = hydration.serviceName!;
      }
      return;
    }

    final prefill = await loader.prefillFromLast(
      carId: widget.carId,
      distanceUnit: widget.distanceUnit,
      maintenances: ref.read(maintenanceRepositoryProvider),
      services: ref.read(serviceRepositoryProvider),
      odometer: ref.read(odometerRepositoryProvider),
    );
    if (!mounted) return;
    if (prefill.serviceName != null) {
      _serviceController.text = prefill.serviceName!;
    }
    if (prefill.odometerText != null) {
      _odometerController.text = prefill.odometerText!;
    }
  }

  @override
  void dispose() {
    _form.dispose();
    _serviceController.dispose();
    _totalController.dispose();
    _odometerController.dispose();
    _serviceFocus.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context);
    final outcome = await _form.submit(
      save: ref.read(saveMaintenanceUseCaseProvider),
      odometer: ref.read(odometerRepositoryProvider),
      serviceName: _serviceController.text,
      totalText: _totalController.text,
      odometerText: _odometerController.text,
      confirmOdometer: (details) {
        return showOdometerSequenceWarningDialog(
          context: context,
          warning: details.warning,
          neighbors: details.neighbors,
          displayFromKilometers: widget.distanceUnit.fromKilometers,
          distanceUnitLabel: distanceUnitShort(l10n, widget.distanceUnit),
          footer: l10n.maintenanceOdometerWarningFooter,
        );
      },
    );

    if (!mounted) return;

    switch (outcome) {
      case MaintenanceFormSubmitSuccess():
        Navigator.of(context).pop(true);
      case MaintenanceFormSubmitSnack(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(maintenanceFailureMessage(l10n, error))),
        );
      case MaintenanceFormSubmitUnexpected():
        showFormActionFailedSnack(context);
      case MaintenanceFormSubmitFieldError():
      case MaintenanceFormSubmitCancelled():
      case MaintenanceFormSubmitBusy():
        break;
    }
  }

  Future<void> _delete() async {
    if (widget.deleteId == null || _form.saving) return;

    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmFormDelete(
      context: context,
      message: l10n.maintenanceDeleteConfirm,
    );
    if (!confirmed || !mounted) return;

    final outcome =
        await _form.delete(ref.read(deleteMaintenanceUseCaseProvider));
    if (!mounted) return;
    switch (outcome) {
      case MaintenanceFormSubmitSuccess():
        Navigator.of(context).pop(true);
      case MaintenanceFormSubmitUnexpected():
        showFormActionFailedSnack(context);
      case MaintenanceFormSubmitSnack():
      case MaintenanceFormSubmitFieldError():
      case MaintenanceFormSubmitCancelled():
      case MaintenanceFormSubmitBusy():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FormSessionScaffold(
      title: widget.isEditing
          ? l10n.maintenanceEditTitle
          : l10n.maintenanceAddTitle,
      listenable: Listenable.merge([_form, _totalController]),
      body: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MaintenanceFormFields(
              form: _form,
              distanceUnit: widget.distanceUnit,
              serviceController: _serviceController,
              totalController: _totalController,
              odometerController: _odometerController,
              serviceFocus: _serviceFocus,
            ),
            const SizedBox(height: 24),
            MaintenancePartsSection(
              form: _form,
              totalText: _totalController.text,
            ),
            const SizedBox(height: 24),
            MaintenanceReminderSection(
              form: _form,
              distanceUnit: widget.distanceUnit,
              odometerText: _odometerController.text,
            ),
            const SizedBox(height: 24),
            FormActionsBar(
              isSaving: _form.saving || !_form.hydrated,
              onSave: _onSubmit,
              onDelete: widget.isEditing ? _delete : null,
            ),
          ],
        );
      },
    );
  }
}
