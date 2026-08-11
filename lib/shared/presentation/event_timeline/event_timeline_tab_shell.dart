import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';

/// Shared gate + scaffold for fueling / maintenance timeline tabs:
/// selected-car loading, empty car, prefs readiness, FAB, and body.
///
/// Callers resolve the selected car (e.g. via `selectedCarProvider`) and pass
/// [carId] / [carSelectionLoading] so this shared widget stays feature-free.
class EventTimelineTabShell extends ConsumerWidget {
  const EventTimelineTabShell({
    required this.carId,
    required this.carSelectionLoading,
    required this.prefsReady,
    required this.onAdd,
    required this.body,
    super.key,
  });

  /// Selected car id, or null when none is selected.
  final int? carId;

  /// True while the selection stream has not produced a value yet.
  final bool carSelectionLoading;

  /// Watched prefs gate: return false while any required preference is loading.
  final bool Function(WidgetRef ref) prefsReady;

  final Future<void> Function(
    BuildContext context,
    WidgetRef ref,
    int carId,
  ) onAdd;

  final Widget Function(
    BuildContext context,
    WidgetRef ref,
    int carId,
  ) body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (carSelectionLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final id = carId;

    if (id == null) {
      return Center(child: Text(l10n.listEmpty));
    }

    if (!prefsReady(ref)) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      primary: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await onAdd(context, ref, id);
        },
        tooltip: l10n.actionAdd,
        child: const Icon(Icons.add),
      ),
      body: body(context, ref, id),
    );
  }
}
