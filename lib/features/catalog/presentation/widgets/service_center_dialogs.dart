import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../di/catalog_providers.dart';
import '../../domain/entities/named_place.dart';
import '../catalog_dialog_submit.dart';

Future<void> showServiceCenterDialog(
  BuildContext context, {
  PlaceCatalogItem? existing,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return _ServiceCenterDialog(existing: existing);
    },
  );
}

class _ServiceCenterDialog extends ConsumerStatefulWidget {
  const _ServiceCenterDialog({this.existing});

  final PlaceCatalogItem? existing;

  @override
  ConsumerState<_ServiceCenterDialog> createState() =>
      _ServiceCenterDialogState();
}

class _ServiceCenterDialogState extends ConsumerState<_ServiceCenterDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _addressController =
        TextEditingController(text: widget.existing?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ok = await _submit(
        context,
        ref,
        existing: widget.existing,
        name: _nameController.text,
        address: _addressController.text,
        onError: (message) {
          if (mounted) setState(() => _errorText = message);
        },
      );
      if (ok && mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        widget.existing == null
            ? l10n.serviceCenterAddTitle
            : l10n.serviceCenterEditTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.placeNameLabel,
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: l10n.placeAddressLabel,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
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

Future<bool> _submit(
  BuildContext context,
  WidgetRef ref, {
  required PlaceCatalogItem? existing,
  required String name,
  required String address,
  required ValueChanged<String> onError,
}) {
  final l10n = AppLocalizations.of(context);
  return submitCatalogDialogSave(
    context: context,
    save: () async {
      final save = ref.read(saveServiceCenterUseCaseProvider);
      final outcome = existing == null
          ? await save.create(rawName: name, address: address)
          : await save.update(existing, rawName: name, address: address);
      return (result: outcome.result, restorable: outcome.item);
    },
    messages: CatalogSaveUiMessages(
      emptyName: l10n.placeNameRequired,
      alreadyExists: l10n.placeAlreadyExists,
      restoreConfirm: l10n.placeRestoreConfirm,
    ),
    onError: onError,
    onRestore: (restorable) =>
        ref.read(restoreServiceCenterUseCaseProvider)(
      restorable as PlaceCatalogItem,
      address: address,
    ),
  );
}
