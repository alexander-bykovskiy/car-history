import 'package:flutter/material.dart';

import '../domain/entities/catalog_save_result.dart';
import 'catalog_save_result_handler.dart';

/// Localized messages shared by catalog create/edit dialogs.
class CatalogSaveUiMessages {
  const CatalogSaveUiMessages({
    required this.emptyName,
    required this.alreadyExists,
    required this.restoreConfirm,
  });

  final String emptyName;
  final String alreadyExists;
  final String restoreConfirm;
}

/// Runs [save], checks [context.mounted], then [handleCatalogSaveResult].
Future<bool> submitCatalogDialogSave<T>({
  required BuildContext context,
  required Future<({CatalogSaveResult result, T? restorable})> Function() save,
  required CatalogSaveUiMessages messages,
  required ValueChanged<String> onError,
  required Future<void> Function(T restorable) onRestore,
}) async {
  final outcome = await save();
  if (!context.mounted) return false;
  final restorable = outcome.restorable;
  return handleCatalogSaveResult(
    context: context,
    result: outcome.result,
    emptyNameMessage: messages.emptyName,
    alreadyExistsMessage: messages.alreadyExists,
    restoreConfirmMessage: messages.restoreConfirm,
    onError: onError,
    hasRestorableItem: restorable != null,
    onRestore: () async {
      if (restorable == null) return;
      await onRestore(restorable);
    },
  );
}

/// Same as [submitCatalogDialogSave] when success should return the entity.
Future<T?> submitCatalogDialogSaveForItem<T>({
  required BuildContext context,
  required Future<({CatalogSaveResult result, T? item})> Function() save,
  required CatalogSaveUiMessages messages,
  required ValueChanged<String> onError,
  required Future<void> Function(T item) onRestore,
}) async {
  final outcome = await save();
  if (!context.mounted) return null;
  return handleCatalogSaveResultForItem<T>(
    context: context,
    result: outcome.result,
    item: outcome.item,
    emptyNameMessage: messages.emptyName,
    alreadyExistsMessage: messages.alreadyExists,
    restoreConfirmMessage: messages.restoreConfirm,
    onError: onError,
    onRestore: onRestore,
  );
}
