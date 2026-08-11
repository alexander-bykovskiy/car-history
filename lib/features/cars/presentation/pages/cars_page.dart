import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/car_limits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/soft_delete_list_view.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../di/cars_providers.dart';
import '../../domain/entities/car.dart';
import 'car_form_page.dart';

class CarsPage extends ConsumerStatefulWidget {
  const CarsPage({super.key});

  @override
  ConsumerState<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends ConsumerState<CarsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(carRepositoryProvider);
    final tipAsync = ref.watch(showSwipeDeleteTipProvider);
    final tipLoaded = tipAsync.hasValue;
    final showSwipeTip = tipAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.carsTitle)),
      floatingActionButton: StreamBuilder<List<CarListItem>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          final count = snapshot.data?.length ?? 0;
          final canAdd = count < kMaxCars;
          return Semantics(
            button: true,
            label: l10n.actionAdd,
            child: FloatingActionButton(
              onPressed: canAdd
                  ? () => _openForm(context)
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.carLimitReached(kMaxCars))),
                      );
                    },
              tooltip: l10n.actionAdd,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
      body: StreamBuilder<List<CarListItem>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.listLoadError));
          }
          if (!snapshot.hasData || !tipLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(child: Text(l10n.listEmpty));
          }

          return SoftDeleteListView<CarListItem>(
            items: items,
            showSwipeTip: showSwipeTip,
            onDismissSwipeTip: () =>
                ref.read(showSwipeDeleteTipProvider.notifier).dismiss(),
            dismissibleKeyOf: (item) => 'car-${item.id}',
            deleteConfirmMessage: l10n.carDeleteConfirm,
            canDismiss: (_) => items.length > 1,
            confirmDismiss: (context, item) => _confirmDelete(context),
            onDelete: (item) async {
              final result =
                  await ref.read(deleteCarUseCaseProvider)(item.id);
              if (result == CarDeleteResult.lastCar && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.carDeleteLastBlocked)),
                );
              }
            },
            itemBuilder: (context, item) {
              final theme = Theme.of(context);
              final yearText = item.year == null ? null : '${item.year}';
              return ListTile(
                onTap: () => _openForm(context, existing: item),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                minLeadingWidth: 64,
                leading: SizedBox(
                  width: 64,
                  height: 64,
                  child: _CarLeading(
                    photo: item.photo,
                    colorArgb: item.colorArgb,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.displayTitle),
                    if (yearText != null)
                      Text(
                        yearText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {CarListItem? existing}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CarFormPage(existing: existing),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final count = await ref.read(carRepositoryProvider).count();
    if (count <= 1) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.carDeleteLastBlocked)),
        );
      }
      return false;
    }
    if (!context.mounted) return false;
    return showDeleteConfirmDialog(context, message: l10n.carDeleteConfirm);
  }
}

class _CarLeading extends StatelessWidget {
  const _CarLeading({
    required this.photo,
    required this.colorArgb,
  });

  final Uint8List? photo;
  final int? colorArgb;

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          photo!,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _colorFallback(context),
        ),
      );
    }
    return _colorFallback(context);
  }

  Widget _colorFallback(BuildContext context) {
    final color = colorArgb != null ? Color(colorArgb!) : null;
    return CircleAvatar(
      radius: 32,
      backgroundColor:
          color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.directions_car_outlined,
        size: 32,
        color: color != null
            ? (color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white)
            : null,
      ),
    );
  }
}
