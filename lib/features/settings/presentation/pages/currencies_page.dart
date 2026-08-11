import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/currency_code.dart';
import '../../di/preferences_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../../../shared/presentation/soft_delete_list_view.dart';

class CurrenciesPage extends ConsumerStatefulWidget {
  const CurrenciesPage({super.key});

  @override
  ConsumerState<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends ConsumerState<CurrenciesPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final codesAsync = ref.watch(currencyCodesProvider);
    final tipAsync = ref.watch(showSwipeDeleteTipProvider);
    final tipLoaded = tipAsync.hasValue;
    final showSwipeTip = tipAsync.value ?? false;
    final codes = codesAsync.value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.currenciesEditTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCodeDialog(context),
        tooltip: l10n.actionAdd,
        child: const Icon(Icons.add),
      ),
      body: (codes == null || !tipLoaded)
          ? const Center(child: CircularProgressIndicator())
          : codes.isEmpty
              ? Center(child: Text(l10n.listEmpty))
              : SoftDeleteListView<String>(
                  items: codes,
                  showSwipeTip: showSwipeTip,
                  onDismissSwipeTip: () =>
                      ref.read(showSwipeDeleteTipProvider.notifier).dismiss(),
                  dismissibleKeyOf: (code) => 'currency-$code',
                  deleteConfirmMessage: l10n.currencyDeleteConfirm,
                  canDismiss: (_) => codes.length > 1,
                  onDelete: (code) async {
                    await ref.read(currencyCodesProvider.notifier).remove(code);
                  },
                  itemBuilder: (context, code) {
                    return ListTile(
                      onTap: () => _openCodeDialog(context, existing: code),
                      title: Text(code),
                    );
                  },
                ),
    );
  }

  Future<void> _openCodeDialog(
    BuildContext context, {
    String? existing,
  }) async {
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _CurrencyCodeDialog(existing: existing);
      },
    );
  }
}

class _CurrencyCodeDialog extends ConsumerStatefulWidget {
  const _CurrencyCodeDialog({this.existing});

  final String? existing;

  @override
  ConsumerState<_CurrencyCodeDialog> createState() =>
      _CurrencyCodeDialogState();
}

class _CurrencyCodeDialogState extends ConsumerState<_CurrencyCodeDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context);
    final normalized = CurrencyCode.normalize(_controller.text);
    if (normalized == null) {
      setState(() => _errorText = l10n.currencyCodeInvalid);
      return;
    }

    final notifier = ref.read(currencyCodesProvider.notifier);
    final existing = widget.existing;
    final ok = existing == null
        ? await notifier.add(normalized)
        : await notifier.rename(existing, normalized);

    if (!ok) {
      if (!mounted) return;
      setState(() => _errorText = l10n.currencyAlreadyExists);
      return;
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _onDelete() async {
    final existing = widget.existing;
    if (existing == null) return;

    final l10n = AppLocalizations.of(context);
    final codes = ref.read(currencyCodesProvider).value ?? const [];
    if (codes.length <= 1) {
      setState(() => _errorText = l10n.currencyCannotDeleteLast);
      return;
    }

    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.currencyDeleteConfirm,
    );
    if (confirmed != true) return;

    final ok = await ref.read(currencyCodesProvider.notifier).remove(existing);
    if (!ok) {
      if (!mounted) return;
      setState(() => _errorText = l10n.currencyCannotDeleteLast);
      return;
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.existing != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(isEdit ? l10n.currencyEditTitle : l10n.currencyAddTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        maxLength: 3,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
          _UpperCaseTextFormatter(),
        ],
        decoration: InputDecoration(
          labelText: l10n.currencyCodeLabel,
          hintText: l10n.currencyCodeHint,
          helperText: l10n.currencyCodeHelp,
          errorText: _errorText,
          border: const OutlineInputBorder(),
          counterText: '',
        ),
        textInputAction: TextInputAction.done,
        onChanged: (_) {
          if (_errorText != null) setState(() => _errorText = null);
        },
        onSubmitted: (_) => _onSubmit(),
      ),
      actions: [
        if (isEdit)
          TextButton(
            onPressed: _onDelete,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.actionDelete),
          ),
        ...DialogActions.cancelConfirm(
          context: context,
          onConfirm: _onSubmit,
        ),
      ],
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
