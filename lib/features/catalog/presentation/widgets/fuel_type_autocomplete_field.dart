import 'package:flutter/material.dart';

import '../../domain/repositories/fuel_type_repository.dart';
import '../../../../l10n/app_localizations.dart';
import 'named_catalog_autocomplete_field.dart';

/// Autocomplete for fuel types available to a car; free text creates a new type.
class FuelTypeAutocompleteField extends StatelessWidget {
  const FuelTypeAutocompleteField({
    required this.repository,
    required this.carId,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final FuelTypeRepository repository;
  final int carId;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NamedCatalogAutocompleteField(
      controller: controller,
      focusNode: focusNode,
      labelText: l10n.fuelingFuelTypeLabel,
      errorText: errorText,
      onChanged: onChanged,
      optionsBuilder: (query) => repository.searchForCar(carId, query),
    );
  }
}
