import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Shared tip banner used by swipe-delete and double-tap-edit hints.
class ListTipBanner extends StatelessWidget {
  const ListTipBanner({
    required this.icon,
    required this.message,
    required this.onDontShowAgain,
    super.key,
  });

  final IconData icon;
  final String message;
  final VoidCallback onDontShowAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tipBg = Color.alphaBlend(
      scheme.surface.withValues(alpha: 0.22),
      scheme.primaryContainer,
    );
    final onTip = scheme.onSurface;

    return Material(
      color: tipBg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: onTip),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(color: onTip),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onDontShowAgain,
                style: OutlinedButton.styleFrom(
                  foregroundColor: onTip,
                  side: BorderSide(color: onTip.withValues(alpha: 0.55)),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  textStyle: theme.textTheme.labelMedium,
                  minimumSize: Size.zero,
                ),
                child: Text(l10n.tipDontShowAgain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
