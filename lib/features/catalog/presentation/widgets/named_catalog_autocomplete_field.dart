import 'package:flutter/material.dart';

import '../../domain/entities/named_catalog_item.dart';
import '../../../../shared/presentation/catalog_autocomplete_field.dart';

/// Autocomplete for car-scoped named catalog items (fuel type, part, …).
///
/// Free text is allowed; callers persist new names on save via ensure.
class NamedCatalogAutocompleteField extends StatelessWidget {
  const NamedCatalogAutocompleteField({
    required this.labelText,
    required this.optionsBuilder,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final String labelText;
  final Future<Iterable<NamedCatalogItem>> Function(String query)
      optionsBuilder;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CatalogAutocompleteField<NamedCatalogItem>(
      controller: controller,
      focusNode: focusNode,
      labelText: labelText,
      errorText: errorText,
      onChanged: onChanged,
      displayStringForOption: (option) => option.name,
      optionsBuilder: optionsBuilder,
    );
  }
}
