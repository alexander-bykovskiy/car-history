import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/event_date_limits.dart';
import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/currency_code_field_button.dart';
import '../../../../shared/presentation/date_form_field.dart';
import '../../../../shared/presentation/decimal_input_formatters.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../catalog/presentation/widgets/service_autocomplete_field.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../di/maintenance_providers.dart';
import '../controllers/maintenance_form_notifier.dart';
import '../maintenance_failure_messages.dart';

class MaintenanceFormFields extends ConsumerWidget {
  const MaintenanceFormFields({
    required this.form,
    required this.distanceUnit,
    required this.serviceController,
    required this.totalController,
    required this.odometerController,
    required this.serviceFocus,
    super.key,
  });

  final MaintenanceFormNotifier form;
  final DistanceUnit distanceUnit;
  final TextEditingController serviceController;
  final TextEditingController totalController;
  final TextEditingController odometerController;
  final FocusNode serviceFocus;

  static const sectionGap = 16.0;

  String? _serviceErrorText(AppLocalizations l10n) {
    final error = form.serviceError;
    return error == null ? null : maintenanceFailureMessage(l10n, error);
  }

  String? _totalErrorText(AppLocalizations l10n) {
    final error = form.totalError;
    return error == null ? null : maintenanceFailureMessage(l10n, error);
  }

  String? _odometerErrorText(AppLocalizations l10n) {
    final error = form.odometerError;
    return error == null ? null : maintenanceFailureMessage(l10n, error);
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: form.servicedAt,
      firstDate: kMinEventDate,
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    form.setServicedAt(picked);
  }

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
    if (selected == null || selected == form.currencyCode) return;
    form.setCurrencyCode(selected);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(locale);
    final distanceShort = distanceUnitShort(l10n, distanceUnit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateFormField(
          label: l10n.maintenanceDateLabel,
          valueText: dateFormat.format(form.servicedAt),
          onPick: () => _pickDate(context),
        ),
        const SizedBox(height: sectionGap),
        ServiceAutocompleteField(
          repository: ref.watch(serviceRepositoryProvider),
          controller: serviceController,
          focusNode: serviceFocus,
          errorText: _serviceErrorText(l10n),
          onChanged: (_) => form.clearServiceError(),
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: totalController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.maintenanceTotalLabel,
            errorText: _totalErrorText(l10n),
            border: const OutlineInputBorder(),
            suffixIcon: CurrencyCodeFieldButton(
              currencyCode: form.currencyCode,
              onPressed: () => _pickCurrency(context, ref),
            ),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            form.clearTotalError();
          },
        ),
        const SizedBox(height: sectionGap),
        TextField(
          controller: odometerController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalNumberInputFormatters,
          decoration: InputDecoration(
            labelText: l10n.fuelingOdometerLabel(distanceShort),
            errorText: _odometerErrorText(l10n),
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (_) => form.clearOdometerError(),
        ),
      ],
    );
  }
}
