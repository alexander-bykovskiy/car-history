import 'package:flutter/material.dart';

import 'delete_confirm_dialog.dart';
import 'swipe_delete_tip.dart';

/// Shared tip + Dismissible list chrome for soft-delete / swipe-delete screens.
class SoftDeleteListView<T> extends StatelessWidget {
  const SoftDeleteListView({
    required this.items,
    required this.dismissibleKeyOf,
    required this.deleteConfirmMessage,
    required this.onDelete,
    required this.itemBuilder,
    this.showSwipeTip = false,
    this.onDismissSwipeTip,
    this.canDismiss,
    this.confirmDismiss,
    this.isDimmed,
    this.dimOpacity = 0.45,
    super.key,
  });

  final List<T> items;
  final String Function(T item) dismissibleKeyOf;
  final String deleteConfirmMessage;
  final Future<void> Function(T item) onDelete;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool showSwipeTip;
  final VoidCallback? onDismissSwipeTip;
  final bool Function(T item)? canDismiss;
  final Future<bool> Function(BuildContext context, T item)? confirmDismiss;
  final bool Function(T item)? isDimmed;
  final double dimOpacity;

  @override
  Widget build(BuildContext context) {
    final tipCount = showSwipeTip ? 1 : 0;

    return ListView.separated(
      itemCount: items.length + tipCount,
      separatorBuilder: (context, index) {
        if (showSwipeTip && index == 0) {
          return const SizedBox.shrink();
        }
        return const Divider(height: 1);
      },
      itemBuilder: (context, index) {
        if (showSwipeTip && index == 0) {
          return SwipeDeleteTip(
            onDontShowAgain: () => onDismissSwipeTip?.call(),
          );
        }

        final item = items[index - tipCount];
        final theme = Theme.of(context);
        final child = itemBuilder(context, item);
        final dimmed = isDimmed?.call(item) ?? false;
        final wrapped = dimmed ? Opacity(opacity: dimOpacity, child: child) : child;
        final dismissible = canDismiss?.call(item) ?? true;

        if (!dismissible) {
          return wrapped;
        }

        return Dismissible(
          key: ValueKey(dismissibleKeyOf(item)),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            if (confirmDismiss != null) {
              return confirmDismiss!(context, item);
            }
            return showDeleteConfirmDialog(
              context,
              message: deleteConfirmMessage,
            );
          },
          onDismissed: (_) {
            onDelete(item);
          },
          background: ColoredBox(
            color: theme.colorScheme.error,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.onError,
                ),
              ),
            ),
          ),
          child: wrapped,
        );
      },
    );
  }
}
