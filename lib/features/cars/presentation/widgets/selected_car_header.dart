import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/reminder_alert_policy.dart';
import '../../../../theme/car_theme_config.dart';
import '../../di/cars_providers.dart';

/// Selected car row: photo, brand/model, year, reminder icon.
/// Double-tap cycles to the next car.
class SelectedCarHeader extends ConsumerWidget {
  const SelectedCarHeader({
    this.onRemindersTap,
    this.alertLevelStream,
    super.key,
  });

  /// Opens reminders; injected by composition root to avoid cars→reminders page import.
  final VoidCallback? onRemindersTap;

  /// Reminder alert level for the selected car; injected by composition root.
  final Stream<ReminderAlertLevel>? alertLevelStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(selectedCarProvider).value;
    if (item == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final title = item.displayTitle;
    final yearText = item.year == null ? null : '${item.year}';

    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onDoubleTap: () =>
            ref.read(selectedCarServiceProvider).selectNextCar(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: _CarLeading(
                  photo: item.photo,
                  colorArgb: item.colorArgb,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (yearText != null)
                      Text(
                        yearText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              StreamBuilder(
                key: ValueKey('reminder-alert-${item.id}'),
                stream: alertLevelStream,
                initialData: ReminderAlertLevel.none,
                builder: (context, snapshot) {
                  final level =
                      snapshot.data ?? ReminderAlertLevel.none;
                  return _ReminderIcon(
                    level: level,
                    onTap: () => onRemindersTap?.call(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderIcon extends StatelessWidget {
  const _ReminderIcon({
    required this.level,
    required this.onTap,
  });

  final ReminderAlertLevel level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color;
    final List<Shadow>? shadows;

    switch (level) {
      case ReminderAlertLevel.none:
        color = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1);
        shadows = null;
      case ReminderAlertLevel.soon:
        color = ThemeSemantics.alertSoon;
        shadows = [
          Shadow(
            color: ThemeSemantics.alertSoon.withValues(alpha: 0.75),
            blurRadius: 14,
          ),
          Shadow(
            color: ThemeSemantics.alertSoon.withValues(alpha: 0.35),
            blurRadius: 28,
          ),
        ];
      case ReminderAlertLevel.due:
        color = ThemeSemantics.alertDue;
        shadows = [
          Shadow(
            color: ThemeSemantics.alertDue.withValues(alpha: 0.8),
            blurRadius: 16,
          ),
          Shadow(
            color: ThemeSemantics.alertDue.withValues(alpha: 0.4),
            blurRadius: 32,
          ),
        ];
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Icon(
        Icons.warning_amber_rounded,
        size: 56,
        color: color,
        shadows: shadows,
      ),
    );
  }
}

class _CarLeading extends StatelessWidget {
  const _CarLeading({
    required this.photo,
    required this.colorArgb,
  });

  final Uint8List? photo;
  final int? colorArgb;

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          photo!,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _colorFallback(context),
        ),
      );
    }
    return _colorFallback(context);
  }

  Widget _colorFallback(BuildContext context) {
    final color = colorArgb != null ? Color(colorArgb!) : null;
    return CircleAvatar(
      radius: 32,
      backgroundColor:
          color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.directions_car_outlined,
        size: 32,
        color: color != null
            ? (color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white)
            : null,
      ),
    );
  }
}
