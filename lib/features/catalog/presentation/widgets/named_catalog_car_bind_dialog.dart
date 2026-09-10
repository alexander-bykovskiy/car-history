import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/dialog_actions.dart';
import '../../../../app/di/app_providers.dart';
import '../../../cars/domain/entities/car.dart';
import '../../domain/entities/named_catalog_item.dart';
import '../catalog_dialog_submit.dart';

class NamedCatalogCarBindLabels {
  const NamedCatalogCarBindLabels({
    required this.addTitle,
    required this.editTitle,
    required this.nameLabel,
    required this.nameRequired,
    required this.alreadyExists,
    required this.restoreConfirm,
    required this.carsRequired,
  });

  final String addTitle;
  final String editTitle;
  final String nameLabel;
  final String nameRequired;
  final String alreadyExists;
  final String restoreConfirm;
  final String carsRequired;
}

typedef NamedCatalogLinkedCarIds = Future<List<int>> Function(int itemId);

typedef NamedCatalogCarBindSubmit = Future<NamedCatalogSaveOutcome> Function({
  required NamedCatalogItem? existing,
  required String name,
  required List<int> carIds,
  required bool appliesToAll,
});

typedef NamedCatalogCarBindRestore = Future<void> Function(
  NamedCatalogItem item, {
  required List<int> carIds,
  required bool appliesToAll,
});

/// Shared name + multi-select cars dialog for fuel types / parts.
class NamedCatalogCarBindDialog extends ConsumerStatefulWidget {
  const NamedCatalogCarBindDialog({
    required this.labels,
    required this.loadLinkedCarIds,
    required this.onSubmit,
    required this.onRestore,
    this.existing,
    super.key,
  });

  final NamedCatalogCarBindLabels labels;
  final NamedCatalogItem? existing;
  final NamedCatalogLinkedCarIds loadLinkedCarIds;
  final NamedCatalogCarBindSubmit onSubmit;
  final NamedCatalogCarBindRestore onRestore;

  @override
  ConsumerState<NamedCatalogCarBindDialog> createState() =>
      _NamedCatalogCarBindDialogState();
}

class _NamedCatalogCarBindDialogState
    extends ConsumerState<NamedCatalogCarBindDialog> {
  late final TextEditingController _controller;
  String? _errorText;
  List<CarListItem> _cars = const [];
  final Set<int> _selectedCarIds = {};
  bool _loadStarted = false;
  bool _carsLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.name ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadStarted) return;
    _loadStarted = true;
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await ref.read(carRepositoryProvider).listAll();
    var selected = <int>{};
    if (widget.existing == null) {
      selected = cars.map((item) => item.id).toSet();
    } else {
      final linked = await widget.loadLinkedCarIds(widget.existing!.id);
      selected = linked.isEmpty
          ? cars.map((item) => item.id).toSet()
          : linked.toSet();
    }
    if (!mounted) return;
    setState(() {
      _cars = cars;
      _selectedCarIds
        ..clear()
        ..addAll(selected);
      _carsLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _appliesToAll =>
      _cars.isNotEmpty && _selectedCarIds.length == _cars.length;

  Future<void> _onSubmit() async {
    if (_saving) return;
    if (_selectedCarIds.isEmpty) {
      setState(() => _errorText = widget.labels.carsRequired);
      return;
    }

    setState(() => _saving = true);
    try {
      final outcome = await widget.onSubmit(
        existing: widget.existing,
        name: _controller.text,
        carIds: _selectedCarIds.toList(),
        appliesToAll: _appliesToAll,
      );
      if (!mounted) return;
      final ok = await submitCatalogDialogSave<NamedCatalogItem>(
        context: context,
        save: () async => (
          result: outcome.result,
          restorable: outcome.item,
        ),
        messages: CatalogSaveUiMessages(
          emptyName: widget.labels.nameRequired,
          alreadyExists: widget.labels.alreadyExists,
          restoreConfirm: widget.labels.restoreConfirm,
        ),
        onError: (message) {
          if (mounted) setState(() => _errorText = message);
        },
        onRestore: (restorable) => widget.onRestore(
          restorable,
          carIds: _selectedCarIds.toList(),
          appliesToAll: _appliesToAll,
        ),
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
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );

    if (_carsLoading) {
      return AlertDialog(
        shape: shape,
        content: const SizedBox(
          width: 360,
          height: 96,
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      shape: shape,
      title: Text(
        widget.existing == null
            ? widget.labels.addTitle
            : widget.labels.editTitle,
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: widget.labels.nameLabel,
                  errorText: _errorText,
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.fuelTypeCarsLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (_cars.isEmpty)
                Text(l10n.listEmpty)
              else
                ..._cars.map((item) {
                  final checked = _selectedCarIds.contains(item.id);
                  return CheckboxListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    contentPadding: EdgeInsets.zero,
                    value: checked,
                    title: Text(item.displayTitle),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedCarIds.add(item.id);
                        } else {
                          _selectedCarIds.remove(item.id);
                        }
                        if (_errorText == widget.labels.carsRequired) {
                          _errorText = null;
                        }
                      });
                    },
                  );
                }),
            ],
          ),
        ),
      ),
      actions: DialogActions.cancelConfirm(
        context: context,
        onConfirm: _onSubmit,
      ),
    );
  }
}
