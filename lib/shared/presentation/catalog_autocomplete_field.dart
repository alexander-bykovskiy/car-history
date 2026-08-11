import 'package:flutter/material.dart';

/// Generic RawAutocomplete shell without feature-layer repository types.
///
/// Options open on tap (or while typing). After a selection the list closes
/// until the field is tapped again.
class CatalogAutocompleteField<T extends Object> extends StatefulWidget {
  const CatalogAutocompleteField({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.displayStringForOption,
    required this.optionsBuilder,
    this.errorText,
    this.onChanged,
    this.optionTitleBuilder,
    this.optionSubtitleBuilder,
    this.maxOptionsHeight = 200,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String Function(T option) displayStringForOption;
  final Future<Iterable<T>> Function(String query) optionsBuilder;
  final String Function(T option)? optionTitleBuilder;
  final String? Function(T option)? optionSubtitleBuilder;
  final double maxOptionsHeight;

  @override
  State<CatalogAutocompleteField<T>> createState() =>
      _CatalogAutocompleteFieldState<T>();
}

class _CatalogAutocompleteFieldState<T extends Object>
    extends State<CatalogAutocompleteField<T>> {
  bool _suppressFilter = false;
  bool _allowOptions = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CatalogAutocompleteField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) {
      _suppressFilter = false;
      _allowOptions = false;
    }
  }

  void _onUserEdited(String value) {
    _allowOptions = true;
    _suppressFilter = false;
    widget.onChanged?.call(value);
  }

  void _openOptionsOnTap() {
    _allowOptions = true;
    _suppressFilter = true;
    final text = widget.controller.text;
    _nudgeOptionsRebuild(text);
  }

  void _nudgeOptionsRebuild(String text) {
    widget.controller.value = TextEditingValue(
      text: '$text\u200B',
      selection: TextSelection.collapsed(offset: text.length + 1),
    );
    widget.controller.value = TextEditingValue(
      text: text,
      selection: text.isEmpty
          ? const TextSelection.collapsed(offset: 0)
          : TextSelection(baseOffset: 0, extentOffset: text.length),
    );
  }

  void _closeOptions() {
    _allowOptions = false;
    _suppressFilter = false;
    widget.focusNode.unfocus();
  }

  void _onPicked(T option) {
    widget.onChanged?.call(widget.displayStringForOption(option));
    _closeOptions();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      textEditingController: widget.controller,
      focusNode: widget.focusNode,
      displayStringForOption: widget.displayStringForOption,
      optionsBuilder: (textEditingValue) async {
        if (!_allowOptions) {
          return const Iterable.empty();
        }
        final query = _suppressFilter ? '' : textEditingValue.text;
        return widget.optionsBuilder(query);
      },
      onSelected: _onPicked,
      optionsViewBuilder: (context, onSelected, options) {
        if (options.isEmpty) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.maxOptionsHeight,
                maxWidth: 400,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  final title = widget.optionTitleBuilder?.call(option) ??
                      widget.displayStringForOption(option);
                  final subtitle = widget.optionSubtitleBuilder?.call(option);
                  return ListTile(
                    dense: true,
                    title: Text(title),
                    subtitle: subtitle == null || subtitle.isEmpty
                        ? null
                        : Text(subtitle),
                    onTap: () {
                      onSelected(option);
                      _closeOptions();
                    },
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
            labelText: widget.labelText,
            errorText: widget.errorText,
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTap: _openOptionsOnTap,
          onChanged: _onUserEdited,
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }
}
