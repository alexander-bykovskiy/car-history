import 'package:flutter/material.dart';

/// Outlined date field matching other form inputs, with a calendar icon.
class DateFormField extends StatelessWidget {
  const DateFormField({
    required this.label,
    required this.valueText,
    required this.onPick,
    super.key,
  });

  final String label;
  final String valueText;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            tooltip: label,
            onPressed: onPick,
            icon: const Icon(Icons.calendar_today_outlined),
          ),
        ),
        child: Text(
          valueText,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
