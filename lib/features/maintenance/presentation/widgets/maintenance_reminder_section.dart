import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/unit_labels.dart';
import '../../../../core/units.dart';
import '../../domain/entities/reminder_draft.dart';
import '../controllers/maintenance_form_notifier.dart';
import '../pages/maintenance_reminder_form_page.dart';
import '../../../../core/number_formatting.dart';

class MaintenanceReminderSection extends StatelessWidget {
  const MaintenanceReminderSection({
    required this.form,
    required this.distanceUnit,
    this.odometerText,
    super.key,
  });

  final MaintenanceFormNotifier form;
  final DistanceUnit distanceUnit;

  /// Current odometer field from the maintenance form (display units).
  final String? odometerText;

  String _reminderSummary(
    AppLocalizations l10n,
    String locale,
    ReminderDraft draft,
  ) {
    final parts = <String>[];
    if (draft.dueAt != null) {
      parts.add(DateFormat.yMMMd(locale).format(draft.dueAt!));
    }
    if (draft.dueOdometerKm != null) {
      final value = distanceUnit.fromKilometers(draft.dueOdometerKm!);
      parts.add(
        '${formatFlexibleDouble(value)} ${distanceUnitShort(l10n, distanceUnit)}',
      );
    }
    return parts.join(' · ');
  }

  Future<void> _openReminderForm(BuildContext context) async {
    final result =
        await Navigator.of(context).push<MaintenanceReminderFormResult>(
      MaterialPageRoute(
        builder: (context) => MaintenanceReminderFormPage(
          carId: form.carId,
          distanceUnit: distanceUnit,
          initial: form.reminderDraft,
          prefillOdometerText:
              form.reminderDraft == null ? odometerText : null,
        ),
      ),
    );
    if (result == null) return;
    if (result.removed) {
      form.clearReminderDraft();
    } else {
      form.setReminderDraft(result.draft);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final draft = form.reminderDraft;

    if (draft == null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: form.saving ? null : () => _openReminderForm(context),
          icon: const Icon(Icons.notification_important_outlined),
          label: Text(l10n.maintenanceAddReminder),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
            side: BorderSide(color: theme.colorScheme.outline),
          ),
        ),
      );
    }

    return Dismissible(
      key: const ValueKey('maintenance-reminder-draft'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        final confirmed = await showDeleteConfirmDialog(
          context,
          message: l10n.reminderDeleteConfirm,
        );
        return confirmed == true;
      },
      onDismissed: (_) => form.clearReminderDraft(),
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
      child: Material(
        color: theme.colorScheme.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: form.saving ? null : () => _openReminderForm(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notification_important_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.maintenanceEditReminder,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _reminderSummary(l10n, locale, draft),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
