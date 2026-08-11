import 'package:flutter/material.dart';

/// Text-looking currency code control for [InputDecoration.suffixIcon].
class CurrencyCodeFieldButton extends StatelessWidget {
  const CurrencyCodeFieldButton({
    required this.currencyCode,
    required this.onPressed,
    super.key,
  });

  final String currencyCode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface;
    return IconButton(
      onPressed: onPressed,
      tooltip: currencyCode,
      style: IconButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Text(
        currencyCode,
        style: theme.textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Picks a currency from [codes]. Returns the selected code, or null if cancelled.
///
/// Ensures [selectedCode] appears in the list even when missing from [codes].
Future<String?> pickFormCurrencyCode({
  required BuildContext context,
  required List<String> codes,
  required String selectedCode,
  required String title,
}) {
  final list = List<String>.from(codes);
  if (!list.contains(selectedCode)) {
    list.insert(0, selectedCode);
  }
  return showCurrencyCodePicker(
    context: context,
    codes: list,
    selectedCode: selectedCode,
    title: title,
  );
}

/// Picks a currency from [codes]. Returns the selected code, or null if cancelled.
Future<String?> showCurrencyCodePicker({
  required BuildContext context,
  required List<String> codes,
  required String selectedCode,
  required String title,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.5;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  title,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final code in codes)
                      ListTile(
                        title: Text(code),
                        trailing: code == selectedCode
                            ? Icon(
                                Icons.check,
                                color: Theme.of(sheetContext)
                                    .colorScheme
                                    .primary,
                              )
                            : null,
                        onTap: () => Navigator.of(sheetContext).pop(code),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
