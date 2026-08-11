import 'package:flutter/material.dart';

/// Accent period chip matching Data-tab month headers:
/// optional circular calendar + primary bar with title and total.
///
/// Optional [onPrevious]/[onNext] show chevrons for period navigation.
class PeriodHeaderBar extends StatelessWidget {
  const PeriodHeaderBar({
    required this.title,
    required this.total,
    super.key,
    this.showCalendar = true,
    this.onCalendarTap,
    this.onPeriodTap,
    this.onPrevious,
    this.onNext,
    this.titleStyle,
  });

  final String title;
  final InlineSpan total;
  final bool showCalendar;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onPeriodTap;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final TextStyle? titleStyle;

  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final onAccent = theme.colorScheme.onPrimary;
    final resolvedTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.0,
          color: onAccent,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (showCalendar) ...[
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
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onCalendarTap ?? onPeriodTap,
                  child: Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: onAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                final vx = details.primaryVelocity ?? 0;
                if (vx <= -200) {
                  onNext?.call();
                } else if (vx >= 200) {
                  onPrevious?.call();
                }
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: onPeriodTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          if (onPrevious != null)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              onPressed: onPrevious,
                              icon: Icon(
                                Icons.chevron_left,
                                color: onAccent,
                              ),
                              tooltip: MaterialLocalizations.of(context)
                                  .previousPageTooltip,
                            )
                          else
                            const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: resolvedTitleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text.rich(
                                    total,
                                    style: resolvedTitleStyle,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (onNext != null)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              onPressed: onNext,
                              icon: Icon(
                                Icons.chevron_right,
                                color: onAccent,
                              ),
                              tooltip: MaterialLocalizations.of(context)
                                  .nextPageTooltip,
                            )
                          else
                            const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
