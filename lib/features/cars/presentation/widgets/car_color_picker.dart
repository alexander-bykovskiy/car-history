import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../theme/car_theme_config.dart';

export '../../../../theme/car_theme_config.dart' show kCarColorOptions;

class CarColorPicker extends StatelessWidget {
  const CarColorPicker({
    required this.selectedArgb,
    required this.onChanged,
    super.key,
  });

  final int? selectedArgb;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.carColorLabel, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final color in kCarColorOptions)
              _ColorSwatch(
                color: color,
                selected: selectedArgb == color.toARGB32(),
                onTap: () {
                  final value = color.toARGB32();
                  onChanged(selectedArgb == value ? null : value);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.55;
    final borderColor =
        isLight ? ThemeSemantics.swatchBorder : Colors.transparent;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: selected
            ? Icon(
                Icons.check,
                size: 20,
                color: isLight ? Colors.black87 : Colors.white,
              )
            : null,
      ),
    );
  }
}
