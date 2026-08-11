import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'soft_delete_list_view.dart';

/// Shared soft-delete catalog list (fuel types, parts, …).
///
/// Tip visibility is injected by the caller so this widget stays free of
/// feature-layer preference providers.
class CatalogListPage<T> extends StatefulWidget {
  const CatalogListPage({
    required this.title,
    required this.stream,
    required this.nameOf,
    required this.idOf,
    required this.isDeletedOf,
    required this.deleteConfirmMessage,
    required this.dismissibleKeyPrefix,
    required this.onDelete,
    required this.onRestore,
    required this.onAdd,
    required this.onEdit,
    this.showSwipeTip = false,
    this.onDismissSwipeTip,
    this.trailingBuilder,
    this.leadingBuilder,
    this.subtitleOf,
    this.errorMessage,
    super.key,
  });

  final String title;
  final Stream<List<T>> stream;
  final String Function(T item) nameOf;
  final int Function(T item) idOf;
  final bool Function(T item) isDeletedOf;
  final String deleteConfirmMessage;
  final String dismissibleKeyPrefix;
  final Future<void> Function(T item) onDelete;
  final Future<void> Function(T item) onRestore;
  final VoidCallback onAdd;
  final void Function(T item) onEdit;
  final bool showSwipeTip;
  final VoidCallback? onDismissSwipeTip;
  final Widget? Function(BuildContext context, T item)? trailingBuilder;
  final Widget? Function(BuildContext context, T item)? leadingBuilder;
  final String? Function(T item)? subtitleOf;
  final String Function(Object error)? errorMessage;

  @override
  State<CatalogListPage<T>> createState() => _CatalogListPageState<T>();
}

class _CatalogListPageState<T> extends State<CatalogListPage<T>> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: Semantics(
        button: true,
        label: l10n.actionAdd,
        child: FloatingActionButton(
          onPressed: widget.onAdd,
          tooltip: l10n.actionAdd,
          child: const Icon(Icons.add),
        ),
      ),
      body: StreamBuilder<List<T>>(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error!;
            final message =
                widget.errorMessage?.call(error) ?? l10n.listLoadError;
            return Center(child: Text(message));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(child: Text(l10n.listEmpty));
          }

          return SoftDeleteListView<T>(
            items: items,
            showSwipeTip: widget.showSwipeTip,
            onDismissSwipeTip: widget.onDismissSwipeTip,
            dismissibleKeyOf: (item) =>
                '${widget.dismissibleKeyPrefix}-${widget.idOf(item)}',
            deleteConfirmMessage: widget.deleteConfirmMessage,
            onDelete: widget.onDelete,
            canDismiss: (item) => !widget.isDeletedOf(item),
            isDimmed: widget.isDeletedOf,
            itemBuilder: (context, item) {
              final deleted = widget.isDeletedOf(item);
              final subtitle = widget.subtitleOf?.call(item);
              final customTrailing =
                  widget.trailingBuilder?.call(context, item);

              return ListTile(
                leading: widget.leadingBuilder?.call(context, item),
                onTap: deleted ? null : () => widget.onEdit(item),
                title: Text(widget.nameOf(item)),
                subtitle: subtitle == null || subtitle.isEmpty
                    ? null
                    : Text(subtitle),
                trailing: customTrailing ??
                    (deleted
                        ? IconButton(
                            tooltip: l10n.actionRestore,
                            icon: const Icon(Icons.restore),
                            onPressed: () => widget.onRestore(item),
                          )
                        : null),
              );
            },
          );
        },
      ),
    );
  }
}
