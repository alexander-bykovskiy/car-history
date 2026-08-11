import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Asks the user whether to restore a soft-deleted catalog item.
Future<bool> showCatalogRestoreConfirm(
  BuildContext context,
  String message,
) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.actionRestore),
          ),
        ],
      );
    },
  );
  return result == true;
}

/// Shows restore confirm, then runs [onRestore] when accepted.
Future<bool> confirmAndRestoreCatalogItem({
  required BuildContext context,
  required String confirmMessage,
  required Future<void> Function() onRestore,
}) async {
  if (!context.mounted) return false;
  final shouldRestore = await showCatalogRestoreConfirm(context, confirmMessage);
  if (!shouldRestore || !context.mounted) return false;
  await onRestore();
  return true;
}
