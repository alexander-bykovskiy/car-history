import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/number_formatting.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/decimal_input_formatters.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../../catalog/domain/entities/named_catalog_item.dart';
import '../../../catalog/presentation/widgets/part_autocomplete_field.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../di/maintenance_providers.dart';
import '../../domain/usecases/save_maintenance.dart';
import '../controllers/maintenance_part_dialog_notifier.dart';
import '../maintenance_failure_messages.dart';
import '../models/draft_part_line.dart';

class MaintenancePartDialog extends ConsumerStatefulWidget {
  const MaintenancePartDialog({
    required this.carId,
    required this.currencyCode,
    required this.nextLocalId,
    this.existing,
    super.key,
  });

  final int carId;
  final String currencyCode;
  final int nextLocalId;
  final DraftPartLine? existing;

  @override
  ConsumerState<MaintenancePartDialog> createState() =>
      _MaintenancePartDialogState();
}

class _MaintenancePartDialogState extends ConsumerState<MaintenancePartDialog> {
  late final MaintenancePartDialogNotifier _form;
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _amountController;
  late final TextEditingController _commentController;
  late final FocusNode _nameFocus;
  bool _loadStarted = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _form = MaintenancePartDialogNotifier(
      nextLocalId: widget.nextLocalId,
      existing: existing,
    );
    _nameController = TextEditingController(text: existing?.name ?? '');
    _quantityController = TextEditingController(
      text: formatFlexibleDouble(existing?.quantity ?? 1),
    );
    _amountController = TextEditingController(
      text: existing?.amount == null
          ? ''
          : formatFlexibleDouble(existing!.amount!),
    );
    _commentController = TextEditingController(
      text: existing?.comment ?? '',
    );
    _nameFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadStarted) return;
    _loadStarted = true;
    _form.loadUnits(
      units: ref.read(partUnitRepositoryProvider),
      readLastUnitId: () => ref.read(lastPartUnitIdProvider.future),
    );
  }

  @override
  void dispose() {
    _form.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    _commentController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final line = await _form.submit(
      nameText: _nameController.text,
      quantityText: _quantityController.text,
      amountText: _amountController.text,
      commentText: _commentController.text,
      persistLastUnit: (unitId) =>
          ref.read(lastPartUnitIdProvider.notifier).set(unitId),
    );
    if (!mounted || line == null) return;
    Navigator.of(context).pop(line);
  }

  String? _mapError(
    SaveMaintenanceFailure? error,
    AppLocalizations l10n,
  ) {
    if (error == null) return null;
    return maintenanceFailureMessage(l10n, error);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existing = widget.existing;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));

    return ListenableBuilder(
      listenable: _form,
      builder: (context, _) {
        if (_form.unitsLoading) {
          return AlertDialog(
            shape: shape,
            content: const SizedBox(
              width: 360,
              height: 96,
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        return AlertDialog(
          shape: shape,
          title: Text(
            existing == null
                ? l10n.maintenancePartAddTitle
                : l10n.maintenancePartEditTitle,
          ),
          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PartAutocompleteField(
                    repository: ref.watch(partRepositoryProvider),
                    carId: widget.carId,
                    controller: _nameController,
                    focusNode: _nameFocus,
                    errorText: _mapError(_form.nameError, l10n),
                    onChanged: (_) => _form.clearNameError(),
                  ),
                  const SizedBox(height: 16),
                  _QuantityUnitRow(
                    quantityController: _quantityController,
                    quantityError: _mapError(_form.quantityError, l10n),
                    onQuantityChanged: (_) => _form.clearQuantityError(),
                    units: _form.units,
                    unitId: _form.unitId,
                    onUnitChanged: _form.setUnitId,
                    unitLabel: l10n.maintenancePartUnitLabel,
                    quantityLabel: l10n.maintenancePartQuantityLabel,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: decimalNumberInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.maintenancePartAmountLabel,
                      errorText: _mapError(_form.amountError, l10n),
                      border: const OutlineInputBorder(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Align(
                          widthFactor: 1,
                          alignment: Alignment.center,
                          child: Text(
                            widget.currencyCode,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _form.clearAmountError(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    minLines: 1,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.maintenancePartCommentLabel,
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onSubmit(),
                  ),
                ],
              ),
            ),
          ),
          actions: DialogActions.cancelConfirm(
            context: context,
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: _onSubmit,
          ),
        );
      },
    );
  }
}

class _QuantityUnitRow extends StatelessWidget {
  const _QuantityUnitRow({
    required this.quantityController,
    required this.quantityError,
    required this.onQuantityChanged,
    required this.units,
    required this.unitId,
    required this.onUnitChanged,
    required this.unitLabel,
    required this.quantityLabel,
  });

  final TextEditingController quantityController;
  final String? quantityError;
  final ValueChanged<String> onQuantityChanged;
  final List<NamedCatalogItem> units;
  final int? unitId;
  final ValueChanged<int?> onUnitChanged;
  final String unitLabel;
  final String quantityLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: decimalNumberInputFormatters,
            decoration: InputDecoration(
              labelText: quantityLabel,
              errorText: quantityError,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: onQuantityChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownMenu<int>(
            key: ValueKey('unit-$unitId-${units.length}'),
            initialSelection: unitId,
            label: Text(unitLabel),
            expandedInsets: EdgeInsets.zero,
            enabled: units.isNotEmpty,
            dropdownMenuEntries: [
              for (final unit in units)
                DropdownMenuEntry<int>(
                  value: unit.id,
                  label: unit.name,
                ),
            ],
            onSelected: onUnitChanged,
          ),
        ),
      ],
    );
  }
}
