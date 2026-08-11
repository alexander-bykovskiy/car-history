import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'destructive_outlined_icon_button.dart';

/// Bottom row used by entity forms: optional delete + primary save.
///
/// When [isSaving] is true, both actions are disabled and save shows a spinner.
class FormActionsBar extends StatelessWidget {
  const FormActionsBar({
    required this.isSaving,
    required this.onSave,
    this.onDelete,
    this.deleteTooltip,
    this.saveLabel,
    this.deleteGap = 8,
    super.key,
  });

  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final String? deleteTooltip;
  final String? saveLabel;
  final double deleteGap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        if (onDelete != null) ...[
          DestructiveOutlinedIconButton(
            onPressed: isSaving ? null : onDelete,
            tooltip: deleteTooltip ?? l10n.actionDelete,
          ),
          SizedBox(width: deleteGap),
        ],
        Expanded(
          child: Semantics(
            button: true,
            enabled: !isSaving,
            label: saveLabel ?? l10n.actionSave,
            child: FilledButton(
              onPressed: isSaving ? null : onSave,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(saveLabel ?? l10n.actionSave),
            ),
          ),
        ),
      ],
    );
  }
}
