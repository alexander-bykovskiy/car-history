import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/event_date_limits.dart';
import '../../../../core/number_formatting.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/form_actions_bar.dart';
import '../../../../shared/presentation/odometer_sequence_dialog.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../controllers/fueling_form_loader.dart';
import '../controllers/fueling_form_notifier.dart';
import '../models/fueling_form_data.dart';
import '../../di/fueling_providers.dart';
import '../widgets/fueling_form_fields.dart';

class FuelingFormPage extends ConsumerStatefulWidget {
  const FuelingFormPage({
    required this.carId,
    required this.volumeUnit,
    required this.distanceUnit,
    required this.currencyCode,
    this.existing,
    this.deleteId,
    this.initialFuelTypeName,
    this.initialGasStationName,
    super.key,
  });

  final int carId;
  final FuelVolumeUnit volumeUnit;
  final DistanceUnit distanceUnit;
  final String currencyCode;
  final FuelingFormData? existing;
  final int? deleteId;

  /// From list join — set immediately so edit does not wait on async lookup.
  final String? initialFuelTypeName;
  final String? initialGasStationName;

  bool get isEditing => existing != null;

  @override
  ConsumerState<FuelingFormPage> createState() => _FuelingFormPageState();
}

class _FuelingFormPageState extends ConsumerState<FuelingFormPage> {
  late final FuelingFormNotifier _form;
  late final TextEditingController _fuelTypeController;
  late final TextEditingController _gasStationController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _totalController;
  late final TextEditingController _odometerController;
  late final FocusNode _fuelTypeFocus;
  late final FocusNode _gasStationFocus;

  @override
  void initState() {
    super.initState();
    _form = FuelingFormNotifier(
      carId: widget.carId,
      volumeUnit: widget.volumeUnit,
      distanceUnit: widget.distanceUnit,
      currencyCode: widget.currencyCode,
      existing: widget.existing,
      deleteId: widget.deleteId,
    );

    final existing = widget.existing;
    _fuelTypeController = TextEditingController(
      text: widget.initialFuelTypeName ?? existing?.fuelTypeName ?? '',
    );
    _gasStationController = TextEditingController(
      text: widget.initialGasStationName ?? existing?.gasStationName ?? '',
    );
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _totalController = TextEditingController();
    _odometerController = TextEditingController();
    _fuelTypeFocus = FocusNode();
    _gasStationFocus = FocusNode();

    if (existing != null) {
      final pricePerUnit =
          widget.volumeUnit.priceFromPerLiter(existing.pricePerLiter);
      final quantity = widget.volumeUnit.fromLiters(existing.liters);
      _priceController.text = formatFlexibleDouble(pricePerUnit);
      _quantityController.text = formatFlexibleDouble(quantity);
      _totalController.text = formatFlexibleDouble(existing.totalAmount);
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
    const loader = FuelingFormLoader();
    final existing = widget.existing;
    if (existing != null) {
      final names = await loader.loadExistingNames(
        existing: existing,
        fuelTypes: ref.read(fuelTypeRepositoryProvider),
        gasStations: ref.read(gasStationRepositoryProvider),
      );
      if (!mounted) return;
      if (names.fuelTypeName != null) {
        _fuelTypeController.text = names.fuelTypeName!;
      }
      if (names.gasStationLabel != null) {
        _gasStationController.text = names.gasStationLabel!;
      }
      return;
    }

    final prefill = await loader.prefillFromLast(
      carId: widget.carId,
      volumeUnit: widget.volumeUnit,
      distanceUnit: widget.distanceUnit,
      fuelings: ref.read(fuelingRepositoryProvider),
      fuelTypes: ref.read(fuelTypeRepositoryProvider),
      gasStations: ref.read(gasStationRepositoryProvider),
      odometer: ref.read(odometerRepositoryProvider),
    );
    if (!mounted) return;
    if (prefill.fuelTypeName != null) {
      _fuelTypeController.text = prefill.fuelTypeName!;
    }
    if (prefill.gasStationLabel != null) {
      _gasStationController.text = prefill.gasStationLabel!;
    }
    if (prefill.priceText != null) {
      _priceController.text = prefill.priceText!;
    }
    if (prefill.odometerText != null) {
      _odometerController.text = prefill.odometerText!;
    }
  }

  @override
  void dispose() {
    _form.dispose();
    _fuelTypeController.dispose();
    _gasStationController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _totalController.dispose();
    _odometerController.dispose();
    _fuelTypeFocus.dispose();
    _gasStationFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _form.fueledAt,
      firstDate: kMinEventDate,
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null || !mounted) return;
    _form.setFueledAt(picked);
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context);
    final outcome = await _form.submit(
      save: ref.read(saveFuelingUseCaseProvider),
      odometer: ref.read(odometerRepositoryProvider),
      fuelTypeName: _fuelTypeController.text,
      gasStationName: _gasStationController.text,
      priceText: _priceController.text,
      quantityText: _quantityController.text,
      totalText: _totalController.text,
      odometerText: _odometerController.text,
      quantityController: _quantityController,
      totalController: _totalController,
      confirmOdometer: (details) {
        return showOdometerSequenceWarningDialog(
          context: context,
          warning: details.warning,
          neighbors: details.neighbors,
          displayFromKilometers: widget.distanceUnit.fromKilometers,
          distanceUnitLabel: distanceUnitShort(l10n, widget.distanceUnit),
          footer: l10n.fuelingOdometerWarningFooter,
        );
      },
    );
    if (!mounted) return;
    switch (outcome) {
      case FuelingFormSubmitSuccess():
        Navigator.of(context).pop(true);
      case FuelingFormSubmitUnexpected():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formActionFailed)),
        );
      case FuelingFormSubmitFieldError():
      case FuelingFormSubmitCancelled():
      case FuelingFormSubmitBusy():
        break;
    }
  }

  Future<void> _delete() async {
    if (!_form.isEditing || _form.saving) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.fuelingDeleteConfirm,
    );
    if (confirmed != true || !mounted) return;
    final outcome = await _form.delete(ref.read(deleteFuelingUseCaseProvider));
    if (!mounted) return;
    switch (outcome) {
      case FuelingFormSubmitSuccess():
        Navigator.of(context).pop(true);
      case FuelingFormSubmitUnexpected():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formActionFailed)),
        );
      case FuelingFormSubmitFieldError():
      case FuelingFormSubmitCancelled():
      case FuelingFormSubmitBusy():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? l10n.fuelingEditTitle : l10n.fuelingAddTitle,
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
                FuelingFormFields(
                  form: _form,
                  carId: widget.carId,
                  volumeUnit: widget.volumeUnit,
                  distanceUnit: widget.distanceUnit,
                  fuelTypeController: _fuelTypeController,
                  gasStationController: _gasStationController,
                  priceController: _priceController,
                  quantityController: _quantityController,
                  totalController: _totalController,
                  odometerController: _odometerController,
                  fuelTypeFocus: _fuelTypeFocus,
                  gasStationFocus: _gasStationFocus,
                  onPickDate: _pickDate,
                  onSubmit: _onSubmit,
                ),
                const SizedBox(height: 24),
                FormActionsBar(
                  isSaving: _form.saving,
                  onSave: _onSubmit,
                  onDelete: widget.isEditing ? _delete : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
