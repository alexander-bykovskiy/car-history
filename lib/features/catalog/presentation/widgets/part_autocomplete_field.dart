import 'package:flutter/material.dart';

import '../../domain/repositories/part_repository.dart';
import '../../../../l10n/app_localizations.dart';
import 'named_catalog_autocomplete_field.dart';

/// Autocomplete for parts; free text creates a new part on save.
class PartAutocompleteField extends StatelessWidget {
  const PartAutocompleteField({
    required this.repository,
    required this.carId,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final PartRepository repository;
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
      labelText: l10n.maintenancePartNameLabel,
      errorText: errorText,
      onChanged: onChanged,
      optionsBuilder: (query) => repository.searchForCar(carId, query),
    );
  }
}
