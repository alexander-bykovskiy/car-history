import 'package:flutter/material.dart';

/// Same hue as [base], shifted darker by [tonesDarker] steps (~0.06 lightness each).
Color chartSeriesColor(Color base, {int tonesDarker = 3}) {
  final hsl = HSLColor.fromColor(base);
  final darkened = hsl.withLightness(
    (hsl.lightness - 0.06 * tonesDarker).clamp(0.12, 0.72),
  );
  return darkened.toColor();
}

class StatsLegendSwatch extends StatelessWidget {
  const StatsLegendSwatch({required this.color, required this.label, super.key});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
