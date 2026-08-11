import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../../../shared/presentation/service_icons.dart';
import '../../di/catalog_providers.dart';
import '../../domain/entities/service_catalog_item.dart';
import '../catalog_dialog_submit.dart';

Future<void> showServiceNameDialog(
  BuildContext context, {
  ServiceCatalogItem? existing,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return _ServiceNameDialog(existing: existing);
    },
  );
}

class _ServiceNameDialog extends ConsumerStatefulWidget {
  const _ServiceNameDialog({this.existing});

  final ServiceCatalogItem? existing;

  @override
  ConsumerState<_ServiceNameDialog> createState() => _ServiceNameDialogState();
}

class _ServiceNameDialogState extends ConsumerState<_ServiceNameDialog> {
  late final TextEditingController _controller;
  late String _iconKey;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.name ?? '');
    _iconKey = ServiceIcons.normalize(widget.existing?.iconKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _ServiceIconPickerDialog(selectedKey: _iconKey);
      },
    );
    if (selected == null || !mounted) return;
    setState(() => _iconKey = selected);
  }

  Future<void> _onSubmit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ok = await _submitServiceName(
        context,
        ref,
        existing: widget.existing,
        name: _controller.text,
        iconKey: _iconKey,
        onError: (message) {
          if (mounted) setState(() => _errorText = message);
        },
      );
      if (ok && mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        widget.existing == null
            ? l10n.serviceAddTitle
            : l10n.serviceEditTitle,
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.serviceNameLabel,
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.serviceIconLabel,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _pickIcon,
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                  ),
                  child: Icon(
                    ServiceIcons.iconForKey(_iconKey),
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: DialogActions.cancelConfirm(
        context: context,
        onConfirm: _onSubmit,
      ),
    );
  }
}

class _ServiceIconPickerDialog extends StatelessWidget {
  const _ServiceIconPickerDialog({required this.selectedKey});

  final String selectedKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(l10n.serviceIconLabel),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in ServiceIcons.keys)
                Material(
                  color: key == selectedKey
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: key == selectedKey
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: key == selectedKey ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(key),
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        ServiceIcons.iconForKey(key),
                        color: key == selectedKey
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: DialogActions.cancelOnly(context: context),
    );
  }
}

Future<bool> _submitServiceName(
  BuildContext context,
  WidgetRef ref, {
  required ServiceCatalogItem? existing,
  required String name,
  required String iconKey,
  required ValueChanged<String> onError,
}) {
  final l10n = AppLocalizations.of(context);
  return submitCatalogDialogSave(
    context: context,
    save: () async {
      final save = ref.read(saveServiceUseCaseProvider);
      final outcome = existing == null
          ? await save.create(name, iconKey: iconKey)
          : await save.update(existing, name, iconKey: iconKey);
      return (result: outcome.result, restorable: outcome.item);
    },
    messages: CatalogSaveUiMessages(
      emptyName: l10n.serviceNameRequired,
      alreadyExists: l10n.serviceAlreadyExists,
      restoreConfirm: l10n.serviceRestoreConfirm,
    ),
    onError: onError,
    onRestore: (restorable) => ref.read(restoreServiceUseCaseProvider)(
      restorable as ServiceCatalogItem,
      name: name,
      iconKey: iconKey,
    ),
  );
}
