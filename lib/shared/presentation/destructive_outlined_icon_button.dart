import 'package:flutter/material.dart';

import '../../theme/car_theme_config.dart';

/// Circular outlined icon button for destructive actions (delete / remove).
///
/// Disabled state dims both the icon and the border (Material opacity 0.38).
class DestructiveOutlinedIconButton extends StatelessWidget {
  const DestructiveOutlinedIconButton({
    required this.onPressed,
    required this.tooltip,
    this.icon = Icons.delete_outline,
    this.color,
    super.key,
  });

  final VoidCallback? onPressed;
  final String tooltip;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final destructive = color ?? ThemeSemantics.destructive;
    final disabled = destructive.withValues(alpha: 0.38);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: tooltip,
      child: IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          foregroundColor: destructive,
          disabledForegroundColor: disabled,
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            final borderColor =
                states.contains(WidgetState.disabled) ? disabled : destructive;
            return BorderSide(color: borderColor);
          }),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
