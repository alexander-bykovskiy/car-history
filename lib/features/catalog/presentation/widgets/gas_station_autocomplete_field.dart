import 'package:flutter/material.dart';

import '../../domain/entities/gas_station.dart';
import '../../domain/repositories/gas_station_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_autocomplete_field.dart';

/// Autocomplete for gas station chains / locations.
class GasStationAutocompleteField extends StatelessWidget {
  const GasStationAutocompleteField({
    required this.repository,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final GasStationRepository repository;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CatalogAutocompleteField<GasStationPickOption>(
      controller: controller,
      focusNode: focusNode,
      labelText: l10n.fuelingGasStationLabel,
      errorText: errorText,
      onChanged: onChanged,
      displayStringForOption: (option) => option.label,
      optionTitleBuilder: (option) => option.chainName,
      optionSubtitleBuilder: (option) => option.address,
      optionsBuilder: (query) => repository.searchOptions(query),
    );
  }
}
