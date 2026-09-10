import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../domain/entities/named_catalog_item.dart';
import '../catalog_dialog_submit.dart';

/// Shared name-only create/edit dialog for simple named catalogs.
class NamedCatalogNameDialog<T> extends ConsumerStatefulWidget {
  const NamedCatalogNameDialog({
    required this.addTitle,
    required this.editTitle,
    required this.nameLabel,
    required this.emptyNameMessage,
    required this.alreadyExistsMessage,
    required this.restoreConfirmMessage,
    required this.onSave,
    required this.onRestore,
    this.initialName = '',
    this.isEditing = false,
    super.key,
  });

  final String addTitle;
  final String editTitle;
  final String nameLabel;
  final String emptyNameMessage;
  final String alreadyExistsMessage;
  final String restoreConfirmMessage;
  final String initialName;
  final bool isEditing;
  final Future<({CatalogSaveResult result, T? restorable})> Function(
    String name,
  ) onSave;
  final Future<void> Function(T restorable) onRestore;

  @override
  ConsumerState<NamedCatalogNameDialog<T>> createState() =>
      _NamedCatalogNameDialogState<T>();
}

class _NamedCatalogNameDialogState<T>
    extends ConsumerState<NamedCatalogNameDialog<T>> {
  late final TextEditingController _controller;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ok = await submitCatalogDialogSave<T>(
        context: context,
        save: () => widget.onSave(_controller.text),
        messages: CatalogSaveUiMessages(
          emptyName: widget.emptyNameMessage,
          alreadyExists: widget.alreadyExistsMessage,
          restoreConfirm: widget.restoreConfirmMessage,
        ),
        onError: (message) {
          if (mounted) setState(() => _errorText = message);
        },
        onRestore: widget.onRestore,
      );
      if (ok && mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(widget.isEditing ? widget.editTitle : widget.addTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: widget.nameLabel,
          errorText: _errorText,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _onSubmit(),
      ),
      actions: DialogActions.cancelConfirm(
        context: context,
        onConfirm: _onSubmit,
      ),
    );
  }
}

/// Opens [NamedCatalogNameDialog] with caller-supplied titles.
Future<void> showNamedCatalogNameDialog<T>({
  required BuildContext context,
  required String addTitle,
  required String editTitle,
  required String nameLabel,
  required String emptyNameMessage,
  required String alreadyExistsMessage,
  required String restoreConfirmMessage,
  required Future<({CatalogSaveResult result, T? restorable})> Function(
    String name,
  ) onSave,
  required Future<void> Function(T restorable) onRestore,
  String initialName = '',
  bool isEditing = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return NamedCatalogNameDialog<T>(
        addTitle: addTitle,
        editTitle: editTitle,
        nameLabel: nameLabel,
        emptyNameMessage: emptyNameMessage,
        alreadyExistsMessage: alreadyExistsMessage,
        restoreConfirmMessage: restoreConfirmMessage,
        onSave: onSave,
        onRestore: onRestore,
        initialName: initialName,
        isEditing: isEditing,
      );
    },
  );
}

/// Convenience wrapper when [AppLocalizations] is already resolved.
Future<void> showPartUnitNameDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required Future<({CatalogSaveResult result, NamedCatalogItem? restorable})>
      Function(String name) onSave,
  required Future<void> Function(NamedCatalogItem restorable) onRestore,
  String initialName = '',
  bool isEditing = false,
}) {
  return showNamedCatalogNameDialog<NamedCatalogItem>(
    context: context,
    addTitle: l10n.partUnitAddTitle,
    editTitle: l10n.partUnitEditTitle,
    nameLabel: l10n.partUnitNameLabel,
    emptyNameMessage: l10n.partUnitNameRequired,
    alreadyExistsMessage: l10n.partUnitAlreadyExists,
    restoreConfirmMessage: l10n.partUnitRestoreConfirm,
    onSave: onSave,
    onRestore: onRestore,
    initialName: initialName,
    isEditing: isEditing,
  );
}
