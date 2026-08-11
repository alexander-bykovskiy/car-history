import 'package:flutter/material.dart';

/// Single event row on the timeline rail.
class EventTimelineTile extends StatelessWidget {
  const EventTimelineTile({
    required this.isFirst,
    required this.isLast,
    required this.icon,
    required this.date,
    required this.details,
    this.dateSuffix,
    this.total,
    this.onDoubleTap,
    super.key,
  });

  final bool isFirst;
  final bool isLast;
  final IconData icon;
  final String date;
  final String? dateSuffix;
  final InlineSpan details;
  final InlineSpan? total;
  final VoidCallback? onDoubleTap;

  static const double _iconSize = 36;
  static const double _lineWidth = 2;
  static const double _railWidth = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final lineColor = accent.withValues(alpha: 0.35);
    final surface = theme.scaffoldBackgroundColor;
    final amountStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.0,
    );

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        color: surface,
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
                        icon,
                        size: 18,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: _lineWidth,
                          color: isLast ? Colors.transparent : lineColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: date, style: amountStyle),
                                    if (dateSuffix != null &&
                                        dateSuffix!.isNotEmpty)
                                      TextSpan(
                                        text: ' ($dateSuffix)',
                                        style: amountStyle?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              (amountStyle.fontSize ?? 16) *
                                                  0.78,
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (total != null) ...[
                              const SizedBox(width: 8),
                              Text.rich(total!, style: amountStyle),
                            ],
                          ],
                        ),
                        if (details.toPlainText().trim().isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text.rich(
                            details,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
