import 'package:flutter/material.dart';

import '../../domain/entities/car_brand.dart';
import '../../domain/repositories/car_brand_repository.dart';
import '../../../../l10n/app_localizations.dart';

/// Material [Autocomplete] for car brands: filters on type, hides on blur.
class BrandAutocompleteField extends StatelessWidget {
  const BrandAutocompleteField({
    required this.repository,
    required this.controller,
    required this.focusNode,
    this.errorText,
    super.key,
  });

  final CarBrandRepository repository;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return RawAutocomplete<CarBrandItem>(
      textEditingController: controller,
      focusNode: focusNode,
      displayStringForOption: (option) => option.name,
      optionsBuilder: (textEditingValue) async {
        return repository.search(textEditingValue.text);
      },
      optionsViewBuilder: (context, onSelected, options) {
        if (options.isEmpty) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 400),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(option.name),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (
        context,
        textController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: l10n.carBrandLabel,
            errorText: errorText,
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }
}
