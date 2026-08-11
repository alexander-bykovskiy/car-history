import 'package:flutter/material.dart';

/// Month chip on the event timeline rail.
class EventMonthHeaderTile extends StatelessWidget {
  const EventMonthHeaderTile({
    required this.isFirst,
    required this.title,
    required this.total,
    this.titleStyle,
    super.key,
  });

  final bool isFirst;
  final String title;
  final InlineSpan total;
  final TextStyle? titleStyle;

  static const double _iconSize = 36;
  static const double _lineWidth = 2;
  static const double _railWidth = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final onAccent = theme.colorScheme.onPrimary;
    final lineColor = accent.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _railWidth,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: _lineWidth,
                        color: isFirst ? Colors.transparent : lineColor,
                      ),
                    ),
                  ),
                  Container(
                    width: _iconSize,
                    height: _iconSize,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: accent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.18),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: onAccent,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: _lineWidth,
                        color: lineColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4, isFirst ? 4 : 10, 4, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(title, style: titleStyle),
                          ),
                          const SizedBox(width: 8),
                          Text.rich(
                            total,
                            style: titleStyle,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
