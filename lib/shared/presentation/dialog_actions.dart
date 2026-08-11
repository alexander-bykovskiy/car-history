import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/car_theme_config.dart';

/// Shared [AlertDialog.actions] builders (outline cancel + filled confirm).
abstract final class DialogActions {
  static ButtonStyle outlineCancelStyle(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return OutlinedButton.styleFrom(
      foregroundColor: outline,
      side: BorderSide(color: outline),
    );
  }

  /// Cancel + primary confirm (Save by default).
  static List<Widget> cancelConfirm({
    required BuildContext context,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? cancelLabel,
    String? confirmLabel,
    ButtonStyle? confirmStyle,
  }) {
    final l10n = AppLocalizations.of(context);
    return [
      OutlinedButton(
        onPressed: onCancel ?? () => Navigator.of(context).pop(false),
        style: outlineCancelStyle(context),
        child: Text(cancelLabel ?? l10n.actionCancel),
      ),
      FilledButton(
        onPressed: onConfirm,
        style: confirmStyle,
        child: Text(confirmLabel ?? l10n.actionSave),
      ),
    ];
  }

  /// Destructive confirm (Delete) with red filled button.
  static List<Widget> cancelDelete({
    required BuildContext context,
    required VoidCallback onDelete,
    VoidCallback? onCancel,
  }) {
    final l10n = AppLocalizations.of(context);
    return cancelConfirm(
      context: context,
      onCancel: onCancel,
      onConfirm: onDelete,
      confirmLabel: l10n.actionDelete,
      confirmStyle: FilledButton.styleFrom(
        backgroundColor: ThemeSemantics.destructive,
        foregroundColor: ThemeSemantics.onDestructive,
      ),
    );
  }

  /// Single outline cancel (e.g. dismiss-only pickers).
  static List<Widget> cancelOnly({
    required BuildContext context,
    VoidCallback? onCancel,
    String? cancelLabel,
  }) {
    final l10n = AppLocalizations.of(context);
    return [
      OutlinedButton(
        onPressed: onCancel ?? () => Navigator.of(context).pop(),
        style: outlineCancelStyle(context),
        child: Text(cancelLabel ?? l10n.actionCancel),
      ),
    ];
  }
}
