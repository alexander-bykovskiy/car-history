import 'package:flutter/material.dart';

import '../../domain/entities/service_catalog_item.dart';
import '../../domain/repositories/service_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/catalog_autocomplete_field.dart';

/// Autocomplete for services; free text creates a new service on save.
class ServiceAutocompleteField extends StatelessWidget {
  const ServiceAutocompleteField({
    required this.repository,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final ServiceRepository repository;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CatalogAutocompleteField<ServiceCatalogItem>(
      controller: controller,
      focusNode: focusNode,
      labelText: l10n.maintenanceServiceLabel,
      errorText: errorText,
      onChanged: onChanged,
      displayStringForOption: (option) => option.name,
      optionsBuilder: (query) => repository.searchActive(query),
    );
  }
}
