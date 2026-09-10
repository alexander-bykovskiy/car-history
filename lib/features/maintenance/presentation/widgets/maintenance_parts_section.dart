import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/number_formatting.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../controllers/maintenance_form_notifier.dart';
import '../models/draft_part_line.dart';
import '../pages/maintenance_part_form_page.dart';

class MaintenancePartsSection extends ConsumerWidget {
  const MaintenancePartsSection({
    required this.form,
    required this.totalText,
    super.key,
  });

  final MaintenanceFormNotifier form;
  final String totalText;

  Future<void> _openPartForm(
    BuildContext context, {
    DraftPartLine? existing,
  }) async {
    final result = await Navigator.of(context).push<DraftPartLine>(
      MaterialPageRoute(
        builder: (context) => MaintenancePartFormPage(
          carId: form.carId,
          currencyCode: form.currencyCode,
          existing: existing,
          nextLocalId: form.nextPartLocalId,
        ),
      ),
    );
    if (result == null) return;
    form.upsertPart(result, replacing: existing);
  }

  Future<bool> _confirmRemovePart(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.maintenancePartDeleteConfirm,
    );
    return confirmed == true;
  }

  Widget _buildPartTile({
    required BuildContext context,
    required ThemeData theme,
    required NumberFormat amountFormat,
    required DraftPartLine line,
  }) {
    final lineTotal = line.lineTotal;
    final detailText = line.amount == null
        ? null
        : '${amountFormat.format(line.amount)} x ${formatFlexibleDouble(line.quantity)}';
    final currencyStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Dismissible(
      key: ValueKey('maintenance-part-${line.localId}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemovePart(context),
      onDismissed: (_) {
        form.removePart(line.localId);
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
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        title: Text.rich(
          TextSpan(
            text: line.name,
            children: detailText == null
                ? null
                : [
                    TextSpan(
                      text: ' • $detailText',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: line.comment == null || line.comment!.isEmpty
            ? null
            : Text(
                line.comment!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
        trailing: lineTotal == null
            ? null
            : Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: amountFormat.format(lineTotal),
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: ' ${form.currencyCode}',
                      style: currencyStyle,
                    ),
                  ],
                ),
              ),
        onTap: form.saving
            ? null
            : () => _openPartForm(context, existing: line),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final amountFormat = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = 2;
    final currencyStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final secondaryBase = theme.textTheme.bodySmall;
    final amountBase = theme.textTheme.titleMedium;
    final secondaryStyle = secondaryBase?.copyWith(
      fontSize: (secondaryBase.fontSize ?? 12) * 1.25,
      color: theme.colorScheme.onSurfaceVariant,
    );
    final amountStyle = amountBase?.copyWith(
      fontSize: (amountBase.fontSize ?? 16) * 1.25,
      fontWeight: FontWeight.bold,
    );
    final grandAmountText = amountFormat.format(form.grandTotal(totalText));
    final parts = form.parts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.maintenancePartsSection,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amountFormat.format(form.partsTotal),
                    style: theme.textTheme.titleMedium,
                  ),
                  TextSpan(
                    text: ' ${form.currencyCode}',
                    style: currencyStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (parts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.listEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else ...[
          const Divider(height: 1),
          for (var i = 0; i < parts.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _buildPartTile(
              context: context,
              theme: theme,
              amountFormat: amountFormat,
              line: parts[i],
            ),
          ],
        ],
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 32),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: form.saving ? null : () => _openPartForm(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.actionAdd),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${l10n.maintenanceGrandTotalLabel}: ',
                  style: secondaryStyle,
                ),
                TextSpan(
                  text: grandAmountText,
                  style: amountStyle,
                ),
                TextSpan(
                  text: ' ${form.currencyCode}',
                  style: secondaryStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
