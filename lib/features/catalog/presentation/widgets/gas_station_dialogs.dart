import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/gas_station.dart';
import '../../di/catalog_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../catalog_dialog_submit.dart';

Future<GasStationChainItem?> showGasStationChainDialog(
  BuildContext context, {
  GasStationChainItem? existing,
}) {
  return showDialog<GasStationChainItem>(
    context: context,
    builder: (dialogContext) {
      return _ChainDialog(existing: existing);
    },
  );
}

Future<bool> showGasStationLocationDialog(
  BuildContext context, {
  required GasStationChainItem chain,
  GasStationLocationItem? existing,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return _LocationDialog(
        chain: chain,
        existing: existing,
      );
    },
  );
  return result == true;
}

class _ChainDialog extends ConsumerStatefulWidget {
  const _ChainDialog({this.existing});

  final GasStationChainItem? existing;

  @override
  ConsumerState<_ChainDialog> createState() => _ChainDialogState();
}

class _ChainDialogState extends ConsumerState<_ChainDialog> {
  late final TextEditingController _nameController;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final chain = await _submitChain(
        context,
        ref,
        existing: widget.existing,
        name: _nameController.text,
        onError: (message) {
          if (mounted) setState(() => _errorText = message);
        },
      );
      if (chain != null && mounted) Navigator.of(context).pop(chain);
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
            ? l10n.gasStationAddTitle
            : l10n.gasStationEditTitle,
      ),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.placeNameLabel,
          errorText: _errorText,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _onSubmit(),
      ),
      actions: DialogActions.cancelConfirm(
        context: context,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: _onSubmit,
      ),
    );
  }
}

class _LocationDialog extends ConsumerStatefulWidget {
  const _LocationDialog({
    required this.chain,
    this.existing,
  });

  final GasStationChainItem chain;
  final GasStationLocationItem? existing;

  @override
  ConsumerState<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends ConsumerState<_LocationDialog> {
  late final TextEditingController _addressController;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: widget.existing?.address ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ok = await _submitLocation(
        context,
        ref,
        chain: widget.chain,
        existing: widget.existing,
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
            ? l10n.gasStationAddAddressTitle
            : l10n.gasStationEditAddressTitle,
      ),
      content: TextField(
        controller: _addressController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.placeAddressLabel,
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

Future<GasStationChainItem?> _submitChain(
  BuildContext context,
  WidgetRef ref, {
  required GasStationChainItem? existing,
  required String name,
  required ValueChanged<String> onError,
}) {
  final l10n = AppLocalizations.of(context);
  return submitCatalogDialogSaveForItem<GasStationChainItem>(
    context: context,
    save: () async {
      final save = ref.read(saveGasStationChainUseCaseProvider);
      final outcome = existing == null
          ? await save.create(name)
          : await save.update(existing, name);
      return (result: outcome.result, item: outcome.chain);
    },
    messages: CatalogSaveUiMessages(
      emptyName: l10n.placeNameRequired,
      alreadyExists: l10n.placeAlreadyExists,
      restoreConfirm: l10n.placeRestoreConfirm,
    ),
    onError: onError,
    onRestore: (chain) => ref.read(restoreGasStationChainUseCaseProvider)(
      chain,
      name: name,
    ),
  );
}

Future<bool> _submitLocation(
  BuildContext context,
  WidgetRef ref, {
  required GasStationChainItem chain,
  required GasStationLocationItem? existing,
  required String address,
  required ValueChanged<String> onError,
}) async {
  final l10n = AppLocalizations.of(context);
  final trimmed = address.trim();
  if (trimmed.isEmpty) {
    onError(l10n.placeAddressRequired);
    return false;
  }

  return submitCatalogDialogSave(
    context: context,
    save: () async {
      final save = ref.read(saveGasStationLocationUseCaseProvider);
      final outcome = existing == null
          ? await save.create(chainId: chain.id, address: trimmed)
          : await save.update(existing, address: trimmed);
      return (result: outcome.result, restorable: outcome.location);
    },
    messages: CatalogSaveUiMessages(
      emptyName: l10n.placeAddressRequired,
      alreadyExists: l10n.placeAlreadyExists,
      restoreConfirm: l10n.placeRestoreConfirm,
    ),
    onError: onError,
    onRestore: (restorable) =>
        ref.read(restoreGasStationLocationUseCaseProvider)(
      restorable as GasStationLocationItem,
      address: trimmed,
    ),
  );
}
