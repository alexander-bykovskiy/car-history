import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/currency_code_field_button.dart';
import '../../../../shared/presentation/date_form_field.dart';
import '../../../../shared/presentation/decimal_input_formatters.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../catalog/presentation/widgets/fuel_type_autocomplete_field.dart';
import '../../../catalog/presentation/widgets/gas_station_autocomplete_field.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../di/fueling_providers.dart';
import '../controllers/fueling_form_prepare.dart';
import '../controllers/fueling_form_notifier.dart';
import '../fueling_failure_messages.dart';

/// Field stack for [FuelingFormPage] (date, amounts, catalogs, odometer).
class FuelingFormFields extends ConsumerWidget {
  const FuelingFormFields({
    required this.form,
    required this.carId,
    required this.volumeUnit,
    required this.distanceUnit,
    required this.fuelTypeController,
    required this.gasStationController,
    required this.priceController,
    required this.quantityController,
    required this.totalController,
    required this.odometerController,
    required this.fuelTypeFocus,
    required this.gasStationFocus,
    required this.onPickDate,
    required this.onSubmit,
    super.key,
  });

  final FuelingFormNotifier form;
  final int carId;
  final FuelVolumeUnit volumeUnit;
  final DistanceUnit distanceUnit;
  final TextEditingController fuelTypeController;
  final TextEditingController gasStationController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController totalController;
  final TextEditingController odometerController;
  final FocusNode fuelTypeFocus;
  final FocusNode gasStationFocus;
  final VoidCallback onPickDate;
  final VoidCallback onSubmit;

  static const sectionGap = 16.0;

  Future<void> _pickCurrency(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final codes = await ref.read(currencyCodesProvider.future);
    if (!context.mounted) return;
    final selected = await pickFormCurrencyCode(
      context: context,
      codes: codes,
      selectedCode: form.currencyCode,
      title: l10n.settingsCurrency,
    );
    if (selected == null || !context.mounted) return;
    form.setCurrencyCode(selected);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(locale);
    final volumeShort = volumeUnitShort(l10n, volumeUnit);
    final distanceShort = distanceUnitShort(l10n, distanceUnit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateFormField(
          label: l10n.fuelingDateLabel,
          valueText: dateFormat.format(form.fueledAt),
          onPick: onPickDate,
        ),
        const SizedBox(height: sectionGap),
        FuelTypeAutocompleteField(
          repository: ref.watch(fuelTypeRepositoryProvider),
          carId: carId,
          controller: fuelTypeController,
          focusNode: fuelTypeFocus,
          errorText: fuelingFailureMessage(l10n, form.fuelTypeError),
          onChanged: (_) => form.clearFuelTypeError(),
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: priceController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.fuelingPriceLabel(volumeShort),
            errorText: fuelingFailureMessage(l10n, form.priceError),
            border: const OutlineInputBorder(),
            suffixIcon: CurrencyCodeFieldButton(
              currencyCode: form.currencyCode,
              onPressed: () => _pickCurrency(context, ref),
            ),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            form.clearPriceError();
            form.recalculate(
              priceController: priceController,
              quantityController: quantityController,
              totalController: totalController,
            );
          },
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.fuelingQuantityLabel(volumeShort),
            errorText: fuelingFailureMessage(l10n, form.amountError),
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            form.clearAmountError();
            form.recalculate(
              priceController: priceController,
              quantityController: quantityController,
              totalController: totalController,
              edited: FuelingAmountField.quantity,
            );
          },
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: totalController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.fuelingTotalLabel,
            errorText: form.amountError == null ? null : '\u200B',
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            border: const OutlineInputBorder(),
            suffixIcon: CurrencyCodeFieldButton(
              currencyCode: form.currencyCode,
              onPressed: () => _pickCurrency(context, ref),
            ),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            form.clearAmountError();
            form.recalculate(
              priceController: priceController,
              quantityController: quantityController,
              totalController: totalController,
              edited: FuelingAmountField.total,
            );
          },
        ),
        const SizedBox(height: sectionGap),
        GasStationAutocompleteField(
          repository: ref.watch(gasStationRepositoryProvider),
          controller: gasStationController,
          focusNode: gasStationFocus,
          errorText: fuelingFailureMessage(l10n, form.gasStationError),
          onChanged: (_) => form.clearGasStationError(),
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: odometerController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.fuelingOdometerLabel(distanceShort),
            errorText: fuelingFailureMessage(l10n, form.odometerError),
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (_) => form.clearOdometerError(),
          onSubmitted: (_) {
            if (!form.saving) onSubmit();
          },
        ),
      ],
    );
  }
}
