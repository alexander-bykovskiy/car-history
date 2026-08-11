import 'package:flutter/material.dart';

import '../../../shared/presentation/catalog_restore_confirm.dart';
import '../domain/entities/catalog_save_result.dart';

/// Shared handling for catalog create/update outcomes (bool success path).
Future<bool> handleCatalogSaveResult({
  required BuildContext context,
  required CatalogSaveResult result,
  required String emptyNameMessage,
  required String alreadyExistsMessage,
  required String restoreConfirmMessage,
  required ValueChanged<String> onError,
  required Future<void> Function() onRestore,
  bool hasRestorableItem = true,
}) async {
  switch (result) {
    case CatalogSaveResult.emptyName:
      onError(emptyNameMessage);
      return false;
    case CatalogSaveResult.alreadyExists:
      onError(alreadyExistsMessage);
      return false;
    case CatalogSaveResult.needsRestoreConfirm:
      if (!hasRestorableItem) return false;
      if (!context.mounted) return false;
      return confirmAndRestoreCatalogItem(
        context: context,
        confirmMessage: restoreConfirmMessage,
        onRestore: onRestore,
      );
    case CatalogSaveResult.created:
    case CatalogSaveResult.updated:
    case CatalogSaveResult.restored:
      return true;
  }
}

/// Shared handling when success should return the saved entity (e.g. chain).
Future<T?> handleCatalogSaveResultForItem<T>({
  required BuildContext context,
  required CatalogSaveResult result,
  required T? item,
  required String emptyNameMessage,
  required String alreadyExistsMessage,
  required String restoreConfirmMessage,
  required ValueChanged<String> onError,
  required Future<void> Function(T item) onRestore,
}) async {
  switch (result) {
    case CatalogSaveResult.emptyName:
      onError(emptyNameMessage);
      return null;
    case CatalogSaveResult.alreadyExists:
      onError(alreadyExistsMessage);
      return null;
    case CatalogSaveResult.needsRestoreConfirm:
      if (item == null) return null;
      if (!context.mounted) return null;
      final restored = await confirmAndRestoreCatalogItem(
        context: context,
        confirmMessage: restoreConfirmMessage,
        onRestore: () => onRestore(item),
      );
      return restored ? item : null;
    case CatalogSaveResult.created:
    case CatalogSaveResult.updated:
    case CatalogSaveResult.restored:
      return item;
  }
}
