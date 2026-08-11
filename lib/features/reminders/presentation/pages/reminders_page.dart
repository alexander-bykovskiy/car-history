import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units.dart';
import '../../../settings/di/preferences_providers.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../di/reminder_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/soft_delete_list_view.dart';
import '../../../../theme/car_theme_config.dart';
import '../controllers/reminders_list_controller.dart';
import 'reminder_form_page.dart';

class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  late final RemindersListController _list = RemindersListController();
  StreamSubscription<List<ReminderListItem>>? _itemsSub;
  ReminderRepository? _boundRepository;
  List<ReminderListItem>? _items;
  Object? _streamError;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    ref.listenManual(reminderRepositoryProvider, (previous, next) {
      _bindRepository(next);
    }, fireImmediately: true);
  }

  void _bindRepository(ReminderRepository repository) {
    if (_boundRepository == repository) return;
    _itemsSub?.cancel();
    _boundRepository = repository;
    _itemsSub = repository.watchAll().listen(
      (items) {
        if (!mounted) return;
        setState(() {
          _items = items;
          _streamError = null;
        });
        _list.onItemsChanged(ref.read(odometerRepositoryProvider), items);
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(() => _streamError = error);
      },
    );
  }

  @override
  void dispose() {
    _itemsSub?.cancel();
    _list.dispose();
    super.dispose();
  }

  Future<void> _openForm(BuildContext context, {ReminderRecord? existing}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => ReminderFormPage(existing: existing),
      ),
    );
    final items = _items;
    if (items == null) return;
    // Force odometer refresh after edits (fuel/reminder changes).
    _list.refreshOdometers(ref.read(odometerRepositoryProvider), items);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final distance = ref.watch(distanceUnitProvider).value ??
        DistanceUnit.kilometers;
    final tipAsync = ref.watch(showSwipeDeleteTipProvider);
    final tipLoaded = tipAsync.hasValue;
    final showSwipeTip = tipAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.remindersTitle)),
      floatingActionButton: Semantics(
        button: true,
        label: l10n.actionAdd,
        child: FloatingActionButton(
          onPressed: () => _openForm(context),
          tooltip: l10n.actionAdd,
          child: const Icon(Icons.add),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (_streamError != null) {
            return Center(child: Text(l10n.listLoadError));
          }
          final items = _items;
          if (items == null || !tipLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return Center(child: Text(l10n.listEmpty));
          }

          return ListenableBuilder(
            listenable: _list,
            builder: (context, _) {
              final now = DateTime.now();
              final sortedItems = _list.sortedItems(items, now: now);

              return SoftDeleteListView<ReminderListItem>(
                items: sortedItems,
                showSwipeTip: showSwipeTip,
                onDismissSwipeTip: () =>
                    ref.read(showSwipeDeleteTipProvider.notifier).dismiss(),
                dismissibleKeyOf: (item) => 'reminder-${item.reminder.id}',
                deleteConfirmMessage: l10n.reminderDeleteConfirm,
                canDismiss: (item) => !item.reminder.isDeleted,
                isDimmed: (item) =>
                    item.reminder.isDeleted || item.reminder.isCompleted,
                onDelete: (item) async {
                  await ref.read(deleteReminderUseCaseProvider)(item.reminder.id);
                },
                itemBuilder: (context, item) {
                  final reminder = item.reminder;
                  final theme = Theme.of(context);
                  final titleStyle = theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: reminder.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: reminder.isCompleted
                        ? theme.colorScheme.onSurfaceVariant
                        : null,
                  );
                  final detailsStyle = theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  );

                  return InkWell(
                    onTap: reminder.isDeleted
                        ? null
                        : () => _openForm(context, existing: reminder),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reminder.title,
                                  style: titleStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _list.detailsLine(
                                    item,
                                    l10n: l10n,
                                    locale: locale,
                                    unit: distance,
                                  ),
                                  style: detailsStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (reminder.isDeleted)
                            IconButton(
                              tooltip: l10n.actionRestore,
                              icon: const Icon(Icons.restore),
                              onPressed: () =>
                                  ref.read(restoreReminderUseCaseProvider)(
                                reminder.id,
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 24,
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: _ReminderStatusMarker(
                                level: _list.markerLevel(reminder, now: now),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ReminderStatusMarker extends StatelessWidget {
  const _ReminderStatusMarker({required this.level});

  /// `null` = cancelled / completed — no marker.
  final ReminderAlertLevel? level;

  @override
  Widget build(BuildContext context) {
    const size = 12.0;
    if (level == null) {
      return const SizedBox(width: size, height: size);
    }

    final color = switch (level!) {
      ReminderAlertLevel.due => ThemeSemantics.alertDue,
      ReminderAlertLevel.soon => ThemeSemantics.alertSoon,
      ReminderAlertLevel.none => ThemeSemantics.alertNone,
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
