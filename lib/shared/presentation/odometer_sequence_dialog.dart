import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/odometer_sequence.dart';
import '../../l10n/app_localizations.dart';
import 'dialog_actions.dart';

/// Confirms continuing when an odometer reading breaks chronological order.
///
/// Returns `true` if the user chooses to continue, `false` otherwise.
Future<bool> showOdometerSequenceWarningDialog({
  required BuildContext context,
  required OdometerSequenceWarning warning,
  required OdometerNeighbors neighbors,
  required double Function(double kilometers) displayFromKilometers,
  required String distanceUnitLabel,
  required String footer,
}) async {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toString();
  final numberFormat = NumberFormat.decimalPattern(locale)
    ..maximumFractionDigits = 0;
  final unit = distanceUnitLabel.toUpperCase();

  final paragraphs = <String>[];
  if (warning.lowerThanEarlier && neighbors.previousKm != null) {
    paragraphs.add(
      l10n.fuelingOdometerLowerMessage(
        numberFormat.format(displayFromKilometers(neighbors.previousKm!)),
        unit,
      ),
    );
  }
  if (warning.higherThanLater && neighbors.nextKm != null) {
    paragraphs.add(
      l10n.fuelingOdometerHigherMessage(
        numberFormat.format(displayFromKilometers(neighbors.nextKm!)),
        unit,
      ),
    );
  }
  paragraphs.add(footer);

  final title = warning.lowerThanEarlier && warning.higherThanLater
      ? l10n.fuelingOdometerSequenceTitle
      : warning.lowerThanEarlier
          ? l10n.fuelingOdometerLowerTitle
          : l10n.fuelingOdometerHigherTitle;

  final proceed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(title),
        content: Text(paragraphs.join('\n\n')),
        actions: DialogActions.cancelConfirm(
          context: dialogContext,
          onConfirm: () => Navigator.of(dialogContext).pop(true),
          confirmLabel: l10n.actionContinue,
        ),
      );
    },
  );
  return proceed == true;
}
