import 'package:flutter/material.dart';

import '../../theme/car_theme_config.dart';
import 'dialog_actions.dart';

/// Shared destructive-confirm dialog (cars, fuel types, …).
Future<bool> showDeleteConfirmDialog(
  BuildContext context, {
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final error = ThemeSemantics.destructive;
      final textStyle = theme.textTheme.bodyMedium ?? const TextStyle();
      final iconSize =
          (textStyle.fontSize ?? 14) * (textStyle.height ?? 1.43) * 2;
      const edge = 24.0;
      return Semantics(
        namesRoute: true,
        label: message,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.fromLTRB(edge, edge, edge, 16),
          actionsPadding: const EdgeInsets.fromLTRB(edge, 0, edge, edge / 2),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: error,
                size: iconSize,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: textStyle),
              ),
            ],
          ),
          actions: DialogActions.cancelDelete(
            context: context,
            onDelete: () => Navigator.of(context).pop(true),
          ),
        ),
      );
    },
  );
  return confirmed == true;
}
